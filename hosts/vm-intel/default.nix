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
      ];
    })
  ];
in {
  flake.nixosConfigurations.vm-intel = withSystem system (_:
    mkNixos system (defaultModules
      ++ [
        ./configuration.nix
        # nixosModules.core
        nixosModules.doas
        nixosModules.docker
        # nixosModules.fonts
        nixosModules.gnome
        nixosModules.openssh
        nixosModules.user-polar
        # nixosModules.bluetooth
        # nixosModules.desktop
        # nixosModules.display-manager
        # nixosModules.graphical
        # nixosModules.nix
        # nixosModules.nvidia
        # nixosModules.nix
        # nixosModules.trusted
        # nixosModules.wm-helper
        {
          virtualisation.vmware.guest.enable = true;

          services.openssh.settings.PermitRootLogin = "yes";

          # Interface is this on Intel Fusion
          networking.interfaces.ens33.useDHCP = true;

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
      ]));
}
