{ inputs, system, pkgs, customLib, homeModules, name, ... }:

inputs.nixpkgs.lib.nixosSystem {
  inherit system;

  specialArgs = {
    inherit homeModules;
  };

  modules = [
    "../../hosts/${name}/configuration.nix"
    "../../hosts/${name}/hardware-configuration.nix"

    inputs.home-manager.nixosModules.home-manager

    {
      lib.custom = customLib;

      nixpkgs = {
        inherit pkgs;
      };

      nix.registry = {
        nixpkgs.flake = inputs.nixpkgs;
        nix-config.flake = inputs.self;
      };

      system.configurationRevision = inputs.self.rev or "dirty";
    }
  ]
  ++ customLib.getRecursiveNixFileList (../../modules/nixos);
}
