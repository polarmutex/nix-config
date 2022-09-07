{ pkgs, ... }: {
  fonts = {
    enableDefaultFonts = false;
    enableGhostscriptFonts = false;
    fontDir.enable = true;

    fonts = with pkgs; [
      corefonts
      monolisa-font
      twitter-color-emoji
      #(nerdfonts.override { fonts = [ "Hack" ]; })
    ];
  };
}
