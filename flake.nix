{

  description = "PolarMutex Nix Configuration";

  inputs = {
    # Stable NixOS nixpkgs package set; pinned to the 21.11 release.
    nixpkgs-unstable = {
      url = "nixpkgs/nixos-unstable";
    };
    nixpkgs = {
      url = "nixpkgs/nixos-22.05";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    awesome-flake = {
      url = "github:polarmutex/awesome-flake";
    };
    neovim-flake = {
      url = "github:polarmutex/neovim-flake";
    };

    nur.url = "github:nix-community/NUR";
    polar-nur.url = "github:polarmutex/nur";
    hardware.url = "github:nixos/nixos-hardware";

    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.flake-utils.follows = "flake-utils";
    };

    polar-dwm.url = "github:polarmutex/dwm";
    polar-st.url = "github:polarmutex/st";
    polar-dmenu.url = "github:polarmutex/dmenu";

    rnix-lsp = {
      url = "github:nix-community/rnix-lsp";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.utils.follows = "flake-utils";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.flake-utils.follows = "flake-utils";
    };

    nix2vim.url = "github:gytis-ivaskevicius/nix2vim";

  };

  outputs =
    { self, flake-utils, ... }@inputs:
      with inputs;
      let

        work_username = (builtins.fromJSON (builtins.readFile ./.secrets/work/info.json)).username;

      in
      {
        # Used with `nixos-rebuild --flake .#<hostname>`
        nixosConfigurations = import ./nixos/configurations.nix inputs;

        homeConfigurations = import ./home-manager/configurations.nix inputs;

        # Hydra build jobs
        #hydraJobs."<attr>"."<system>" = derivation;
        /* # Hydra build jobs. Builds all configs in the CI to verify integrity
          hydraJobs = (nixpkgs.lib.mapAttrs' (name: config:
          nixpkgs.lib.nameValuePair "nixos-${name}"
          config.config.system.build.toplevel) self.nixosConfigurations);
          # // (nixpkgs.lib.mapAttrs' (name: config: nixpkgs.lib.nameValuePair
          # "home-manager-${name}" config.activation-script)
          # self.hmConfigurations);
        */

        deploy = import ./nix/deploy-rs.nix inputs;
        #deploy.nodes = {
        #  blackbear = {
        #    sshOpts = [ "-p" "22" ];
        #    hostname = "blackbear";
        #    fastConnection = true;
        #    profiles = {
        #      system = {
        #        sshUser = "polar";
        #        path =
        #          deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.blackbear;
        #        user = "root";
        #      };
        #      #user = {
        #      #  sshUser = "polar";
        #      #  path =
        #      #    deploy-rs.lib.x86_64-linux.activate.home-manager self.homeManagerConfigurations.polar;
        #      #  user = "polar";
        #      #};
        #    };
        #  };
        #  polarvortex = {
        #    sshOpts = [ "-p" "22" ];
        #    hostname = "brianryall.xyz";
        #    fastConnection = false;
        #    profiles = {
        #      system = {
        #        sshUser = "polar";
        #        path =
        #          deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.polarvortex;
        #        user = "root";
        #      };
        #    };
        #  };
        #};

        overlays.default = import ./nix/overlay.nix inputs;

      }
      //
      flake-utils.lib.eachSystem [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ]
        (system: {

          # Executed by `nix flake check`
          checks = import ./nix/checks.nix inputs system;

          devShells.default = import ./nix/dev-shells.nix inputs system;

          pkgs = import
            nixpkgs
            {
              inherit system;
              overlays = [
                self.overlays.default
                (final: prev: {
                  unstable = import inputs.nixpkgs-unstable {
                    system = final.system;
                    overlays = [
                      self.overlays.default
                    ];
                    config.allowUnfree = true;
                  };
                })
              ];
              config.allowUnfree = true;
              config.allowAliases = true;
            };
        });
}

