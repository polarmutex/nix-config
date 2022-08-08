{ pkgs, lib, config, ... }:
with lib;
{

  fonts.fontconfig.enable = true;
  home.packages = [
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
  ];

  home.file.".local/share/fonts/MonoLisa-Regular-Nerd-Font-Complete.otf".source = ../../../.secrets/MonoLisa-Regular-Nerd-Font-Complete.otf;
  home.file.".local/share/fonts/MonoLisa-Regular-Italic-Nerd-Font-Complete.otf".source = ../../../.secrets/MonoLisa-Regular-Italic-Nerd-Font-Complete.otf;
  home.file.".local/share/fonts/MonoLisa-Bold-Nerd-Font-Complete.otf".source = ../../../.secrets/MonoLisa-Bold-Nerd-Font-Complete.otf;
  home.file.".local/share/fonts/MonoLisa-Bold-Italic-Nerd-Font-Complete.otf".source = ../../../.secrets/MonoLisa-Bold-Italic-Nerd-Font-Complete.otf;
}
