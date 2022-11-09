{ pkgs, lib, config, ... }:
with lib;
{

  fonts.fontconfig.enable = true;
  home.packages = [
    pkgs.twitter-color-emoji
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" "NerdFontsSymbolsOnly" ]; })
    pkgs.monolisa-custom-font
  ];
}
