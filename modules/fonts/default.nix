{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.polar.defaults.fonts;
in
{

  options.polar.defaults.fonts = { enable = mkEnableOption "Fonts defaults"; };

  config = mkIf cfg.enable {

    # Install some fonts system-wide, especially "Source Code Pro" in the
    # Nerd-Fonts pached version with extra glyphs.

    fonts = {
      fontDir.enable = true;
      fonts = with pkgs; [
        corefonts
      ];
    };
  };
}
