{
  inputs,
  pkgs,
  ...
}: {
  fonts.fontconfig.enable = true;
  home.packages = [
    pkgs.twitter-color-emoji
    pkgs.nerd-fonts.symbols-only
    pkgs.nerd-fonts.jetbrains-mono
    inputs.monolisa-font-flake.packages.${pkgs.stdenv.hostPlatform.system}.monolisa-custom-font
    pkgs.symbola
  ];
}
