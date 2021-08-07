{ pkgs, config, lib, overlays, ... }:
let
  utils = import ../../utils.nix { config = config; };

in
{

  imports = [
    ../shared/st.nix
    ../shared/dmenu.nix
    ../shared/wallpapers.nix
    ../shared/bluetooth.nix
    ../shared/picom.nix
    ../shared/rofi.nix
  ];

  home.packages = with pkgs; [
    awesome
  ];

  nixpkgs.overlays = [
    (
      self: super: {
        awesome = (
          super.awesome.overrideAttrs (
            old: rec {
              src = super.fetchFromGitHub {
                owner = "awesomeWM";
                repo = "awesome";
                rev = "8a81745d4d0466c0d4b346762a80e4f566c83461";
                sha256 = "5jg2X4u42yExa8sZaMhjbBA5HuQijWOn1QO87WwyPQw=";
              };
              GI_TYPELIB_PATH = "${super.playerctl}/lib/girepository-1.0:"
              + "${super.upower}/lib/girepository-1.0:" + old.GI_TYPELIB_PATH;
            }
          )
        ).override {
          stdenv = super.clangStdenv;
          luaPackages = super.lua52Packages;
          gtk3Support = true;
        };
      }
    )
  ];


  xdg.configFile = utils.link-one "config" "." "awesome";

  xsession = {
    enable = true;
    windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        luarocks # is the package manager for Lua modules
      ];
    };
    initExtra = ''
      feh --bg-fill --random ~/.config/wallpapers/* &
      xrdb ~/.Xresources
    '';
  };

}
