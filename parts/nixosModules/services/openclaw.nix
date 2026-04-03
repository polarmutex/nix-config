{
  flake.nixosModules.openclaw-service = {
    config,
    lib,
    pkgs,
    inputs,
    ...
  }: let
    inherit (config.networking) domain;
    cfg = config.services.openclaw;
    settingsFormat = pkgs.formats.json {};

    # Minimal gateway config - only what's required
    # Port, bind, and auth are handled via CLI flags and env vars
    gatewayConfig =
      {
        gateway = {
          mode = "local"; # Required: enables gateway service (no CLI flag for this)
        };
      }
      // lib.optionalAttrs (cfg.telegram.enable && cfg.telegram.tokenFile != null) {
        plugins.entries.telegram.enabled = true;
        channels.telegram = {
          enabled = true;
          tokenFile = "${cfg.telegram.tokenFile}";
          allowFrom = ["PolarVortexBot"];
          groups = {
            "*" = {
              requireMention = true;
            };
          };
          # accounts.default.enabled = true;
        };
      }
      # // lib.optionalAttrs (cfg.discord.enable && cfg.discord.tokenFile != null) {
      #   plugins.entries.discord.enabled = true;
      #   channels.discord.enabled = true;
      # }
      // cfg.extraGatewayConfig;

    gatewayConfigFile = settingsFormat.generate "openclaw-gateway.json" gatewayConfig;
  in {
    options.services.openclaw = {
      enable = lib.mkEnableOption "OpenClaw hardened agent infrastructure";

      package = lib.mkOption {
        type = lib.types.package;
        default =
          pkgs.openclaw or (pkgs.stdenv.mkDerivation rec {
            pname = "openclaw";
            inherit (cfg) version;
            nativeBuildInputs = with pkgs; [nodejs_22 cacert];
            buildInputs = with pkgs; [nodejs_22];
            dontUnpack = true;
            buildPhase = ''
              export HOME=$TMPDIR
              export npm_config_cache=$TMPDIR/npm-cache
              mkdir -p $npm_config_cache
              npm install --global --prefix=$out openclaw@${version}
            '';
            installPhase = ''
              mkdir -p $out/bin
              for f in $out/lib/node_modules/.bin/*; do
                name=$(basename $f)
                [ ! -e "$out/bin/$name" ] && ln -sf "$f" "$out/bin/$name"
              done
            '';
            meta.description = "OpenClaw agent infrastructure";
          });
        defaultText = lib.literalExpression "pkgs.openclaw (auto-built from npm if not in nixpkgs)";
        description = "The OpenClaw package to use. Auto-fetched from npm if not provided.";
      };

      version = lib.mkOption {
        type = lib.types.str;
        default = "2026.2.6-3";
        description = "OpenClaw version (used for npm/docker install fallback).";
      };

      domain = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "agents.example.com";
        description = "Public domain for Caddy TLS. Leave empty to disable Caddy.";
      };

      gatewayPort = lib.mkOption {
        type = lib.types.port;
        default = 3000;
        description = "Local port for the OpenClaw gateway (bound to localhost only).";
      };

      authTokenFile = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/openclaw/auth-token";
        description = "Path to file containing the gateway auth token. Auto-generated if missing.";
      };

      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/openclaw";
        description = "State directory for OpenClaw data.";
      };

      # --- Tool Security ---
      toolSecurity = lib.mkOption {
        type = lib.types.enum ["deny" "allowlist"];
        default = "allowlist";
        description = ''
          Tool execution security mode.
          "deny" blocks all tool execution. "allowlist" permits only listed tools.
          Note: "full" mode is intentionally excluded — it grants unrestricted access.
        '';
      };

      toolAllowlist = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "read"
          "write"
          "edit"
          "web_search"
          "web_fetch"
          "message"
          "tts"
        ];
        description = ''
          Tools permitted when toolSecurity = "allowlist".
          Defaults are safe read/write/search tools. exec, browser, nodes excluded by default.
          Add "exec" only if you understand the implications.
        '';
      };

      # --- Plugins ---
      telegram = {
        enable = lib.mkEnableOption "Telegram plugin";
        tokenFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "Path to file containing Telegram bot token.";
        };
      };

      discord = {
        enable = lib.mkEnableOption "Discord plugin";
        tokenFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "Path to file containing Discord bot token.";
        };
      };

      # --- Model ---
      modelProvider = lib.mkOption {
        type = lib.types.str;
        default = "anthropic";
        description = "Default model provider (anthropic, openai, ollama, etc).";
      };

      modelApiKeyFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to file containing model API key.";
      };

      # --- Updates ---
      autoUpdate = {
        enable = lib.mkEnableOption "automatic OpenClaw updates via systemd timer";
        schedule = lib.mkOption {
          type = lib.types.str;
          default = "weekly";
          description = "systemd calendar expression for update checks.";
        };
      };

      # --- Advanced ---
      extraGatewayConfig = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = "Extra attributes merged into gateway config.";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Open firewall ports (443 for HTTPS, 22 for SSH).";
      };
    };

    config = lib.mkIf cfg.enable {
      # ── Packages ──
      environment.systemPackages = [cfg.package];

      # ── Auth token generation ──
      systemd.tmpfiles.rules = [
        "d ${cfg.dataDir} 0750 openclaw openclaw -"
      ];

      # ── Main gateway service ──
      systemd.services.openclaw-gateway = {
        description = "OpenClaw Gateway (hardened)";
        after = ["network-online.target"];
        wants = ["network-online.target"];
        wantedBy = ["multi-user.target"];

        preStart = ''
          # Auto-generate auth token if missing
          if [ ! -f "${cfg.authTokenFile}" ]; then
            ${pkgs.openssl}/bin/openssl rand -hex 32 > "${cfg.authTokenFile}"
            chmod 600 "${cfg.authTokenFile}"
            echo "Generated new gateway auth token at ${cfg.authTokenFile}"
          fi
        '';

        serviceConfig = {
          Type = "simple";
          ExecStart = let
            startScript = pkgs.writeShellScript "openclaw-start" ''
              export OPENCLAW_GATEWAY_TOKEN=$(cat "$CREDENTIALS_DIRECTORY/auth-token")

              # Load model API key if configured
              ${lib.optionalString (cfg.modelApiKeyFile != null) ''
                export OPENCLAW_MODEL_API_KEY=$(cat "$CREDENTIALS_DIRECTORY/model-api-key")
              ''}

              # Load telegram token if enabled
              ${lib.optionalString (cfg.telegram.enable && cfg.telegram.tokenFile != null) ''
                export OPENCLAW_TELEGRAM_TOKEN=$(cat "$CREDENTIALS_DIRECTORY/telegram-token")
              ''}

              # Load discord token if enabled
              ${lib.optionalString (cfg.discord.enable && cfg.discord.tokenFile != null) ''
                export OPENCLAW_DISCORD_TOKEN=$(cat "$CREDENTIALS_DIRECTORY/discord-token")
              ''}

              # Use 'gateway' (foreground mode) instead of 'gateway start' (checks for systemd user service)
              exec ${cfg.package}/bin/openclaw gateway \
                --port ${toString cfg.gatewayPort} \
                --bind loopback
            '';
          in "${startScript}";
          Restart = "on-failure";
          RestartSec = 5;
          WorkingDirectory = cfg.dataDir;
          StateDirectory = "openclaw";
          LoadCredential =
            ["auth-token:${cfg.authTokenFile}"]
            ++ lib.optional (cfg.telegram.enable && cfg.telegram.tokenFile != null)
            "telegram-token:${cfg.telegram.tokenFile}"
            ++ lib.optional (cfg.discord.enable && cfg.discord.tokenFile != null)
            "discord-token:${cfg.discord.tokenFile}"
            ++ lib.optional (cfg.modelApiKeyFile != null)
            "model-api-key:${cfg.modelApiKeyFile}";

          # ── Hardening ──
          DynamicUser = false; # We use a dedicated user below
          User = "openclaw";
          Group = "openclaw";
          NoNewPrivileges = true;
          PrivateTmp = true;
          PrivateDevices = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          ProtectClock = true;
          ProtectHostname = true;
          RestrictAddressFamilies = [
            "AF_INET" # IPv4
            "AF_INET6" # IPv6
            "AF_UNIX" # Unix sockets
            "AF_NETLINK" # Required for os.networkInterfaces() to query network interfaces
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          LockPersonality = true;
          MemoryDenyWriteExecute = false; # Node.js needs JIT
          ReadWritePaths = [cfg.dataDir];
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
            "~@resources"
          ];
          CapabilityBoundingSet = "";
          AmbientCapabilities = "";
          UMask = "0077";
        };

        environment = lib.mkMerge [
          {
            OPENCLAW_HOME = cfg.dataDir;
            OPENCLAW_CONFIG_PATH = "${gatewayConfigFile}";
            NODE_ENV = "production";
          }
          (lib.mkIf (cfg.modelApiKeyFile != null) {
            OPENCLAW_MODEL_PROVIDER = cfg.modelProvider;
          })
          (lib.mkIf (cfg.telegram.enable && cfg.telegram.tokenFile != null) {
            OPENCLAW_TELEGRAM_ENABLED = "true";
          })
          (lib.mkIf (cfg.discord.enable && cfg.discord.tokenFile != null) {
            OPENCLAW_DISCORD_ENABLED = "true";
          })
        ];
      };

      # ── Dedicated user ──
      users.users.openclaw = {
        isSystemUser = true;
        group = "openclaw";
        home = cfg.dataDir;
        description = "OpenClaw service user";
      };
      users.groups.openclaw = {};

      # Nginx reverse proxy with optional basic auth
      services.nginx.virtualHosts."${cfg.domain}.${domain}" = lib.mkIf cfg.enable {
        forceSSL = true;
        enableACME = true;

        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.gatewayPort}";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
    };
  };
}
