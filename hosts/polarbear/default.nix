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
  flake.nixosConfigurations.polarbear = withSystem system ({self', ...}:
    mkNixos system (
      [
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
              git_config_work = {
                mode = "444";
                group = "wheel";
              };
            };
          };
          # nix.settings.ssl-cert-file = "/root/work.crt";
          # security.pki.certificates = let
          #   secrets = builtins.trace "secrets:" (builtins.extraBuiltins.readSops ./eval-secrets.nix);
          # in [
          #   secrets.work-cert-1
          #   secrets.work-cert-2
          # ];
        }
      ]
      ++ defaultModules
      ++ [
        ./configuration.nix
        inputs.hardware.nixosModules.common-hidpi
        inputs.hardware.nixosModules.common-cpu-intel-cpu-only
        inputs.hardware.nixosModules.common-gpu-nvidia-nonprime
        nixosModules.nvidia
        {
          # The open source driver does not support Maxwell GPUs.
          hardware.nvidia = {
            open = false;
            # prime = {
            #   # Bus ID of the Intel GPU.
            #   intelBusId = lib.mkDefault "PCI:0:2:0";
            #
            #   # Bus ID of the NVIDIA GPU.
            #   nvidiaBusId = lib.mkDefault "PCI:1:0:0";
            # };
          };
        }
        nixosModules.desktop
        nixosModules.bluetooth
        nixosModules.fonts
        nixosModules.gnome
        nixosModules.graphical
        nixosModules.nix
        nixosModules.docker
        nixosModules.trusted
        nixosModules.vmware
        nixosModules.yubikey
        nixosModules.user-polar
        {
          services.displayManager.autoLogin = {
            enable = true;
            user = "polar";
          };
          # https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
          systemd.services."getty@tty1".enable = false;
          systemd.services."autovt@tty1".enable = false;

          environment.systemPackages = [
            inputs.neovim-flake.packages.${system}.neovim
            self'.packages.fish
            self'.packages.ghostty
            self'.packages.git
            self'.packages.google-chrome
            self'.packages.brave
          ];

          home-manager.sharedModules = [
            ./home.nix
          ];
        }
      ]
    ));
}
