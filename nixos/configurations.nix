{
  lib,
  inputs,
  self,
  withSystem,
  ...
}: let
  inherit (self.lib) importModules collectLeaves genModules genHosts;

  mkNixOS = hostname: args @ {system ? "x86_64-linux", ...}:
    withSystem system ({
      pkgs,
      lib,
      system,
      ...
    }:
      lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit self inputs lib pkgs;
        };
        modules = with inputs;
          [
            #(import configuration)
            home-manager.nixosModules.home-manager
            inputs.lollypops.nixosModules.lollypops
            {
              #networking.hostName = hostname;
              users.mutableUsers = false;
              # I don't like having to manually set this, but the _module.args
              # pkgs is not being passed properly for some reason; I'll look
              # into this later.
              nixpkgs = {
                inherit pkgs;
                config.allowUnfree = true;
              };
            }
            (args: {
              imports =
                genModules args "profiles" ./profiles # NixOS profiles
                ++ (genModules args "users" ../users) # Users
                ++ (collectLeaves ./modules); # NixOS modules
            })
          ]
          ++ args.modules;
      });
  #generatedHosts = genHosts mkNixOS ./hosts;
in {
  flake = {
    nixosConfigurations = {
      blackbear = mkNixOS "blackbear" {
        modules = [
          ./hosts/blackbear
        ];
      };
      polarbear = mkNixOS "polarbear" {
        modules = [
          ./hosts/polarbear
        ];
      };
      polarvortex = mkNixOS "polarvortex" {
        modules = [
          ./hosts/polarvortex
        ];
      };
    };

    #nixosModules = importModules ./modules;
  };
}
