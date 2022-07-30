{

  description = "PolarMutex Nix Configuration";

  inputs = {
    # Stable NixOS nixpkgs package set; pinned to the 21.11 release.
    nixpkgs = {
      url = "nixpkgs/nixos-unstable";
    };
    nixpkgs-22_05 = {
      url = "nixpkgs/22.05";
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
      #url = "path:/home/polar/repos/personal/awesome-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.polar-nur.follows = "polar-nur";
    };
    neovim-flake = {
      url = "github:polarmutex/neovim-flake";
      #url = "path:/home/polar/repos/personal/neovim-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.polar-nur.follows = "polar-nur";
    };

    nur.url = "github:nix-community/NUR";
    polar-nur.url = "github:polarmutex/nur";
    hardware.url = "github:nixos/nixos-hardware";

    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    polar-dwm.url = "github:polarmutex/dwm";
    polar-st.url = "github:polarmutex/st";
    polar-dmenu.url = "github:polarmutex/dmenu";

    rnix-lsp = {
      url = "github:nix-community/rnix-lsp";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

  };

  outputs =
    { self, flake-utils, ... }@inputs:
      with inputs;
      let




        # function to create default system config
        mkHomeManager = { username, system, config_file ? "/users/home-${username}.nix", ... }:
          home-manager.lib.homeManagerConfiguration
            {
              pkgs = nixpkgs.legacyPackages."${system}";
              #system = "x86_64-linux";
              #configuration = "${config_file}";
              #username = "${username}";
              #homeDirectory = "/home/${username}";
              modules = hmModules ++ [
                { _module.args.inputs = inputs; }
                #{ _module.args.self-overlay = self.overlay; }
                {
                  imports = [ "${config_file}" ];
                }
                {
                  nixpkgs = {
                    overlays = [
                      nur.overlay
                      polar-nur.overlays.default
                      (final: _prev: {
                        neovim-polar = neovim-flake.packages.${final.system}.default;
                      })
                      (import ./nix/overlays/node-ifd.nix)
                      neovim-flake.overlay
                      (import ./nix/overlays/monolisa-font.nix)
                      (import ./nix/overlays/fathom.nix)
                    ];
                    config = {
                      allowUnfree = true;
                      allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
                        "onepassword-password-manager"
                        "languagetool"
                      ];
                      permittedInsecurePackages = [
                        "electron-13.6.9"
                      ];
                    };
                  };
                }
              ];
            };

        work_username = (builtins.fromJSON (builtins.readFile ./.secrets/work/info.json)).username;

      in
      {
        # Each subdirectory in ./hosts is a host. Add them all to
        # nixosConfiguratons. Host configurations need a file called
        # configuration.nix that will be read first
        # Used with `nixos-rebuild --flake .#<hostname>`
        nixosConfigurations = import ./nixos/configurations.nix inputs;
        #nixosConfigurations = builtins.listToAttrs (map
        #  (name: {
        #    inherit name;
        #    value = mkNixOS name "x86_64-linux";
        #  })
        #  (builtins.attrNames (builtins.readDir ./hosts)));

        homeManagerConfigurations = {
          work = mkHomeManager {
            system = "x86_64-linux";
            username = work_username;
            config_file = ./users/work.nix;
          };
        };

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
        (system:
        {
          # Executed by `nix flake check`
          checks = import ./nix/checks.nix inputs system;

          devShells.default = import ./nix/dev-shells.nix inputs system;

          pkgs = import
            nixpkgs
            {
              inherit system;
              overlays = [
                self.overlays.default
              ];
              config.allowUnfree = true;
              config.allowAliases = true;
            };
        });
}

