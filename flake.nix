{
  description = "PolarMutex Nix Configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly.inputs.flake-utils.follows = "flake-utils";

    krops.url = "git+https://cgit.krebsco.de/krops";
    krops.flake = false;
  };

  outputs = { self, ... }@inputs:
    with inputs;
    let

      inherit (nixpkgs) lib;
      inherit (lib) attrValues;

      util = import ./lib { inherit system pkgs home-manager lib; overlays = (pkgs.overlays); };

      inherit (util) host;
      inherit (util) user;

      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
        overlays = [
          # NUR
          nur.overlay
          # neovim
          neovim-nightly.overlay

          (
            final: prev: {
              my = import ./pkgs { inherit pkgs; };
            }
          )
        ];
      };

      # Function to create default (common) system config options
      defFlakeSystem = baseCfg:
        nixpkgs.lib.nixosSystem {

          system = "x86_64-linux";
          modules = [
            # Make inputs and overlay accessible as module parameters
            { _module.args.inputs = inputs; }
            { _module.args.self-overlay = self.overlay; }
            (
              { ... }: {
                imports = builtins.attrValues self.nixosModules ++ [
                  {
                    # Set the $NIX_PATH entry for nixpkgs. This is necessary in
                    # this setup with flakes, otherwise commands like `nix-shell
                    # -p pkgs.htop` will keep using an old version of nixpkgs.
                    # With this entry in $NIX_PATH it is possible (and
                    # recommended) to remove the `nixos` channel for both users
                    # and root e.g. `nix-channel --remove nixos`. `nix-channel
                    # --list` should be empty for all users afterwards
                    nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
                    nixpkgs.overlays = [
                      self.overlay
                      nur.overlay
                      neovim-nightly.overlay
                    ];

                    # DON'T set useGlobalPackages! It's not necessary in newer
                    # home-manager versions and does not work with configs using
                    # nixpkgs.config`
                    home-manager.useUserPackages = true;
                  }
                  baseCfg
                  home-manager.nixosModules.home-manager
                ];

                # Let 'nixos-version --json' know the Git revision of this flake.
                system.configurationRevision =
                  nixpkgs.lib.mkIf (self ? rev) self.rev;
                nix.registry.nixpkgs.flake = nixpkgs;
              }
            )
          ];
        };


    in
    {

      # Expose overlay to flake outputs, to allow using it from other flakes.
      # Flake inputs are passed to the overlay so that the packages defined in
      # it can use the sources pinned in flake.lock
      overlay = final: prev: (import ./overlays inputs) final prev;

      # Output all modules in ./modules to flake. Modules should be in
      # individual subdirectories and contain a default.nix file
      nixosModules = builtins.listToAttrs (
        map
          (
            x: {
              name = x;
              value = import (./modules + "/${x}");
            }
          )
          (builtins.attrNames (builtins.readDir ./modules))
      );

      # Each subdirectory in ./machins is a host. Add them all to
      # nixosConfiguratons. Host configurations need a file called
      # configuration.nix that will be read first
      nixosConfigurations = builtins.listToAttrs (
        map
          (
            x: {
              name = x;
              value = defFlakeSystem {
                imports = [
                  (import (./machines + "/${x}/configuration.nix") { inherit self pkgs; })
                ];
              };
            }
          )
          (builtins.attrNames (builtins.readDir ./machines))
      );

      homeManagerConfigurations = {
        work = home-manager.lib.homeManagerConfiguration {
          configuration = ./home-manager/home-work.nix;
          system = "x86_64-linux";
          homeDirectory = "/home/brian";
          username = "brian";
          pkgs = pkgs;
        };
        polar = home-manager.lib.homeManagerConfiguration {
          configuration = ./home-manager/home.nix;
          system = "x86_64-linux";
          homeDirectory = "/home/polar";
          username = "polar";
          pkgs = pkgs;
        };
      };

    };
}
