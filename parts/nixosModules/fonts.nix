{
  flake.nixosModules.fonts = {
    pkgs,
    inputs,
    ...
  }: {
    fonts = {
      #enableDefaultPackages = false;
      enableDefaultPackages = false;
      enableGhostscriptFonts = false;
      fontDir.enable = true;

      #packages = with pkgs; [
      packages = with pkgs; [
        corefonts
        inputs.monolisa-font-flake.packages.${pkgs.stdenv.hostPlatform.system}.monolisa-code-variable-font
        inputs.monolisa-font-flake.packages.${pkgs.stdenv.hostPlatform.system}.monolisa-text-variable-font
        twitter-color-emoji
        #(nerdfonts.override { fonts = [ "Hack" ]; })
      ];
    };
  };
}
