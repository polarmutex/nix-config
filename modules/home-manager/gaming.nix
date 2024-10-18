{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # (lutris.override {extraPkgs = pkgs: [pkgs.jansson];})
    # inputs.nix-gaming.packages.${pkgs.system}.wine-ge
    # wineWowPackages.staging
    # winetricks
    # bottles
  ];
}
