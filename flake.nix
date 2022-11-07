{

  description = "PolarMutex Nix Configuration";

  inputs = {
    # Stable NixOS nixpkgs package set; pinned to the 21.11 release.
    nixpkgs = {
      url = "nixpkgs/nixos-unstable";
    };
    #nixpkgs = {
    #  url = "nixpkgs/nixos-22.05";
    #};

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      #inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    awesome-flake = {
      url = "github:polarmutex/awesome-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.polar-nur.follows = "polar-nur";
    };
    neovim-flake = {
      url = "github:polarmutex/neovim-flake";
    };
    polarmutex-blog = {
      url = "github:polarmutex/brianryall.xyz";
    };
    monolisa-font-flake = {
      url = "git+ssh://git@git.brianryall.xyz/polarmutex/monolisa-font-flake.git";
    };

    #nur.url = "github:nix-community/NUR";
    nur.url = "github:nix-community/NUR";
    polar-nur = {
      url = "github:polarmutex/nur";
      inputs.neovim-flake.follows = "neovim-flake";
    };
    hardware.url = "github:nixos/nixos-hardware";

    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      #inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    awesome-git-src = {
      url = "github:awesomeWM/awesome";
      flake = false;
    };

    polar-dwm.url = "github:polarmutex/dwm";
    polar-st.url = "github:polarmutex/st";
    polar-dmenu.url = "github:polarmutex/dmenu";
    tmux-sessionizer.url = "github:polarmutex/tmux-sessionizer";

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

        work_username = (builtins.fromJSON (builtins.readFile ./.secrets/work/info.json)).username;

      in
      {
        # Used with `nixos-rebuild --flake .#<hostname>`
        nixosConfigurations = import ./nixos/configurations.nix inputs;

        homeConfigurations = {
          "polar@polarbear" = home-manager.lib.homeManagerConfiguration {
            pkgs = self.pkgs.x86_64-linux;
            extraSpecialArgs = {
              inherit inputs;
              username = "polar";
              features = [
                "desktop"
                "desktop/awesome.nix"
                "desktop/dendron.nix"
                "desktop/obsidian.nix"
                #"desktop/stacks-taskmang.nix"
                "dev"
                "trusted"
              ];
            };
            modules = [ ./home-manager/polar ];
          };
          "work" = home-manager.lib.homeManagerConfiguration {
            pkgs = self.pkgs."x86_64-linux";
            extraSpecialArgs = {
              inherit inputs;
              username = "blueguardian";
              features = [
                "trusted"
                "desktop"
              ];
            };
            modules = [ ./home-manager/work ];
          };
          "work@redhat" = home-manager.lib.homeManagerConfiguration {
            pkgs = self.pkgs.x86_64-linux;
            extraSpecialArgs = {
              inherit inputs;
              username = "brian";
              features = [
              ];
            };
            modules = [ ./work_redhat ];
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

        overlays = import ./overlays { inherit inputs; };

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
                self.overlays.additions
                self.overlays.modifications
                inputs.deploy-rs.overlay
                inputs.neovim-flake.overlays.default
                inputs.awesome-flake.overlays.default
                inputs.nur.overlay
                (final: prev: {
                  tmux-sessionizer = tmux-sessionizer.packages.${prev.system}.default;
                })
                inputs.monolisa-font-flake.overlay
              ];
              #config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
              #  # browser extensions
              #  "onepassword-password-manager"
              #];
              config.allowUnfree = true;
              config.allowAliases = true;
            };
        });
}

