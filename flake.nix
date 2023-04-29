{
  description = "PolarMutex Nix Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-22.11";
    nixpkgs-mine.url = "github:polarmutex/nixpkgs/emacs-beancount-mode";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts";
    leftwm-git.url = "github:leftwm/leftwm";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";

    #deploy-rs.url = "github:serokell/deploy-rs";
    lollypops.url = "github:pinpox/lollypops";
    monolisa-font-flake.url = "git+ssh://git@git.brianryall.xyz/polarmutex/monolisa-font-flake.git";
    #monolisa-font-flake.url = "path:///home/user/repos/personal/monolisa-font-flake";
    wallpapers.url = "git+ssh://git@git.brianryall.xyz/polarmutex/wallpapers.git";
    website.url = "git+ssh://git@git.brianryall.xyz/polarmutex/website.git?ref=feat/rust";
    #awesome-flake = {
    #  url = "github:polarmutex/awesome-flake";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #  inputs.polar-nur.follows = "polar-nur";
    #};
    #awesome-git-src = {
    #  url = "github:awesomeWM/awesome";
    #  flake = false;
    #};
    neovim-flake.url = "github:polarmutex/neovim-flake";
    #neovim-flake.url = "path:/home/polar/repos/personal/neovim-flake/main";
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    rycee = {
      url = "gitlab:rycee/nur-expressions";
      flake = false;
    };
    #hardware.url = "github:nixos/nixos-hardware";
    neovim.url = "github:neovim/neovim?dir=contrib";
    helix.url = "github:helix-editor/helix";
    #polar-dwm.url = "github:polarmutex/dwm";
    #polar-st.url = "github:polarmutex/st";
    #polar-dmenu.url = "github:polarmutex/dmenu";
    tmux-sessionizer.url = "github:polarmutex/tmux-sessionizer";
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
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      imports = [
        ./nixos/flake-module.nix
        ./nixos/configurations
        ./home-manager/flake-module.nix
        ./home-manager/configurations
        ./pkgs
      ];

      perSystem = {
        config,
        inputs',
        pkgs,
        system,
        ...
      }: let
        overlays = with inputs; [
          self.overlays.default
          leftwm-git.overlay
          (_final: prev: {
            neovim-polar = neovim-flake.packages.${prev.system}.default;
          })
          monolisa-font-flake.overlays.default
          (_final: prev: {
            tmux-sessionizer = tmux-sessionizer.packages.${prev.system}.default;
          })
          (_final: prev: {
            inherit (wallpapers.packages.${prev.system}) polar-wallpapers;
          })
          (_final: prev: {
            website = website.packages.${prev.system}.default;
          })
          (_final: _prev: {
            stable = import nixpkgs-stable {
              inherit system;
              config.allowUnfree = true;
            };
          })
          (_final: _prev: {
            mine = import nixpkgs-mine {
              inherit system;
            };
          })
        ];
      in {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.
        _module.args = {
          inherit self inputs;
          pkgs = import nixpkgs {
            inherit system overlays;
            config.allowUnfree = true;
          };
        };

        checks = {
          pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              alejandra = {
                enable = true;
              };
              deadnix = {
                enable = true;
              };
              statix = {
                enable = true;
              };
            };
          };
        };

        devShells = {
          #default = shell {inherit self pkgs;};
          default = pkgs.mkShell {
            name = "nixed-shell";
            packages = with pkgs; [
              #inputs'.deploy-rs.packages.deploy-rs
              #colmena
              home-manager
              statix
            ];
            inherit (self.checks.${system}.pre-commit-check) shellHook;
          };
          #ci = shell {
          #  inherit self pkgs;
          #  ci = true;
          #};
        };
        apps = {
          #default = shell {inherit self pkgs;};
          default = inputs'.lollypops.apps.default {configFlake = self;};
        };
      };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.
        nixosModules = import ./nixos/modules inputs;

        homeModules = import ./home-manager/modules inputs;

        #apps = {
        #  #default = shell {inherit self pkgs;};
        #  default = inputs.lollypops.apps."x86_64-linux".default {configFlake = self;};
        #};
      };
    };
  nixConfig = {
    allow-import-from-derivation = "true";
  };
}
