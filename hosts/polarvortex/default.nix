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
        nixosModules.server
        nixosModules.umami
        nixosModules.website
        {
          environment.systemPackages = [
            inputs.neovim-flake.packages.${system}.neovim
            self'.packages.git
          ];
        }
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
            };
          };
        }
        {
          services.fail2ban = {
            enable = true;
          };
        }
      ]));
}
