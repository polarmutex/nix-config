{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    terminal = "${pkgs.st}/bin/st";
    theme = ./rofi-gruvbox-theme.rasi;
  };
}
