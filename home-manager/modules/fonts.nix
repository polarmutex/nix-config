{
  inputs,
  pkgs,
  ...
}: {
  fonts.fontconfig.enable = true;
  home.packages = [
    pkgs.twitter-color-emoji
    (pkgs.nerdfonts.override {fonts = ["JetBrainsMono" "NerdFontsSymbolsOnly"];})
    inputs.monolisa-font-flake.packages.${pkgs.system}.monolisa-custom-font
  ];
}
