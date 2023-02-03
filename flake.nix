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
    #deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
    lollypops.url = "github:pinpox/lollypops";

    monolisa-font-flake.url = "git+ssh://git@git.brianryall.xyz/polarmutex/monolisa-font-flake.git";
    #monolisa-font-flake.url = "path:///home/user/repos/personal/monolisa-font-flake";
    wallpapers.url = "git+ssh://git@git.brianryall.xyz/polarmutex/wallpapers.git";

    #awesome-flake = {
    #  url = "github:polarmutex/awesome-flake";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #  inputs.polar-nur.follows = "polar-nur";
    #};
    neovim-flake.url = "github:polarmutex/neovim-flake";
    #polarmutex-blog = {
    #  url = "github:polarmutex/brianryall.xyz";
    #};

    nur.url = "github:nix-community/NUR";
    #nur.url = "github:nix-community/NUR";
    #polar-nur = {
    #  url = "github:polarmutex/nur";
    #  inputs.neovim-flake.follows = "neovim-flake";
    #};
    #hardware.url = "github:nixos/nixos-hardware";

    neovim.url = "github:neovim/neovim?dir=contrib";
    #  #inputs.nixpkgs.follows = "nixpkgs";
    #  inputs.flake-utils.follows = "flake-utils";
    #};
    #awesome-git-src = {
    #  url = "github:awesomeWM/awesome";
    #  flake = false;
    #};

    #polar-dwm.url = "github:polarmutex/dwm";
    #polar-st.url = "github:polarmutex/st";
    #polar-dmenu.url = "github:polarmutex/dmenu";
    tmux-sessionizer.url = "github:polarmutex/tmux-sessionizer";

    #rnix-lsp = {
    #  url = "github:nix-community/rnix-lsp";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #  inputs.utils.follows = "flake-utils";
    #};

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
#    with inputs;
#    let
#    in
#    {
# Used with `nixos-rebuild --flake .#<hostname>`
#      nixosConfigurations = {
#        polarbear = nixpkgs.lib.nixosSystem {
#          pkgs = self.legacyPackages.x86_64-linux;
#          specialArgs = { inherit inputs; };
#          modules = [
#            ./nixos/polarbear/configuration.nix
#            sops-nix.nixosModules.sops
#          ];
#        };
#        polarvortex = nixpkgs.lib.nixosSystem {
#          pkgs = self.legacyPackages.x86_64-linux;
#          specialArgs = { inherit inputs; };
#          modules = [
#            ./nixos/polarvortex/configuration.nix
#            sops-nix.nixosModules.sops
#          ];
#        };
#        blackbear = nixpkgs.lib.nixosSystem {
#          pkgs = self.legacyPackages.x86_64-linux;
#          specialArgs = { inherit inputs; };
#          modules = [ ./nixos/blackbear/configuration.nix ];
#        };
#      };
#      homeConfigurations = {
#        "polar@polarbear" = home-manager.lib.homeManagerConfiguration {
#          pkgs = self.legacyPackages.x86_64-linux;
#          extraSpecialArgs = {
#            inherit inputs;
#            username = "polar";
#            features = [
#              "desktop"
#              "desktop/awesome.nix"
#              "desktop/leftwm.nix"
#              "desktop/eww.nix"
#              "desktop/dendron.nix"
#              "desktop/obsidian.nix"
#              #"desktop/stacks-taskmang.nix"
#              "dev"
#              "trusted"
#            ];
#          };
#          modules = [ ./home-manager/polar ];
#        };
#        "work" = home-manager.lib.homeManagerConfiguration {
#          pkgs = self.legacyPackages."x86_64-linux";
#          extraSpecialArgs = {
#            inherit inputs;
#            username = "polar";
#            features = [
#              "trusted"
#              "desktop"
#            ];
#          };
#          modules = [ ./home-manager/work ];
#        };
#        "work@redhat" = home-manager.lib.homeManagerConfiguration {
#          pkgs = self.legacyPackages.x86_64-linux;
#          extraSpecialArgs = {
#            inherit inputs;
#            username = "brian";
#            features = [
#            ];
#          };
#          modules = [ ./work_redhat ];
#        };
#      };
# Hydra build jobs
#hydraJobs."<attr>"."<system>" = derivation;
/*
# Hydra build jobs. Builds all configs in the CI to verify integrity
hydraJobs = (nixpkgs.lib.mapAttrs' (name: config:
nixpkgs.lib.nameValuePair "nixos-${name}"
config.config.system.build.toplevel) self.nixosConfigurations);
# // (nixpkgs.lib.mapAttrs' (name: config: nixpkgs.lib.nameValuePair
# "home-manager-${name}" config.activation-script)
# self.hmConfigurations);
*/
#      deploy = import ./deploy-rs.nix inputs;
#      overlays = import ./overlays { inherit inputs; };
#    }
#    //
#    flake-utils.lib.eachSystem [
#      "x86_64-linux"
#      "aarch64-linux"
#      "aarch64-darwin"
#      "x86_64-darwin"
#    ]
#      (system: {
# Executed by `nix flake check`
#        checks =
#          let
#            pkgs = self.legacyPackages."${system}";
#          in
#          {
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
