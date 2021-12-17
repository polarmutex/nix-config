{
  description = "PolarMutex Nix Configuration";

  inputs = {
    nixos.url = "nixpkgs/release-21.11";
    latest.url = "nixpkgs/nixos-unstable";

    digga.url = "github:divnix/digga";
    digga.inputs.nixpkgs.follows = "nixos";
    digga.inputs.nixlib.follows = "nixos";
    digga.inputs.home-manager.follows = "home";

    deploy.follows = "digga/deploy";

    home.url = "github:nix-community/home-manager/release-21.11";
    home.inputs.nixpkgs.follows = "nixos";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    #pkgs.url = "path:./pkgs";
    #pkgs.inputs.nixpkgs.follows = "nixos";
    nvfetcher = {
      url = "github:berberman/nvfetcher";
      inputs.nixpkgs.follows = "latest";
    };

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixos";

    neovim = {
      url = github:neovim/neovim?dir=contrib;
      inputs.nixpkgs.follows = "nixos";
    };

    polar-dwm.url = "github:polarmutex/dwm";
    polar-dmenu.url = "github:polarmutex/dmenu";
    polar-st.url = "github:polarmutex/st";

    krops.url = "git+https://cgit.krebsco.de/krops";
    krops.flake = false;
  };

  outputs =
    { self
    , digga
    , nixos
    , home
    , nixos-hardware
    , sops-nix
    , neovim
    , polar-dwm
    , polar-st
    , polar-dmenu
    , deploy
    , nvfetcher
    , ...
    } @ inputs:
    digga.lib.mkFlake {
      inherit self inputs;

      channelsConfig = { allowUnfree = true; };

      channels = {
        nixos = {
          imports = [ (digga.lib.importOverlays ./overlays) ];
          overlays = [
            ./pkgs/default.nix
            sops-nix.overlay
            neovim.overlay
            polar-dwm.overlay
            polar-st.overlay
            polar-dmenu.overlay
            nvfetcher.overlay
          ];
        };

        latest = {
          overlays = [
            deploy.overlay
          ];
        };
      };

      lib = import ./lib { lib = digga.lib // nixos.lib; };

      sharedOverlays = [
        (final: prev: {
          lib = prev.lib.extend (lfinal: lprev: {
            our = self.lib;
          });
        })
      ];

      nixos = {

        hostDefaults = {
          system = "x86_64-linux";
          channelName = "nixos";
          modules = [
            { lib.our = self.lib; }
            digga.nixosModules.bootstrapIso
            digga.nixosModules.nixConfig
            home.nixosModules.home-manager
          ];
        };

        imports = [ (digga.lib.importHosts ./hosts) ];

        hosts = {
          polarbear = {
            modules = with nixos-hardware.nixosModules; [ ];
          };
        };

        importables = rec {
          profiles = digga.lib.rakeLeaves ./profiles // {
            users = digga.lib.rakeLeaves ./users;
          };
          suites = with profiles; rec {
            base = [
              core
              fonts
              desktop.essentials
              desktop.dwm
              users.root
              users.polar
            ];
          };
        };

      };

      home = {
        #modules = ./users/modules/module-list.nix;

        importables = rec {
          profiles = digga.lib.rakeLeaves ./users/profiles;
          suites = with profiles; rec {
            base = [ hm ]
              ++ (with programs;[
              git
              nvim
              tmux
              zsh
              brave
              direnv
            ]);
          };
        };
        users = {
          polar = { suites, ... }: { imports = suites.base; };
        }; # digga

      };

      # Use by running `nix develop`
      devshell = ./shell;
      #devshell = {
      #  env = [
      #    {
      #      name = "sopsPGPKeyDirs";
      #      value = "./secrets/keys/hosts ./secrets/keys/users";
      #    }
      #  ];

      #  devshell.startup = {
      #    sops.text = ''
      #      source ${nixos.sops-pgp-hook.outPath}/nix-support/setup-hook
      #      sopsPGPHook
      #    '';
      #  };

      #  commands = [
      #    {
      #      name = "sops-edit";
      #      category = "secrets";
      #      command = "${nixos.sops}/bin/sops $@";
      #      help = "sops-edit <secretFileName>.yaml | Edit secretFile with sops-nix";
      #    }
      #  ];
      #};

      homeConfigurations = digga.lib.mkHomeConfigurations self.nixosConfigurations;

      deploy.nodes = digga.lib.mkDeployNodes self.nixosConfigurations {
        polarbear = {
          profilesOrder = [ "system" "polar" ];
          profiles.polar = {
            user = "polar";
            path = deploy.lib.x86_64-linux.activate.home-manager self.homeConfigurationsPortable.x86_64-linux.polar;
          };
        };
      };

    };
}
