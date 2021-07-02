{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.05";
    home-manager.url = "github:nix-community/home-manager/release-21.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager,  ... }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };

    lib = nixpkgs.lib;

  in {

    homeManagerConfigurations = {
      brian = home-manager.lib.homeManagerConfiguration {
        inherit system pkgs;
        username = "brian";
         homeDirectory = "/home/brian";
         configuration = {
           imports = [
             ./home-manager/brian/home.nix
           ];
         };
      };
    };

    nixosConfigurations = {
      nixosvm = lib.nixosSystem {
        inherit system;

        modules = [
          ./systems/nixosvm/configuration.nix
        ];
      };
    };
  };
}
