{
  description = "PolarMutex Nix Configuration";

  inputs = {
    nixpkgs-stable.url = "nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    flake-utils.url = "github:numtide/flake-utils";
    deploy-rs.url = "github:serokell/deploy-rs";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs-unstable";
    hardware.url = "github:nixos/nixos-hardware";

    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.flake-utils.follows = "flake-utils";
    };

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
    , neovim
    , polar-dwm
    , polar-st
    , polar-dmenu
    , nur
    , ...
    }@inputs:
    let

      lib = import ./lib;

      allPkgs-stable = lib.mkPkgs {
        nixpkgs = nixpkgs-stable;
        cfg = {
          allowUnfree = true;
        };
        overlays = [
          (lib.mkOverlays {
            allPkgs = allPkgs-stable;
            overlayFunc = s: p: (top: last: {
              polar = import ./pkgs { pkgs = p; };
            });
          })
        ];
      };

      allPkgs-unstable = lib.mkPkgs
        {
          nixpkgs = nixpkgs-unstable;
          cfg = {
            allowUnfree = true;
          };
          overlays = [
            neovim.overlay
            deploy-rs.overlay
            (lib.mkOverlays {
              allPkgs = allPkgs-unstable;
              overlayFunc = s: p: (top: last: {
                polar = import ./pkgs { pkgs = p; };
              });
            })
          ];
        };


    in
    {

      # Used with `nixos-rebuild --flake .#<hostname>`
      nixosConfigurations = {
        #polarbear = mkSystem {
        #  hostname = "polarbear";
        #  nixpkgs = nixpkgs-stable;
        #  users = [ ];
        #};
        blackbear = lib.mkNixOS {
          hostname = "blackbear";
          system = "x86_64-linux";
          nixpkgs = nixpkgs-stable;
          allPkgs = allPkgs-stable;
        };
      };


      # Hydra build jobs
      #hydraJobs."<attr>"."<system>" = derivation;

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

    }
    // (inputs.flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs-stable.legacyPackages."${system}";
    in
    {
      # Executed by `nix flake check`
      #checks."<system>"."<name>" = derivation;
      checks = {
        statix = pkgs.runCommand "statix" { } ''
          ${pkgs.statix}/bin/statix check ${./.} --format errfmt | tee output
          [[ "$(cat output)" == "" ]];
          touch $out
        '';
        nixpkgs-fmt = pkgs.runCommand "nixpkgs-fmt" { } ''
          shopt -s globstar
          ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt --check ${./.}/**/*.nix
          touch $out
        '';
      };
      devShell = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          nixFlakes
          nixfmt
          nixpkgs-fmt
          statix
          rnix-lsp
          deploy-rs
          deploy-rs.defaultPackage.x86_64-linux
        ];
      };
    }));
}

