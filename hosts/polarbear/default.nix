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
  flake.nixosConfigurations.polarbear = withSystem system (_:
    mkNixos system (defaultModules
      ++ [
        ./configuration.nix
        nixosModules.desktop
        nixosModules.bluetooth
        nixosModules.nvidia
        nixosModules.display-manager
        nixosModules.fonts
        nixosModules.graphical
        nixosModules.nix
        nixosModules.podman
        nixosModules.trusted
        nixosModules.wm-helper
        nixosModules.virt-manager
        nixosModules.yubikey
      ]));
}
