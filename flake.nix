{
  description = "PolarMutex Nix Configuration";

  nixConfig = {
    extra-substituters = [
      "https://polarmutex.cachix.org"
      "https://polar-nvim.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "polarmutex.cachix.org-1:kUFH4ftZAlTrKlfFaKfdhKElKnvynBMOg77XRL2pc08="
      "polar-nvim.cachix.org-1:fToTj9wmSN7xPzjwVbZivoT+pVF3hoTeIqo2brEO1a8="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    # allow-import-from-derivation = "true";
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    flake-compat.url = "github:edolstra/flake-compat";
    flake-utils.url = "github:numtide/flake-utils";
    flake-parts.url = "github:hercules-ci/flake-parts";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hardware.url = "github:nixos/nixos-hardware";

    polar-nur.url = "github:polarmutex/nur";

    awesome-flake = {
      url = "github:polarmutex/awesome-flake";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix = {
      url = "github:helix-editor/helix";
    };
    monolisa-font-flake = {
      url = "git+ssh://git@git.brianryall.xyz/polarmutex/monolisa-font-flake.git";
      #url = "path:///home/polar/repos/personal/monolisa-font-flake";
    };
    neovim-flake = {
      url = "github:polarmutex/neovim-flake";
      # url = "path:/home/polar/repos/personal/neovim-flake/main";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tmux-sessionizer = {
      url = "github:polarmutex/tmux-sessionizer";
    };
    wallpapers = {
      url = "git+ssh://git@git.brianryall.xyz/polarmutex/wallpapers.git";
      #url = "path:///home/polar/repos/personal/wallpapers";
    };
    #website = {
    #  url = "git+ssh://git@git.brianryall.xyz/polarmutex/website.git";
    #};
    wrapper-manager = {
      url = "github:viperML/wrapper-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noshell = {
      url = "github:viperML/noshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # DO I still need?
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    rycee = {
      url = "gitlab:rycee/nur-expressions";
      flake = false;
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    programsdb.url = "github:wamserma/flake-programs-sqlite";
    programsdb.inputs.nixpkgs.follows = "nixpkgs";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = inputs @ {
    self,
    flake-parts,
    ...
  }:
    (flake-parts.lib.evalFlakeModule
      {
        inherit inputs;
        specialArgs = {};
      }
      {
        imports = [
          (_: {
            perSystem = {
              #config,
              #inputs',
              pkgs,
              system,
              ...
            }: {
              # make pkgs available to all `perSystem` functions
              #_module.args.pkgs = inputs'.nixpkgs.legacyPackages;
              #_module.args.pkgs = nixpkgs {
              #  inherit system overlays;
              #  config.allowUnfree = true;
              #};
              # make custom lib available to all `perSystem` functions
              # checks =
              # {
              #   pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
              #     src = ./.;
              #     hooks = {
              #       alejandra = {
              #         enable = true;
              #       };
              #       deadnix = {
              #         enable = true;
              #       };
              #       statix = {
              #         enable = true;
              #       };
              #     };
              #   };
              # }
              #//
              # inputs.deploy-rs.lib.${system}.deployChecks inputs.self.deploy;

              devShells = {
                #default = shell {inherit self pkgs;};
                default = pkgs.mkShell {
                  name = "nixed-shell";
                  packages = with pkgs; [
                    #age
                    home-manager
                    sops
                    #statix
                    #lm_sensors
                  ];
                  # inherit (self.checks.${system}.pre-commit-check) shellHook;
                };
              };
            };
          })
          #treefmt-nix.flakeModule
          #flake-root.flakeModule
          #mission-control.flakeModule
          #./nix
          ./home-manager
          ./pkgs
          ./wrappers
          ./hosts
          ./modules
          ./lib
        ];
        systems = ["x86_64-linux" "aarch64-darwin"];
        # flake = {
        #   deploy = {
        #     nodes = {
        #       polarvortex = {
        #         hostname = "brianryall.xyz";
        #         profiles.system = {
        #           sshUser = "polar";
        #           sudo = "doas -u";
        #           user = "root";
        #           path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.polarvortex;
        #         };
        #       };
        #     };
        #   };
        # };
      })
    .config
    .flake;
}
