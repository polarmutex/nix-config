{
  description = "PolarMutex Nix Configuration";

  inputs = {
    # Stable NixOS nixpkgs package set; pinned to the 21.11 release.
    nixpkgs = {
      url = "nixpkgs/nixos-unstable";
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

    nur.url = "github:nix-community/NUR";
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

  };

  outputs =
    { self, ... }@inputs:
      with inputs;
      let
        getFileList = recursive: isValidFile: path:
          let
            contents = builtins.readDir path;

            list = nixpkgs.lib.mapAttrsToList
              (name: type:
                let
                  newPath = path + ("/" + name);
                in
                if type == "directory"
                then
                  if recursive
                  then getFileList true isValidFile newPath
                  else [ ]
                else nixpkgs.lib.optional (isValidFile newPath) newPath
              )
              contents;
          in
          nixpkgs.lib.flatten list;

        overlay = import ./overlays inputs;

        nixosModules = getFileList true (nixpkgs.lib.hasSuffix ".nix") ./modules/nixos;

        hmModules = getFileList true (nixpkgs.lib.hasSuffix ".nix") ./modules/home-manager;

        # function to create default system config
        mkNixOS = baseCfg:
          nixpkgs.lib.nixosSystem
            {
              system = "x86_64-linux";
              modules = [

                # Make inputs and overlay accessible as module parameters
                #{ _module.args.inputs = inputs; }
                #{ _module.args.self-overlay = self.overlay; }

                (_: {
                  imports = nixosModules ++ [
                    {
                      # Set the $NIX_PATH entry for nixpkgs. This is necessary in
                      # this setup with flakes, otherwise commands like `nix-shell
                      # -p pkgs.htop` will keep using an old version of nixpkgs.
                      # With this entry in $NIX_PATH it is possible (and
                      # recommended) to remove the `nixos` channel for both users
                      # and root e.g. `nix-channel --remove nixos`. `nix-channel
                      # --list` should be empty for all users afterwards
                      nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
                      nixpkgs.overlays = [
                        overlay
                        neovim.overlay
                        nur.overlay
                        polar-dwm.overlay
                        polar-st.overlay
                        polar-dmenu.overlay
                      ];
                      nixpkgs.config.allowUnfree = true;

                      # DON'T set useGlobalPackages! It's not necessary in newer
                      # home-manager versions and does not work with configs using
                      # nixpkgs.config`
                      # TODO
                      home-manager.useUserPackages = true;
                    }
                    baseCfg
                    home-manager.nixosModules.home-manager
                  ];

                  # Let 'nixos-version --json' know the Git revision of this flake.
                  system.configurationRevision =
                    nixpkgs.lib.mkIf (self ? rev) self.rev;
                  nix.registry.nixpkgs.flake = nixpkgs;
                  nix.registry.pinpox.flake = self;
                })
              ];
            };

        # function to create default system config
        mkHomeManager = { username, system, config_file ? "/users/home-${username}.nix", ... }:
          builtins.trace hmModules
            home-manager.lib.homeManagerConfiguration
            {
              system = "x86_64-linux";
              configuration = "${config_file}";
              username = "${username}";
              homeDirectory = "/home/${username}";
              extraModules = hmModules ++ [
                { _module.args.inputs = inputs; }
                #{ _module.args.self-overlay = self.overlay; }
                {
                  nixpkgs = {
                    overlays = [
                      overlay
                      neovim.overlay
                      nur.overlay
                    ];
                    config.allowUnfree = true;
                  };
                }
              ];
            };

      in
      {
        # Each subdirectory in ./hosts is a host. Add them all to
        # nixosConfiguratons. Host configurations need a file called
        # configuration.nix that will be read first
        # Used with `nixos-rebuild --flake .#<hostname>`
        nixosConfigurations = builtins.listToAttrs (map
          (x: {
            name = x;
            value = mkNixOS {
              imports = [
                (./hosts + "/${x}/configuration.nix")
              ];
            };
          })
          (builtins.attrNames (builtins.readDir ./hosts)));

        homeManagerConfigurations = {
          polar = mkHomeManager {
            system = "x86_64-linux";
            username = "polar";
            config_file = ./users/home-polar.nix;
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

        deploy.nodes = {
          blackbear = {
            sshOpts = [ "-p" "22" ];
            hostname = "blackbear";
            fastConnection = true;
            profiles = {
              system = {
                sshUser = "root";
                path =
                  deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.blackbear;
                user = "root";
              };
              user = {
                sshUser = "polar";
                path =
                  deploy-rs.lib.x86_64-linux.activate.home-manager self.homeManagerConfigurations.polar;
                user = "polar";
              };
            };
          };
          polarvortex = {
            sshOpts = [ "-p" "22" ];
            hostname = "polarvortex";
            fastConnection = true;
            profiles = {
              system = {
                sshUser = "root";
                path =
                  deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.polarvortex;
                user = "root";
              };
            };
          };

        };
        #checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

      }
      // (inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";
      in
      {
        # Executed by `nix flake check`
        #checks."<system>"."<name>" = derivation;
        checks = {
          statix = pkgs.runCommand "statix" { } ''
            ${pkgs.statix}/bin/statix check ${./.} --format errfmt | tee output
            [[ "$(cat output)" == "" ]];
            touch $out
          '';
          nixpkgs-fmt = pkgs.runCommand "nixpkgs-fmt" { } ''
            shopt -s globstar
            ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt --check ${./.}/**/*.nix
            touch $out
          '';
        } // (deploy-rs.lib."${system}".deployChecks self.deploy);
        devShell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            nixFlakes
            nixfmt
            nixpkgs-fmt
            statix
            rnix-lsp
            deploy-rs
            deploy-rs.defaultPackage.x86_64-linux
          ];
        };
      }));
}

