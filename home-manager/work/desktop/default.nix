{ pkgs, ... }:
{
  imports = [
    ../../polar/desktop/firefox.nix
    ../../polar/desktop/fonts.nix
    ../../polar/desktop/obsidian.nix
    ../../polar/desktop/thunar.nix
    ../../polar/desktop/wallpaper.nix
    ../../polar/desktop/wezterm.nix
  ];

  home.packages = with pkgs; [
    libreoffice-fresh
    vscodium
  ];

}
