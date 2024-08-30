_: {
  services.xserver = {
    displayManager = {
      #autoLogin = {
      #  enable = true;
      #  user = "polar";
      #};
      gdm = {
        enable = true;
        wayland = false;
      };
    };
  };
}
