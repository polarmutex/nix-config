{

  description = "PolarMutex Nix Configuration";

  inputs = {
    # Stable NixOS nixpkgs package set; pinned to the 21.11 release.
    nixpkgs = {
      url = "nixpkgs/nixos-unstable";
    };
    nixpkgs-local = {
      url = "github:polarmutex/nixpkgs/neovim-fix";
    };
    nixpkgs-master = {
      url = "nixpkgs/master";
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

    awesome-flake = {
      #url = "github:polarmutex/awesome-flake";
      url = "path:/home/polar/repos/personal/awesome-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.polar-nur.follows = "polar-nur";
    };
    neovim-flake = {
      #url = "github:polarmutex/neovim-flake";
      url = "path:/home/polar/repos/personal/neovim-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.polar-nur.follows = "polar-nur";
    };

    nur.url = "github:nix-community/NUR";
    polar-nur.url = "github:polarmutex/nur";
    hardware.url = "github:nixos/nixos-hardware";

    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs-local";
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

        hmModules = [
          ./users/home.nix
          inputs.neovim-flake.home-managerModule
          inputs.awesome-flake.home-managerModule
        ];

        nixosModules = hostname: [
          sops-nix.nixosModules.sops
          nixpkgs.nixosModules.notDetected
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.polar = {
              imports = [
                { _module.args.inputs = inputs; }
                (./. + "/hosts/${hostname}/hm.nix")
              ] ++ hmModules;
            };
          }
        ] ++ getFileList true (nixpkgs.lib.hasSuffix ".nix") ./modules/nixos;

        overlays = [
          overlay
          neovim.overlay
          neovim-flake.overlay
          nur.overlay
          polar-nur.overlays.default
          polar-dwm.overlay
          polar-st.overlay
          polar-dmenu.overlay
          deploy-rs.overlay
          (final: prev: {
            neovim-polar = neovim-flake.packages.${final.system}.default;
          })
          (import ./overlays/node-ifd.nix)
        ];

        pkgs = system: import nixpkgs {
          inherit system;
          inherit overlays;
          config = {
            allowUnfree = true;
            permittedInsecurePackages = [
              "electron-13.6.9"
            ];
          };
        };


        # function to create default system config
        mkNixOS = hostname: system:
          nixpkgs.lib.nixosSystem
            {
              inherit system;

              modules = [
                { _module.args.inputs = inputs; }
                (import (./hosts + "/${hostname}/configuration.nix"))
                {
                  nixpkgs = {
                    pkgs = pkgs "x86_64-linux";
                    inherit ((pkgs system)) config;
                  };
                  system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
                  nix = {
                    #TODO in base package = (pkgs "x86_64-linux").nixFlakes;
                    nixPath =
                      let path = toString ./.; in
                      (nixpkgs.lib.mapAttrsToList (name: _v: "${name}=${inputs.${name}}") inputs) ++ [ "repl=${path}/repl.nix" ];
                    registry =
                      (nixpkgs.lib.mapAttrs'
                        (name: _v: nixpkgs.lib.nameValuePair name { flake = inputs.${name}; })
                        inputs) // { ${hostname}.flake = self; };
                  };
                }
              ] ++ (nixosModules hostname);
            };

        # function to create default system config
        mkHomeManager = { username, system, config_file ? "/users/home-${username}.nix", ... }:
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
                    inherit overlays;
                    config = {
                      allowUnfree = true;
                      permittedInsecurePackages = [
                        "electron-13.6.9"
                      ];
                    };
                  };
                }
              ];
            };

        work_username = (builtins.fromJSON (builtins.readFile ./.secrets/work/info.json)).username;

      in
      {
        # Each subdirectory in ./hosts is a host. Add them all to
        # nixosConfiguratons. Host configurations need a file called
        # configuration.nix that will be read first
        # Used with `nixos-rebuild --flake .#<hostname>`
        nixosConfigurations = builtins.listToAttrs (map
          (hostname: {
            name = hostname;
            value = mkNixOS hostname "x86_64-linux";
          })
          (builtins.attrNames (builtins.readDir ./hosts)));

        homeManagerConfigurations = {
          work = mkHomeManager {
            system = "x86_64-linux";
            username = "${work_username}";
            config_file = ./users/work.nix;
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
                sshUser = "polar";
                path =
                  deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.blackbear;
                user = "root";
              };
              #user = {
              #  sshUser = "polar";
              #  path =
              #    deploy-rs.lib.x86_64-linux.activate.home-manager self.homeManagerConfigurations.polar;
              #  user = "polar";
              #};
            };
          };
          polarvortex = {
            sshOpts = [ "-p" "22" ];
            hostname = "brianryall.xyz";
            fastConnection = false;
            profiles = {
              system = {
                sshUser = "polar";
                path =
                  deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.polarvortex;
                user = "root";
              };
            };
          };

        };

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
          sopsPGPKeyDirs = [
            "./secrets/keys/hosts"
            "./secrets/keys/users"
          ];
          nativeBuildInputs = with pkgs; [
            age
            nixFlakes
            nixfmt
            nixpkgs-fmt
            statix
            rnix-lsp
            deploy-rs.defaultPackage.x86_64-linux
            sops
            (callPackage sops-nix { }).sops-import-keys-hook
          ];
          shellhook = "zsh";
        };
      }));
}

