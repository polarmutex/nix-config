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
  flake.nixosConfigurations.polarvortex = withSystem system (_:
    mkNixos system (defaultModules
      ++ [
        ./boot.nix
        ./disko.nix
        ./hardware.nix
        ./services
        ./system.nix
        ./users.nix
        nixosModules.server
      ]));
}
