{
  description = "PolarMutex Nix Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/release-22.11";

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
    nur.url = "github:nix-community/NUR";
    #hardware.url = "github:nixos/nixos-hardware";
    neovim.url = "github:neovim/neovim?dir=contrib";
    helix.url = "github:helix-editor/helix";
    #polar-dwm.url = "github:polarmutex/dwm";
    #polar-st.url = "github:polarmutex/st";
    #polar-dmenu.url = "github:polarmutex/dmenu";
    tmux-sessionizer.url = "github:polarmutex/tmux-sessionizer";
    #sops-nix = {
    #  url = "github:Mic92/sops-nix";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
  };

  outputs = inputs @ {
    self,
    flake-parts,
    nixpkgs,
    ...
  }: let
    lib = import ./lib inputs;
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        ./nixos/configurations.nix
        ./home-manager/configurations.nix
        ./pkgs
      ];
      systems = ["x86_64-linux"];
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: let
        overlays = with inputs; [
          self.overlays.default
          leftwm-git.overlay
          (final: prev: {
            neovim-polar = neovim-flake.packages.${prev.system}.default;
          })
          nur.overlay
          monolisa-font-flake.overlays.default
          (final: prev: {
            tmux-sessionizer = tmux-sessionizer.packages.${prev.system}.default;
          })
          (final: prev: {
            polar-wallpapers = wallpapers.packages.${prev.system}.polar-wallpapers;
          })
          (final: prev: {
            website = website.packages.${prev.system}.default;
          })
          (_final: _prev: {
            stable = import nixpkgs-stable {
              inherit system;
              config.allowUnfree = true;
            };
          })
        ];
      in {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.
        _module.args = {
          inherit self inputs lib;
          pkgs = import nixpkgs {
            inherit system overlays;
            config.allowUnfree = true;
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
            ];
            #shellHook = lib.optionalString (!ci) ''
            #  ${self.checks.${pkgs.system}.pre-commit-check.shellHook}
            #'';
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
        inherit lib;
        #apps = {
        #  #default = shell {inherit self pkgs;};
        #  default = inputs.lollypops.apps."x86_64-linux".default {configFlake = self;};
        #};
      };
    };
}
# TODO pre-commit-check
#            pre-commit-check = pre-commit-hooks.lib.${system}.run
#              {
#                src = pkgs.lib.cleanSource ./.;
#                hooks = {
#nix-linter.enable = true;
#nixpkgs-fmt.enable = true;
#statix.enable = true;
#stylua = {
#  enable = true;
#  types = [ "file" "lua" ];
#  entry = "${stylua}/bin/stylua";
#};
#luacheck = {
#  enable = true;
#  types = [ "file" "lua" ];
#  entry = "${luajitPackages.luacheck}/bin/luacheck --std luajit --globals vim -- ";
#};
#                  actionlint = {
#                    enable = true;
#                    files = "^.github/workflows/";
#                    types = [ "yaml" ];
#                    entry = "${pkgs.actionlint}/bin/actionlint";
#                  };
#                };
#                settings.nix-linter.checks = [
#                  "DIYInherit"
#                  "EmptyInherit"
#                  "EmptyLet"
#                  "EtaReduce"
#                  "LetInInheritRecset"
#                  "ListLiteralConcat"
#                  "NegateAtom"
#                  "SequentialLet"
#                  "SetLiteralUpdate"
#                  "UnfortunateArgName"
#                  "UnneededRec"
#                  "UnusedArg"
#                  "UnusedLetBind"
#                  "UpdateEmptySet"
#                  "BetaReduction"
#                  "EmptyVariadicParamSet"
#                  "UnneededAntiquote"
#                  "no-FreeLetInFunc"
#                  "no-AlphabeticalArgs"
#                  "no-AlphabeticalBindings"
#                ];
#              };
#statix = pkgs.runCommand "statix" { } ''
#  ${pkgs.statix}/bin/statix check ${./.} --format errfmt | tee output
#  [[ "$(cat output)" == "" ]];
#  touch $out
#'';
#nixpkgs-fmt = pkgs.runCommand "nixpkgs-fmt" { } ''
#  shopt -s globstar
#  ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt --check ${./.}/**/*.nix
#  touch $out
#'';
#          } // (pkgs.deploy-rs.lib.deployChecks self.deploy);
#        devShells = {
#          default = import ./shell.nix inputs system;
#        };
#        legacyPackages = import
#          nixpkgs
#          {
#            inherit system;
#            overlays = [
#              self.overlays.additions
#              self.overlays.modifications
#              inputs.deploy-rs.overlay
#              inputs.neovim-flake.overlays.default
#              inputs.awesome-flake.overlays.default
#              inputs.nur.overlay
#              inputs.leftwm-git.overlay
#              inputs.polar-dmenu.overlay
#              inputs.monolisa-font-flake.overlay
#            ];
#            config.allowUnfree = true;
#          };
#      });
#}
