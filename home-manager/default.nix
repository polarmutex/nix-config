{
  config,
  self,
  inputs,
  lib,
  ...
}: let
  homeManagerConfiguration = args:
    (lib.makeOverridable inputs.home-manager.lib.homeManagerConfiguration)
    (lib.recursiveUpdate args {
      inherit (args) pkgs;
      inherit (args) modules;
      extraSpecialArgs = {
        inherit (inputs) firefox-addons;
      };
    });

  configs = config.flake.lib.rakeLeaves ./configurations;
  modules = config.flake.lib.rakeLeaves ./modules;

  defaultModules = [
    # make flake inputs accessible in NixOS
    {
      _module.args = {
        inherit self;
        inherit inputs;
        inherit lib;
      };
    }
    {
    }
    # load common modules
    ({...}: {
      imports = [
        modules.core
      ];
    })
  ];

  pkgs.x86_64-linux = import inputs.nixpkgs {
    inherit lib;
    system = "x86_64-linux";
    config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "discord"
        "libXNVCtrl"
        "obsidian"
        "steam"
        "steam-original"
        "symbola"
        "zoom"
      ];
    config.permittedInsecurePackages = [
      "electron-25.9.0"
      "zotero-6.0.27"
    ];
  };
in {
  flake.homeConfigurations = {
    "polar@polarbear" = homeManagerConfiguration {
      pkgs = pkgs.x86_64-linux;
      modules =
        defaultModules
        ++ [
          {
            home = {
              username = "polar";
              homeDirectory = "/home/polar";
            };
          }
          inputs.sops-nix.homeManagerModules.sops
          modules.accounts
          modules.awesomewm
          modules.brave
          modules.direnv
          modules.firefox
          modules.fish
          modules.fonts
          modules.gaming
          modules.git
          modules.gpg
          modules.helix
          modules.kitty
          modules.messaging
          modules.obsidian
          modules.picom
          modules.tmux
          modules.wallpaper
          modules.zellij
        ]
        ++ [configs."polar@polarbear"];
    };
    "user@work" = homeManagerConfiguration {
      pkgs = pkgs.x86_64-linux;
      modules =
        defaultModules
        ++ [
          {
            home = let
              user = builtins.getEnv "USER";
              homedir = builtins.getEnv "HOME";
            in {
              username = user;
              homeDirectory = homedir;
            };
          }
          inputs.sops-nix.homeManagerModules.sops
          modules.direnv
          modules.git
          modules.fish
          modules.htop
          modules.fonts
          #modules.kitty
          #modules.tmux
          modules.obsidian
          modules.wezterm
          modules.zellij
        ]
        ++ [configs."user@work"];
    };
  };
}
