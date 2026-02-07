{
  lib,
  inputs,
  self,
  withSystem,
  ...
}: let
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
      {
        programs.noshell.enable = true;
      }
    ];
  };

  flake.nixosModules.host-polarvortex = {pkgs, ...}: {
    imports = [
      self.nixosModules.core
      self.nixosModules.doas
      self.nixosModules.nix
      self.nixosModules.openssh
      self.nixosModules.kernel-hardening
      self.nixosModules.security-monitoring
      self.nixosModules.ai
      self.nixosModules.server
      self.nixosModules.website
      self.nixosModules.fava-service
      self.nixosModules.blog-service
      self.nixosModules.forgejo-service
      self.nixosModules.litellm-service
      self.nixosModules.openwebui-service
      self.nixosModules.umami-service
    ];

    networking.hostName = "polarvortex";

    environment.systemPackages = with pkgs; [
      neovim
      git
    ];

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
      };
    };

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

    # Custom Forgejo fail2ban filter
    environment.etc."fail2ban/filter.d/forgejo-auth.conf".text = ''
      [Definition]
      failregex = ^.*Failed authentication attempt.*from <HOST>.*$
                  ^.*invalid credentials.*remote_addr=<HOST>.*$
      ignoreregex =
    '';
    services.fava = {
      enable = false;
      fava.basicAuth.enable = true;
    };
    users.users.polar = {
      uid = 1000;
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      initialHashedPassword = "$6$p/7P2dlx4xBEV72W$Ooep2JnmTJhTnexObNtAt3CNqRIhqgA2cD4bZtWMXOYAP.yBig8XToII0Fxy2Kc/Q12gep7Uqfsq6wIxRv7f21";
    };

    users.users.root = {
      initialHashedPassword = "$6$XvQOK8GW5DiRzqhR$g2LCu4rz2OfHRmYUbzaxTn/hz0h8IEHREG3/oW6U/8N3miFxUoYhIiLNjoS0cZXQHqgcaVAv5y1t4.eKxZi/..";
      shell = pkgs.bashInteractive;
    };
  };
}
