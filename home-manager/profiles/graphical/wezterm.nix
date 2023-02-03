{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  dot = path: "${config.home.homeDirectory}/repos/personal/nix-config/home-manager/polar/desktop/${path}";

  link = path: let
    fullpath = dot path;
  in
    config.lib.file.mkOutOfStoreSymlink fullpath;

  cfg = config.polar.programs.wezterm;
in {
  home.sessionVariables.TERMINAL = "wezterm start --always-new-process";
  #xdg.configFile."wezterm/wezterm.lua".source = link "wezterm.lua";
  xdg.configFile."wezterm/wezterm.lua".source = ./wezterm.lua;
  home.packages = with pkgs; [
    wezterm
  ];
}
