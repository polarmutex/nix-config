{
  config,
  inputs,
  self,
  withSystem,
  ...
}: let
  inherit (config.flake) homeManagerModules;
  # homeManagerConfiguration = args:
  #   (lib.makeOverridable inputs.home-manager.lib.homeManagerConfiguration)
  #   (lib.recursiveUpdate args {
  #     inherit (args) pkgs;
  #     inherit (args) modules;
  #     extraSpecialArgs = {
  #       inherit (inputs) firefox-addons;
  #     };
  #   });

  defaultModules = [
    # make flake inputs accessible in NixOS
    {
      _module.args = {
        inherit inputs;
        inherit self;
        # inherit lib;
      };
    }
    {
    }
    # load common modules
    ({...}: {
      imports = [
        homeManagerModules.core
      ];
    })
  ];
  # pkgs.x86_64-linux = import inputs.nixpkgs {
  #   inherit lib;
  #   system = "x86_64-linux";
  #   config.allowUnfreePredicate = pkg:
  #     builtins.elem (lib.getName pkg) [
  #       "discord"
  #       "libXNVCtrl"
  #       "obsidian"
  #       "steam"
  #       "steam-original"
  #       "symbola"
  #       "zoom"
  #     ];
  #   config.permittedInsecurePackages = [
  #     "electron-25.9.0"
  #     "zotero-6.0.27"
  #   ];
  # };
  configs = config.flake.lib.rakeLeaves ./configurations;
  mkHomeManager = system: extraModules:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = withSystem system ({pkgs, ...}: pkgs);
      modules = defaultModules ++ extraModules;
      extraSpecialArgs = {
        inherit (inputs) firefox-addons;
      };
    };
in {
  flake.homeConfigurations = {
    "polar@polarbear" = let
      system = "x86_64-linux";
      extraModules = [
        inputs.sops-nix.homeManagerModules.sops
        homeManagerModules.accounts
        homeManagerModules.awesomewm
        homeManagerModules.brave
        homeManagerModules.direnv
        homeManagerModules.firefox
        # homeManagerModules.fish
        homeManagerModules.fonts
        homeManagerModules.gaming
        homeManagerModules.ghostty
        homeManagerModules.git
        homeManagerModules.gpg
        homeManagerModules.helix
        # homeManagerModules.hyprland
        # homeManagerModules.hypridle
        # homeManagerModules.hyprpaper
        homeManagerModules.kitty
        homeManagerModules.messaging
        homeManagerModules.nushell
        homeManagerModules.obsidian
        homeManagerModules.picom
        homeManagerModules.tmux
        homeManagerModules.wallpaper
        # homeManagerModules.waybar
        homeManagerModules.zed
        homeManagerModules.zellij
      ];
    in
      withSystem system (_:
        mkHomeManager system (extraModules ++ [configs."polar@polarbear"]));
    "user@work" = let
      system = "x86_64-linux";
      extraModules = [
        inputs.sops-nix.homeManagerModules.sops
        homeManagerModules.direnv
        homeManagerModules.git
        homeManagerModules.fish
        homeManagerModules.htop
        homeManagerModules.fonts
        homeManagerModules.obsidian
        homeManagerModules.wezterm
        homeManagerModules.zellij
      ];
    in
      withSystem system (_:
        mkHomeManager system (extraModules ++ [configs."user@work"]));
    "brian@macbook-air-24" = let
      system = "aarch64-darwin";
      extraModules = [
        # inputs.sops-nix.homeManagerModules.sops
        homeManagerModules.direnv
        # homeManagerModules.git
        homeManagerModules.fish
        homeManagerModules.htop
        homeManagerModules.obsidian
        # homeManagerModules.wezterm
        # homeManagerModules.zellij
      ];
    in
      withSystem system (_:
        mkHomeManager system (extraModules ++ [configs."brian@macbook-air-24"]));
  };
}
