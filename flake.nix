{
  description = "PolarMutex Nix Configuration";

  nixConfig = {
    extra-substituters = "https://polarmutex.cachix.org";
    extra-trusted-public-keys = "polarmutex.cachix.org-1:kUFH4ftZAlTrKlfFaKfdhKElKnvynBMOg77XRL2pc08=";
    allow-import-from-derivation = "true";
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-23.11";
    #nixpkgs-mine.url = "github:polarmutex/nixpkgs/emacs-beancount-mode";

    flake-compat.url = "github:edolstra/flake-compat";
    flake-utils.url = "github:numtide/flake-utils";
    flake-parts.url = "github:hercules-ci/flake-parts";

    awesome-flake = {
      url = "github:polarmutex/awesome-flake";
    };
    #crane = {
    #  url = "github:ipetkov/crane";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
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
    neovim = {
      url = "github:neovim/neovim?dir=contrib";
    };
    neovim-flake = {
      url = "github:polarmutex/neovim-flake";
      #url = "path:/home/polar/repos/personal/neovim-flake/main";
    };
    nvfetcher = {
      url = "github:berberman/nvfetcher/0.6.2";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
      };
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
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

    # DO I still need?
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    rycee = {
      url = "gitlab:rycee/nur-expressions";
      flake = false;
    };
    #hardware.url = "github:nixos/nixos-hardware";
    #polar-dwm.url = "github:polarmutex/dwm";
    #polar-st.url = "github:polarmutex/st";
    #polar-dmenu.url = "github:polarmutex/dmenu";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    programsdb.url = "github:wamserma/flake-programs-sqlite";
    programsdb.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    flake-parts,
    nixpkgs,
    ...
  }: let
    lib = import ./lib {inherit (nixpkgs) lib;} // nixpkgs.lib;
  in
    (flake-parts.lib.evalFlakeModule
      {
        inherit inputs;
        specialArgs = {inherit lib;};
      }
      {
        debug = true;
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
              _module.args.lib = lib;
              checks =
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
                inputs.deploy-rs.lib.${system}.deployChecks inputs.self.deploy;

              devShells = {
                #default = shell {inherit self pkgs;};
                default = pkgs.mkShell {
                  name = "nixed-shell";
                  packages = with pkgs; [
                    age
                    inputs.deploy-rs.packages.${system}.deploy-rs
                    home-manager
                    npins
                    nix-diff
                    sops
                    statix
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
          ./nixos
          ./pkgs
          ./wrappers
        ];
        systems = ["x86_64-linux"];
        flake = {
          deploy = {
            nodes = {
              polarvortex = {
                hostname = "brianryall.xyz";
                profiles.system = {
                  sshUser = "polar";
                  sudo = "doas -u";
                  user = "root";
                  path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.polarvortex;
                };
              };
            };
          };
        };
      })
    .config
    .flake;
}
