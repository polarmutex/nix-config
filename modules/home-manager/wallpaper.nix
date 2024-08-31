{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    feh
  ];

  services.random-background = {
    enable = true;
    display = "scale";
    interval = "15m";
    imageDirectory = "${inputs.wallpapers.packages.${pkgs.system}.polar-wallpapers}/share/wallpapers";
  };
}
