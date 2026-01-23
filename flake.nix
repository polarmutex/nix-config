{
  description = "PolarMutex Nix Configuration";

  nixConfig = {
    extra-substituters = [
      "https://polarmutex.cachix.org"
      "https://nix-community.cachix.org"
      "https://cosmic.cachix.org/"
      "https://zed.cachix.org"
      "https://numtide.cachix.org"
    ];
    extra-trusted-public-keys = [
      "polarmutex.cachix.org-1:kUFH4ftZAlTrKlfFaKfdhKElKnvynBMOg77XRL2pc08="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
      "zed.cachix.org-1:/pHQ6dpMsAZk2DiP4WCL0p9YDNKWj2Q5FL20bNmw1cU="
      "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
    ];
    # allow-import-from-derivation = "true";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} (
      {
        # lib,
        config,
        self,
        ...
      }: {
        imports = [
          ./packages
          ./misc/lib
          ./hosts
          # ./wrappers
          # ./modules
          # ./lib
        ];

        flake = {
          nixosModules = config.flake.lib.dirToAttrs ./modules/nixos;
          maidModules = config.flake.lib.dirToAttrs ./modules/maid;
          deploy = {
            nodes = {
              polarvortex = {
                hostname = "polarvortex";
                profiles.system = {
                  sshUser = "polar";
                  # sudo = "doas -u";
                  user = "root";
                  path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.polarvortex;
                };
              };
              vm-intel = {
                hostname = "vm-dev";
                profiles.system = {
                  sshUser = "polar";
                  sudo = "doas -u";
                  user = "root";
                  path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.vm-intel;
                };
              };
            };
          };
        };

        systems = [
          "x86_64-linux"
          "aarch64-linux"
        ];

        perSystem = {
          pkgs,
          system,
          # config,
          ...
        }: {
          devShells.default = with pkgs;
            mkShellNoCC {
              packages = [
                sops
                age
                deploy-rs
                # taplo
                inxi
                pciutils
                # nvtop
                mesa-demos
                nh
                lm_sensors
                nix-update
                inputs.bun2nix.packages.${pkgs.stdenv.hostPlatform.system}.default
                neovim.devMode
              ];
            };
        };
      }
    );

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    flake-compat.url = "github:edolstra/flake-compat";
    flake-utils.url = "github:numtide/flake-utils";
    flake-parts.url = "github:hercules-ci/flake-parts";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hardware.url = "github:nixos/nixos-hardware";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    polar-nur.url = "github:polarmutex/nur";

    awesome-flake = {
      url = "github:polarmutex/awesome-flake";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix = {
      url = "github:helix-editor/helix";
    };
    monolisa-font-flake = {
      url = "git+ssh://git@git.polarmutex.dev/polar/monolisa-font-flake.git";
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
      url = "git+ssh://git@git.polarmutex.dev/polar/wallpapers.git";
      #url = "path:///home/polar/repos/personal/wallpapers";
    };
    website = {
      url = "github:polarmutex/website/dev";
    };
    wrapper-manager = {
      url = "github:viperML/wrapper-manager";
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

    nix-maid = {
      url = "github:viperML/nix-maid";
    };
    nix-ai-tools.url = "github:numtide/nix-ai-tools";
    flakey-profile.url = "github:lf-/flakey-profile";
    nixgl.url = "github:nix-community/nixGL";
    zed = {
      url = "github:zed-industries/zed/nightly";
    };
    beancount-repo = {
      url = "git+ssh://git@git.polarmutex.dev/polar/beancount.git";
    };
    bun2nix = {
      url = "github:nix-community/bun2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
