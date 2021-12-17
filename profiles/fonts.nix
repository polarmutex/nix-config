{ pkgs, ... }: {
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      corefonts
      monolisafont
      (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
    ];
  };
}
