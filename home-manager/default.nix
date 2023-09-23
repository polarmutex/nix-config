{
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

  configs = lib.rakeLeaves ./configurations;
  modules = lib.rakeLeaves ./modules;

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
    config.allowUnfree = true;
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
          modules.awesomewm
          modules.direnv
          modules.helix
          modules.firefox
          modules.fish
          modules.fonts
          modules.kitty
          modules.messaging
          modules.obsidian
          modules.picom
          modules.tmux
          modules.wallpaper
          modules.wezterm
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
            home = {
              username = "user";
              homeDirectory = "/home/user";
            };
          }
          modules.direnv
          modules.fish
          modules.htop
          modules.fonts
          modules.kitty
          modules.obsidian
          modules.tmux
          modules.wezterm
        ]
        ++ [configs."user@work"];
    };
  };
}
