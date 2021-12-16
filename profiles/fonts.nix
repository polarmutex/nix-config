{ pkgs, ... }: {
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      corefonts
      monolisafont
    ];
  };
}
