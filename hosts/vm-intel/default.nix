{
  config,
  inputs,
  lib,
  withSystem,
  mkNixos,
  ...
}: let
  system = "x86_64-linux";
  inherit (config.flake) nixosModules homeModules;
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
      ];
    })
  ];
in {
  flake.nixosConfigurations.vm-intel = withSystem system ({self', ...}:
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
        nixosModules.core
        nixosModules.doas
        nixosModules.docker
        # nixosModules.fonts
        nixosModules.cosmic
        # nixosModules.gnome
        nixosModules.openssh
        nixosModules.user-polar
        # nixosModules.bluetooth
        # nixosModules.desktop
        # nixosModules.display-manager
        # nixosModules.graphical
        nixosModules.nix
        # nixosModules.nvidia
        # nixosModules.nix
        # nixosModules.trusted
        # nixosModules.wm-helper
        {
          virtualisation.vmware.guest.enable = true;
          virtualisation.vmware.guest.headless = false;
          services.xserver.videoDrivers = ["vmware"];

          services.openssh.settings.PermitRootLogin = "yes";

          # Interface is this on Intel Fusion
          networking.interfaces.ens33.useDHCP = true;

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
          ];
          # # Shared folder to host works on Intel
          # fileSystems."/host" = {
          #   fsType = "fuse./run/current-system/sw/bin/vmhgfs-fuse";
          #   device = ".host:/";
          #   options = [
          #     "umask=22"
          #     "uid=1000"
          #     "gid=1000"
          #     "allow_other"
          #     "auto_unmount"
          #     "defaults"
          #   ];
          # };
        }
        #-- home-manager
        {
          home-manager.sharedModules = [
            ./home.nix
          ];
        }
      ]
    ));
}
