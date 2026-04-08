{
  flake.nixosModules.paperclip-service = {
    config,
    lib,
    pkgs,
    inputs,
    ...
  }: let
    inherit (config.networking) domain;
    cfg = config.services.paperclip;

    serviceUser = "paperclip";
    serviceGroup = "paperclip";
    stateDir = "/var/lib/paperclip"; # StateDirectory path
    claudeDir = "${stateDir}/.claude";
    claudeConfig = "${stateDir}/.claude.json";
    agentWorkspaces = "${stateDir}/companys";
    paperclipHost = "127.0.0.1";
    paperclipPort = "3101";
    restartDelay = "10s";
    runtimeEnvDir = "/run/paperclip";
  in {
    options.services.paperclip = {
      enable = lib.mkEnableOption "Paperclip hardened agent infrastructure";
    };

    config = lib.mkIf cfg.enable {
      # ── Packages ──
      environment.systemPackages = [pkgs.paperclip];

      # ── Main gateway service ──
      systemd.services.paperclipai = {
        description = "Paperclip AI Agent Control Plane";
        after = ["network.target" "postgresql.service"];
        requires = ["postgresql.service"];
        wantedBy = ["multi-user.target"];

        # Expose all system packages to child processes (agents, git, node, claude, etc.)
        # Using systemPackages means any tool added to the system is automatically available
        # to agents without needing to update this list.
        path = config.environment.systemPackages;

        environment = {
          HOST = paperclipHost; # nginx handles external access
          PORT = paperclipPort;
          SERVE_UI = "true";
          PAPERCLIP_HOME = "${stateDir}/.paperclip";
          # PAPERCLIP_INSTANCE_ID = "default";
          # PAPERCLIP_DEPLOYMENT_MODE = "authenticated";
          # PAPERCLIP_MIGRATION_AUTO_APPLY = "true"; # apply pending migrations on startup
          # PAPERCLIP_MIGRATION_PROMPT = "never"; # safety net: don't hang on interactive prompt if AUTO_APPLY is unset
          # DATABASE_URL = "postgres://paperclip:paperclip@localhost:5432/paperclip";
          # PAPERCLIP_AUTH_DISABLE_SIGN_UP = "true";
        };

        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.paperclip}/bin/paperclip run";

          Restart = "on-failure";
          RestartSec = 5;
          WorkingDirectory = stateDir;
          StateDirectory = "paperclip";

          # ── Hardening ──
          DynamicUser = false; # We use a dedicated user below
          User = "paperclip";
          Group = "paperclip";
          SupplementaryGroups = ["postgres"]; # Access PostgreSQL socket
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
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
            "~@resources"
          ];
          CapabilityBoundingSet = "";
          AmbientCapabilities = "";
          UMask = "0077";
          # StateDirectory makes /var/lib/paperclip writable by default
          # No need for BindPaths or ReadWritePaths
        };
      };

      services.postgresql = {
        enable = true;
        package = pkgs.postgresql_16; # PostgreSQL 16+ required for NULLS NOT DISTINCT

        ensureDatabases = ["paperclip"];
        ensureUsers = [
          {
            name = "paperclip";
            ensureDBOwnership = true;
          }
        ];

        # Set initial password for paperclip user
        initialScript = pkgs.writeText "paperclip-init.sql" ''
          ALTER USER paperclip WITH PASSWORD 'paperclip';
        '';

        # Allow both Unix socket (peer) and TCP (md5) authentication
        authentication = lib.mkBefore ''
          local paperclip paperclip peer
          host  paperclip paperclip 127.0.0.1/32 md5
          host  paperclip paperclip ::1/128 md5
        '';
      };

      # ── Dedicated user ──
      users.users.paperclip = {
        isSystemUser = true;
        group = "paperclip";
        extraGroups = ["postgres"]; # Access PostgreSQL Unix socket
        home = stateDir;
        description = "paperclip service user";
      };
      users.groups.paperclip = {};

      # ── Subdirectory creation ──
      # StateDirectory already creates /var/lib/paperclip
      systemd.tmpfiles.rules = [
        "d ${claudeDir} 0750 paperclip paperclip -"
        "d ${agentWorkspaces} 0750 paperclip paperclip -"
      ];

      # Nginx reverse proxy with optional basic auth
      services.nginx.virtualHosts."paperclip.${domain}" = lib.mkIf cfg.enable {
        forceSSL = true;
        enableACME = true;

        # Security headers
        extraConfig = ''
          add_header X-Frame-Options "SAMEORIGIN" always;
          add_header X-Content-Type-Options "nosniff" always;
          add_header Referrer-Policy "strict-origin-when-cross-origin" always;
          add_header X-XSS-Protection "0" always;
          add_header Permissions-Policy "camera=(), microphone=(), geolocation=()" always;
          add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; connect-src 'self'; font-src 'self'; object-src 'none'; frame-ancestors 'self';" always;
        '';

        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString paperclipPort}";
          proxyWebsockets = true;
        };

        # # Rate-limit API endpoints more aggressively
        # locations."/api/" = {
        #   proxyPass = upstreamUrl;
        #   proxyWebsockets = true;
        #   extraConfig = ''
        #     limit_req zone=api burst=20 nodelay;
        #     limit_req_status 429;
        #   '';
        # };
      };
    };
  };
}
