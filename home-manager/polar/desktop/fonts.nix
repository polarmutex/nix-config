{ pkgs, lib, config, ... }:
with lib;
{

  fonts.fontconfig.enable = true;
  home.packages = [
    pkgs.twitter-color-emoji
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" "NerdFontsSymbolsOnly" ]; })
  ];

  home.file.".local/share/fonts/MonoLisaCustom-Bold.otf".source = ../../../.secrets/MonoLisaCustom-Bold.otf;
  home.file.".local/share/fonts/MonoLisaCustom-BoldItalic.otf".source = ../../../.secrets/MonoLisaCustom-BoldItalic.otf;
  home.file.".local/share/fonts/MonoLisaCustom-Light.otf".source = ../../../.secrets/MonoLisaCustom-Light.otf;
  home.file.".local/share/fonts/MonoLisaCustom-LightItalic.otf".source = ../../../.secrets/MonoLisaCustom-LightItalic.otf;
  home.file.".local/share/fonts/MonoLisaCustom-Medium.otf".source = ../../../.secrets/MonoLisaCustom-Medium.otf;
  home.file.".local/share/fonts/MonoLisaCustom-MediumItalic.otf".source = ../../../.secrets/MonoLisaCustom-MediumItalic.otf;
  home.file.".local/share/fonts/MonoLisaCustom-Regular.otf".source = ../../../.secrets/MonoLisaCustom-Regular.otf;
  home.file.".local/share/fonts/MonoLisaCustom-RegularItalic.otf".source = ../../../.secrets/MonoLisaCustom-RegularItalic.otf;
}
