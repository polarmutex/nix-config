{ self
, awesome-flake
, home-manager
, neovim-flake
, nixpkgs
, polar-nur
, sops-nix
, ...
}:
let
  hostPkgs = localSystem: {
    nixpkgs = {
      localSystem.system = localSystem;
      pkgs = self.pkgs.${localSystem};
    };
  };
  genConfiguration = hostname: localSystem:
    nixpkgs.lib.nixosSystem {
      system = localSystem;
      modules = [
        {
          _module.args.self = self;
          _module.args.inputs = self.inputs;
        }
        (../nixos + "/${hostname}/configuration.nix")
        (hostPkgs localSystem)
        sops-nix.nixosModules.sops
      ];
      #specialArgs = {
      #  impermanence = impermanence.nixosModules;
      #  nixos-hardware = nixos-hardware.nixosModules;
      #};
    };
in
{
  polarbear = genConfiguration "polarbear" "x86_64-linux";

  polarvortex = genConfiguration "polarvortex" "x86_64-linux";

  blackbear = genConfiguration "blackbear" "x86_64-linux";
}
