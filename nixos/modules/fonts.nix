{monolisa-font-flake, ...}: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.profiles.fonts;
in {
  options.profiles.fonts = {
    enable = lib.mkEnableOption "enable fonts";
  };
  config = lib.mkIf cfg.enable {
    fonts = {
      enableDefaultFonts = false;
      enableGhostscriptFonts = false;
      fontDir.enable = true;

      fonts = with pkgs; [
        corefonts
        monolisa-font-flake.packages.${pkgs.system}.monolisa-custom-font
        twitter-color-emoji
        #(nerdfonts.override { fonts = [ "Hack" ]; })
      ];
    };
  };
}
