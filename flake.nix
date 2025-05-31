{
  description = "PolarMutex Nix Configuration";

  nixConfig = {
    extra-substituters = [
      "https://polarmutex.cachix.org"
      "https://polar-nvim.cachix.org"
      "https://nix-community.cachix.org"
      "https://cosmic.cachix.org/"
    ];
    extra-trusted-public-keys = [
      "polarmutex.cachix.org-1:kUFH4ftZAlTrKlfFaKfdhKElKnvynBMOg77XRL2pc08="
      "polar-nvim.cachix.org-1:fToTj9wmSN7xPzjwVbZivoT+pVF3hoTeIqo2brEO1a8="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
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
          # inputs.home-manager.flakeModules.home-manager
          ./packages
          ./misc/lib
          ./hosts
          ./home-manager
          # ./wrappers
          # ./modules
          # ./lib
        ];

        flake = {
          nixosModules = config.flake.lib.dirToAttrs ./modules/nixos;
          homeModules = config.flake.lib.dirToAttrs ./modules/home-manager;
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
          # config,
          ...
        }: {
          devShells.default = with pkgs;
            mkShellNoCC {
              packages = [
                # home-manager
                sops
                age
                deploy-rs
                # taplo
                inxi
                pciutils
              ];
            };
        };
      }
    );

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

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

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.nixpkgs-stable.follows = "nixpkgs-stable";
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
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    home-manager = {
      # url = "github:nix-community/home-manager/master";
      url = "github:nix-community/home-manager/release-25.05";
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
}
