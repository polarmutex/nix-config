{
  pkgs,
  inputs,
  ...
}: {
  fonts = {
    #enableDefaultPackages = false;
    enableDefaultFonts = false;
    enableGhostscriptFonts = false;
    fontDir.enable = true;

    #packages = with pkgs; [
    fonts = with pkgs; [
      corefonts
      inputs.monolisa-font-flake.packages.${pkgs.system}.monolisa-custom-font
      twitter-color-emoji
      #(nerdfonts.override { fonts = [ "Hack" ]; })
    ];
  };
}
