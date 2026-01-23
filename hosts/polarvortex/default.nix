{
  config,
  inputs,
  lib,
  withSystem,
  mkNixos,
  ...
}: let
  system = "x86_64-linux";
  inherit (config.flake) nixosModules;

  defaultModules = [
    # make flake inputs accessible in NixOS
    {
      _module.args = {
        # inherit self;
        inherit inputs;
        inherit lib;
      };
    }
    # load common modules
    ({...}: {
      imports = [
        nixosModules.core
        nixosModules.doas
        nixosModules.nix
        nixosModules.openssh
        nixosModules.kernel_hardening
        nixosModules.security_monitoring
      ];
    })
  ];
in {
  flake.nixosConfigurations.polarvortex = withSystem system ({self', ...}:
    mkNixos system (defaultModules
      ++ [
        ./boot.nix
        ./disko.nix
        ./hardware.nix
        ./services
        ./system.nix
        ./users.nix
        nixosModules.ai
        nixosModules.server
        nixosModules.website
        ({pkgs, ...}: {
          environment.systemPackages = [
            inputs.neovim-flake.packages.${pkgs.stdenv.hostPlatform.system}.neovim
            pkgs.git
          ];
        })
        {
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
              openWebUiAppSecret = {
                mode = "444";
                group = "wheel";
                owner = "open-webui";
              };
              favaSSHPrivateKey = {
                mode = "0400";
                owner = "fava";
              };
              favaSSHKnownHosts = {
                mode = "0400";
                owner = "fava";
              };
              favaHtPasswd = {
                mode = "0400";
                owner = "nginx";
              };
              githubAuth = {
                mode = "0400";
                owner = "root";
              };
            };
          };
        }
        {
          # Disable documentation building to avoid missing path errors during remote builds
          documentation.nixos.enable = lib.mkForce false;
          documentation.nixos.options.warningsAreErrors = false;

          services.security-monitoring = {
            enable = true;
            schedule = "daily"; # Run daily at midnight
          };

          services.fail2ban = {
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
              "4.0.0.0/8"           # Covers 4.210.186.201
              "13.64.0.0/11"
              "20.0.0.0/8"          # Covers 20.123.146.92, 20.123.146.94
              "40.64.0.0/10"
              "52.224.0.0/11"
              "140.82.112.0/20"
              "143.55.64.0/20"
              "172.128.0.0/9"       # Covers 172.190.42.55, 172.208.48.177
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

          # Custom Forgejo fail2ban filter
          environment.etc."fail2ban/filter.d/forgejo-auth.conf".text = ''
            [Definition]
            failregex = ^.*Failed authentication attempt.*from <HOST>.*$
                        ^.*invalid credentials.*remote_addr=<HOST>.*$
            ignoreregex =
          '';
          services.fava = {
            enable = true;
            fava.basicAuth.enable = true;
          };
        }
      ]));
}
