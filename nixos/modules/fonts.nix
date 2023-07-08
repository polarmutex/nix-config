{
  pkgs,
  inputs,
  ...
}: {
  fonts = {
    enableDefaultFonts = false;
    enableGhostscriptFonts = false;
    fontDir.enable = true;

    fonts = with pkgs; [
      corefonts
      inputs.monolisa-font-flake.packages.${pkgs.system}.monolisa-custom-font
      twitter-color-emoji
      #(nerdfonts.override { fonts = [ "Hack" ]; })
    ];
  };
}
