{pkgs, ...}: {
  home.packages = with pkgs; [
    feh
  ];

  services.random-background = {
    enable = true;
    display = "scale";
    interval = "30m";
    imageDirectory = "${pkgs.polar-wallpapers}/share/wallpapers";
  };
}
