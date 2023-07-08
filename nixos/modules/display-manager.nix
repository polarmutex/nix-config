_: {
  services.xserver = {
    displayManager = {
      #autoLogin = {
      #  enable = true;
      #  user = "polar";
      #};
      lightdm = {
        enable = true;
      };
    };
  };
}
