{monolisa-font-flake, ...}: {
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.profiles.fonts;
in {
  options.profiles.fonts = {
    enable = lib.mkEnableOption "A profile that enables fonts";
  };

  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    home.packages = [
      pkgs.twitter-color-emoji
      (pkgs.nerdfonts.override {fonts = ["JetBrainsMono" "NerdFontsSymbolsOnly"];})
      monolisa-font-flake.packages.${pkgs.system}.monolisa-custom-font
    ];
  };
}
