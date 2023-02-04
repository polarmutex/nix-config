{pkgs, ...}: {
  home.packages = with pkgs; [
    feh
  ];

  services.random-background = {
    enable = true;
    display = "scale";
    interval = "15m";
    imageDirectory = "${pkgs.polar-wallpapers}/share/wallpapers";
  };
}
