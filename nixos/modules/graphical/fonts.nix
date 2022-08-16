{ pkgs, ... }: {
  fonts = {
    enableDefaultFonts = false;
    enableGhostscriptFonts = false;
    fontDir.enable = true;

    fonts = with pkgs; [
      corefonts
      monolisa-font
      #(nerdfonts.override { fonts = [ "Hack" ]; })
    ];
  };
}
