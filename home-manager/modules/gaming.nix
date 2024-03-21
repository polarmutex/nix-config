{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    lutris
    inputs.nix-gaming.packages.${pkgs.system}.wine-ge
    # wineWowPackages.staging
    winetricks
    bottles
  ];
}
