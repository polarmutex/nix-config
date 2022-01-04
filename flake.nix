{
  description = "PolarMutex Nix Configuration";

  inputs = {
    nixpkgs-stable.url = "nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    deploy-rs.url = "github:serokell/deploy-rs";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs-unstable";
    hardware.url = "github:nixos/nixos-hardware";

    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly.inputs.nixpkgs.follows = "nixpkgs-unstable";
    neovim-nightly.inputs.flake-utils.follows = "flake-utils";

    polar-dwm = {
      url = "github:polarmutex/dwm";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    polar-st = {
      url = "github:polarmutex/st";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    polar-dmenu = {
      url = "github:polarmutex/dmenu";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    krops.url = "git+https://cgit.krebsco.de/krops";
    krops.flake = false;
  };

  outputs =
    { self
    , nixpkgs-stable
    , nixpkgs-unstable
    , home-manager
    , deploy-rs
    , neovim-nightly
    , polar-dwm
    , polar-st
    , polar-dmenu
    , nur
    , ...
    }@inputs:
    let

      inherit (import ./pkgs {
        inherit pkgs;
      }) myPkgs;

      # Default overlay, for use in dependent flakes
      #overlay = final: prev: { };
      # Same idea as overlay but a list or attrset of them.
      #overlays = { };
      inherit (import ./overlays {
        inherit system pkgs myPkgs;
        inherit deploy-rs;
        inherit neovim-nightly;
        inherit polar-dwm polar-st polar-dmenu;
        inherit nur;
      }) overlays;

      pkgs = import nixpkgs-unstable {
        inherit system overlays;
        config.allowUnfree = true;
      };
      pkgs-stable = import nixpkgs-stable {
        inherit system overlays;
        config.allowUnfree = true;
      };

      system = "x86_64-linux";

      mkSystem = { hostname, nixpkgs, users }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs system;
          };
          modules = [
            ./modules/nixos
            (./hosts + "/${hostname}")
            {
              networking.hostName = hostname;
              # Apply overlay and allow unfree packages
              nixpkgs = {
                overlays = overlays;
                config.allowUnfree = true;
              };
            }
            # System wide config for each user
          ] ++ nixpkgs.lib.forEach users
            (u: ./users + "/${u}" + /system-wide.nix);
        };

      # Make home configuration, given username, required features, and system type
      mkHome = { username, system, hostname, features ? [ ] }:
        home-manager.lib.homeManagerConfiguration {
          inherit username system;
          extraSpecialArgs = {
            inherit features hostname inputs system;
          };
          homeDirectory = "/home/${username}";
          configuration = ./users + "/${username}";
          extraModules = [
            ./modules/home-manager
            {
              nixpkgs = {
                overlays = self.overlays;
                config.allowUnfree = true;
              };
            }
          ];
        };
    in
    {
      # Executed by `nix flake check`
      #checks."<system>"."<name>" = derivation;

      # Used with `nixos-rebuild --flake .#<hostname>`
      nixosConfigurations = {
        #polarbear = mkSystem {
        #  hostname = "polarbear";
        #  nixpkgs = nixpkgs-stable;
        #  users = [ ];
        #};
        blackbear = mkSystem {
          hostname = "blackbear";
          nixpkgs = nixpkgs-stable;
          users = [ "polar" ];
        };
      };

      # Used by `nix develop`
      devShell.x86_64-linux = pkgs.mkShell
        {
          buildInputs = with pkgs; [
            nixFlakes
            nixfmt
            rnix-lsp
            deploy-rs
            deploy-rs.defaultPackage.x86_64-linux
          ];
        };

      # Used by `nix develop .#<name>`
      #devShells."<system>"."<name>" = derivation;

      # Hydra build jobs
      #hydraJobs."<attr>"."<system>" = derivation;

      # Used by `nix flake init -t <flake>`
      #defaultTemplate = {
      #  path = "<store-path>";
      #  description = "template description goes here?";
      #};

      # Used by `nix flake init -t <flake>#<name>`
      #templates."<name>" = { path = "<store-path>"; description = ""; };

      deploy.nodes = {
        blackbear = {
          sshOpts = [ "-p" "22" ];
          hostname = "blackbear";
          fastConnection = true;
          profiles = {
            system = {
              sshUser = "root";
              path =
                deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.blackbear;
              user = "root";
            };
          };
        };
      };
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

    };
}
