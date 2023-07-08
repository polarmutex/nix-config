{
  description = "PolarMutex Nix Configuration";

  nixConfig = {
    extra-substituters = "https://polarmutex.cachix.org";
    extra-trusted-public-keys = "polarmutex.cachix.org-1:kUFH4ftZAlTrKlfFaKfdhKElKnvynBMOg77XRL2pc08=";
    allow-import-from-derivation = "true";
  };

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
    #awesome-git-src = {
    #  url = "github:awesomeWM/awesome";
    #  flake = false;
    #};

    neovim-flake.url = "github:polarmutex/neovim-flake";
    #neovim-flake.url = "path:/home/polar/repos/personal/neovim-flake/main";
    awesome-flake.url = "github:polarmutex/awesome-flake";

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
              inputs',
              pkgs,
              system,
              ...
            }: {
              # make pkgs available to all `perSystem` functions
              _module.args.pkgs = inputs'.nixpkgs.legacyPackages;
              #_module.args.pkgs = nixpkgs {
              #  inherit system overlays;
              #  config.allowUnfree = true;
              #};
              # make custom lib available to all `perSystem` functions
              _module.args.lib = lib;
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
              };
            };
          })
          #treefmt-nix.flakeModule
          #flake-root.flakeModule
          #mission-control.flakeModule
          #./nix
          ./nixos
          ./pkgs
        ];
        systems = ["x86_64-linux"];
      })
    .config
    .flake;
}
