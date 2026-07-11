{
  lib,
  config,
  inputs,
  self,
  withSystem,
  ...
}: let
  flakeCfg = config;
  sources = import ../../../npins;
  evalConfig = import "${sources.nixpkgs}/nixos/lib/eval-config.nix";
  system = "x86_64-linux";
in {
  flake.nixosConfigurations.polarvortex = evalConfig {
    inherit system;
    pkgs = withSystem system ({pkgs, ...}: pkgs);
    modules = [
      {
        _module.args = {
          inherit inputs;
          self' = withSystem system ({self', ...}: self');
        };
      }
      self.nixosModules.host-polarvortex
      inputs.sops-nix.nixosModules.sops
      inputs.noshell.nixosModules.default
      inputs.nix-maid.nixosModules.default
      {
        programs.noshell.enable = true;
      }
    ];
  };

  flake.nixosModules.host-polarvortex = {
    pkgs,
    config,
    inputs,
    ...
  }: {
    imports = [
      self.nixosModules.core
      self.nixosModules.doas
      self.nixosModules.nix
      self.nixosModules.openssh
      self.nixosModules.kernel-hardening
      self.nixosModules.server
      # services
      self.nixosModules.website
      self.nixosModules.blog-service
      self.nixosModules.fava-service
      self.nixosModules.forgejo-service
      self.nixosModules.hermes-agent-service
      self.nixosModules.litellm-service
      self.nixosModules.miniflux-service
      # self.nixosModules.paperclip-service
      self.nixosModules.security-monitoring
      self.nixosModules.tailscale
      self.nixosModules.umami-service
      # apps
      self.nixosModules.claude
      self.nixosModules.claude-desktop
      flakeCfg.flake.wrappers.claude-code-morgen.install
    ];

    # Disable documentation building to avoid missing path errors during remote builds
    documentation.nixos.enable = lib.mkForce false;
    documentation.nixos.options.warningsAreErrors = false;

    environment = {
      variables.HERMES_HOME = "/var/lib/hermes/.hermes";
      variables.HERMES_MANAGED = "NixOS";

      # Custom Forgejo fail2ban filter
      etc."fail2ban/filter.d/forgejo-auth.conf".text = ''
        [Definition]
        failregex = ^.*Failed authentication attempt.*from <HOST>.*$
                    ^.*invalid credentials.*remote_addr=<HOST>.*$
        ignoreregex =
      '';

      extraInit = ''
        if [ -r ${config.sops.secrets.morgenApiToken.path} ]; then
          export MORGEN_API_KEY=$(cat ${config.sops.secrets.morgenApiToken.path})
        fi
      '';

      systemPackages = with pkgs; [
        neovim
        git-polar
        unstable.tmux
        tsm
        nodejs
        bun
        unstable.zellij
        claude-code # should be unstable
        unstable.defuddle
        pkgs.obsidian-polar
        x11vnc
        inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.herdr
        inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex
      ];
    };

    networking = {
      hostName = "polarvortex";
      firewall.interfaces."tailscale0".allowedTCPPorts = [9119 9871];
    };

    services = {
      claude-desktop.claudeCodePackage = config.wrappers.claude-code-polar.wrapper;

      fail2ban = {
        enable = true;
        maxretry = 3;
        bantime = "24h";
        # Whitelist GitHub Actions IPs (from https://api.github.com/meta)
        # Major IP ranges covering the 5 banned IPs found:
        # 172.190.42.55, 20.123.146.92, 20.123.146.94, 4.210.186.201, 172.208.48.177
        ignoreIP = [
          "127.0.0.1/8"
          "::1"
          # Core GitHub ranges
          "4.0.0.0/8" # Covers 4.210.186.201
          "13.64.0.0/11"
          "20.0.0.0/8" # Covers 20.123.146.92, 20.123.146.94
          "40.64.0.0/10"
          "52.224.0.0/11"
          "140.82.112.0/20"
          "143.55.64.0/20"
          "172.128.0.0/9" # Covers 172.190.42.55, 172.208.48.177
          "185.199.108.0/22"
          "192.30.252.0/22"
        ];
        bantime-increment = {
          enable = true;
          multipliers = "1 2 4 8 16 32 64";
          maxtime = "168h"; # 1 week max
          overalljails = true;
        };
        jails = {
          sshd = {
            settings = {
              enabled = true;
              port = "22";
              filter = "sshd";
              logpath = "/var/log/auth.log";
              maxretry = 3;
              findtime = 600;
              bantime = 86400;
            };
          };
          nginx-http-auth = {
            settings = {
              enabled = true;
              port = "http,https";
              filter = "nginx-http-auth";
              logpath = "/var/log/nginx/error.log";
              maxretry = 5;
            };
          };
          nginx-limit-req = {
            settings = {
              enabled = true;
              port = "http,https";
              filter = "nginx-limit-req";
              logpath = "/var/log/nginx/error.log";
              maxretry = 10;
            };
          };

          # Forgejo authentication protection
          forgejo-auth = {
            settings = {
              enabled = true;
              port = "http,https";
              filter = "forgejo-auth";
              logpath = "/var/lib/forgejo/log/forgejo.log";
              maxretry = 5;
              findtime = 600;
              bantime = 3600;
            };
          };
        };
      };

      fava = {
        enable = false;
        fava.basicAuth.enable = true;
      };

      hermes-agent-service = {
        enable = true;
        hostUsers = ["polar"];
        secretsFile = config.sops.secrets.hermesEnv.path;
        extraDependencyGroups = ["messaging"];
      };

      hermes-agent = {
        workingDirectory = "/home/polar/repos/personal/ideaverse/main";
        settings = {
          terminal.cwd = "/home/polar/repos/personal/ideaverse/main";
          dashboard.basic_auth = {
            username = "polar";
            password_hash = "scrypt$16384$8$1$/ly3m0CcEaHGK9u865BmOQ==$FcV6dTo/WIBYoytTYAUzEfho3/0nuAu9DLSwtQfOTP4=";
          };
        };
      };

      # ollama = {
      #   enable = true;
      #   package = pkgs.unstable.ollama;
      #   # Optional: preload models, see https://ollama.com/library
      #   loadModels = [
      #     "gemma3:4b"
      #     "gemma3:12b"
      #     "qwen:4b"
      #     "qwen3:8b"
      #     "qwen3:14b"
      #     "qwen2.5-coder:7b"
      #     "qwen2.5-coder:14b"
      #     "mxbai-embed-large"
      #   ];
      # };

      # paperclip = {
      #   enable = false;
      # };

      security-monitoring = {
        enable = true;
        schedule = "daily"; # Run daily at midnight
      };

      tailscale.authKeyFile = config.sops.secrets.tailscaleAuthKey.path;
    };

    wrappers = {
      claude-code-morgen = {
        enable = true;
      };

      claude-code-polar = {
        enable = true;
      };
    };

    sops = {
      # This will add secrets.yml to the nix store
      # You can avoid this by adding a string to the full path instead, i.e.
      # sops.defaultSopsFile = "/root/.sops/secrets/example.yaml";
      defaultSopsFile = ./secrets.yaml;
      age = {
        # This will automatically import SSH keys as age keys
        sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
        # This is using an age key that is expected to already be in the filesystem
        keyFile = "/var/lib/sops-nix/key.txt";
        # This will generate a new key if the key specified above does not exist
        generateKey = true;
      };
      # This is the actual specification of the secrets.
      # sops.secrets.example-key = {};
      # sops.secrets."myservice/my_subdir/my_secret" = {};
      secrets = {
        liteLLMAppSecret = {
          mode = "444";
          group = "wheel";
          owner = "litellm";
        };
        umamiAppSecret = {
          mode = "444";
          group = "wheel";
          owner = "root";
        };
        # openWebUiAppSecret = {
        #   mode = "444";
        #   group = "wheel";
        #   owner = "open-webui";
        # };
        # favaSSHPrivateKey = {
        #   mode = "0400";
        #   owner = "fava";
        # };
        # favaSSHKnownHosts = {
        #   mode = "0400";
        #   owner = "fava";
        # };
        favaHtPasswd = {
          mode = "0400";
          owner = "nginx";
        };
        githubAuth = {
          mode = "0400";
          owner = "root";
        };
        hermesEnv = {
          mode = "0400";
          owner = "hermes";
        };

        telegramBotToken = {
          mode = "0400";
          owner = "polar";
        };
        morgenApiToken = {
          mode = "0400";
          owner = "polar";
        };
        minifluxCredentials = {
          mode = "0400";
          owner = "root";
        };
        tailscaleAuthKey = {
          mode = "0400";
          owner = "root";
        };
        healthImportToken = {
          mode = "0400";
          owner = "polar";
        };
      };
    };

    system.activationScripts.hermesAcl = {
      deps = ["users"];
      text = ''
        ${pkgs.acl}/bin/setfacl -Rm u:hermes:rwx /home/polar/repos/personal/ideaverse/main
        ${pkgs.acl}/bin/setfacl -m d:u:hermes:rwx /home/polar/repos/personal/ideaverse/main
      '';
    };

    systemd.services.hermes-dashboard = {
      description = "Hermes web dashboard";
      wantedBy = ["multi-user.target"];
      after = ["hermes-agent.service"];
      environment.HERMES_HOME = "/var/lib/hermes/.hermes";
      serviceConfig = {
        Type = "simple";
        User = "hermes";
        Group = "hermes";
        ExecStart = "${inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/hermes dashboard --host 0.0.0.0 --no-open --skip-build";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };

    # Linger ensures systemd starts polar's user session at boot (creates /run/user/1000).
    systemd.tmpfiles.rules = [
      "f /var/lib/systemd/linger/polar 0644 root root -"
      # setgid (2770) so files created by the hermes service inherit the hermes group,
      # making them accessible to polar who is in that group
      "d /var/lib/hermes/.hermes 2770 hermes hermes -"
    ];

    users.users.polar = {
      shell = pkgs.fish-polar;
      uid = 1000;
      isNormalUser = true;
      homeMode = "711";
      extraGroups = [
        "wheel"
        "networkmanager"
        "hermes"
      ];
      initialHashedPassword = "$6$p/7P2dlx4xBEV72W$Ooep2JnmTJhTnexObNtAt3CNqRIhqgA2cD4bZtWMXOYAP.yBig8XToII0Fxy2Kc/Q12gep7Uqfsq6wIxRv7f21";
      maid = {
        imports = [
          flakeCfg.flake.maidModules.ideaverse-sync
          flakeCfg.flake.maidModules.obsidian-xvfb
          flakeCfg.flake.maidModules.claude-desktop-xvfb
          flakeCfg.flake.maidModules.claude-dailylog
          flakeCfg.flake.maidModules.health-import-listener
        ];

        claude-dailylog = {
          claudePackage = config.wrappers.claude-code-morgen.wrapper;
          claudeBinName = "claude-morgen";
          herdrPackage = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.herdr;
          morgenApiTokenPath = config.sops.secrets.morgenApiToken.path;
          claudeArgs = ["--dangerously-skip-permissions"];
        };

        claude-desktop-xvfb = {
          claudeDesktopPackage = inputs.claude-desktop.packages.${pkgs.stdenv.hostPlatform.system}.default;
        };

        health-import-listener = {
          importDir = "/home/polar/repos/personal/ideaverse/+/Health Auto Export";
          tokenFile = config.sops.secrets.healthImportToken.path;
        };

        ideaverse-sync = {
          repoPath = "/home/polar/repos/personal/ideaverse";
          platform = "polarvortex";
        };

        obsidian-xvfb = {
          vaultPath = "/home/polar/repos/personal/ideaverse";
          display = ":99";
        };

        systemd = {
          services = {
            x11vnc = {
              description = "x11vnc VNC server for Obsidian Xvfb display";
              after = ["xvfb.service"];
              requires = ["xvfb.service"];
              serviceConfig = {
                Type = "simple";
                ExecStart = "${pkgs.x11vnc}/bin/x11vnc -display :99 -forever -localhost -nopw";
                Restart = "on-failure";
                RestartSec = 5;
              };
            };

            zellij-claude-remote = let
              zellijNormalLayout = pkgs.writeText "zellij-claude-layout.kdl" ''
                layout {
                  pane command="${pkgs.claude-code}/bin/claude" {
                    args "--permission-mode" "auto"
                  }
                }
              '';

              zellijRemoteStartScript = pkgs.writeShellScript "zellij-remote-claude-start" ''
                ZELLIJ="${pkgs.unstable.zellij}/bin/zellij"
                $ZELLIJ delete-session claude-remote-session --force 2>/dev/null || true
                $ZELLIJ --layout ${zellijNormalLayout} attach --create-background claude-remote-session
              '';

              zellijRemoteStopScript = pkgs.writeShellScript "zellij-claude-stop" ''
                ${pkgs.unstable.zellij}/bin/zellij delete-session claude-remote-session --force 2>/dev/null || true
              '';
            in {
              description = "Persistent zellij session 'claude-remote-session'";
              wantedBy = ["default.target"];
              environment = {
                TERM = "xterm-256color";
                SHELL = "${pkgs.bashInteractive}/bin/bash";
              };
              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = "yes";
                WorkingDirectory = "/home/polar/repos/personal/ideaverse";
                ExecStart = zellijRemoteStartScript;
                ExecStop = zellijRemoteStopScript;
              };
            };

            zellij-claude-ssh = let
              zellijNormalLayout = pkgs.writeText "zellij-claude-layout.kdl" ''
                layout {
                  pane command="${pkgs.claude-code}/bin/claude" {}
                }
              '';
              zellijStartScript = pkgs.writeShellScript "zellij-claude-start" ''
                ZELLIJ="${pkgs.unstable.zellij}/bin/zellij"
                $ZELLIJ delete-session claude-session --force 2>/dev/null || true
                $ZELLIJ --layout ${zellijNormalLayout} attach --create-background claude-session
              '';
              zellijStopScript = pkgs.writeShellScript "zellij-claude-stop" ''
                ${pkgs.unstable.zellij}/bin/zellij delete-session claude-session --force 2>/dev/null || true
              '';
            in {
              description = "Persistent zellij session 'claude-session'";
              wantedBy = ["default.target"];
              environment = {
                TERM = "xterm-256color";
                SHELL = "${pkgs.bashInteractive}/bin/bash";
              };
              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = "yes";
                WorkingDirectory = "/home/polar/repos/personal/ideaverse";
                ExecStart = zellijStartScript;
                ExecStop = zellijStopScript;
              };
            };

            # zellij-claude-restart = {
            #   description = "Nightly restart of zellij claude session";
            #   serviceConfig = {
            #     Type = "oneshot";
            #     ExecStart = "${pkgs.systemd}/bin/systemctl --user restart zellij-claude-remote.service";
            #   };
            # };
          };
        };
      };
    };

    users.users.root = {
      initialHashedPassword = "$6$XvQOK8GW5DiRzqhR$g2LCu4rz2OfHRmYUbzaxTn/hz0h8IEHREG3/oW6U/8N3miFxUoYhIiLNjoS0cZXQHqgcaVAv5y1t4.eKxZi/..";
      shell = pkgs.bashInteractive;
    };
  };
}
