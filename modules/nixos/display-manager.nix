_: {
  # environment.systemPackages = with pkgs; [
  # ];
  services = {
    # displayManager = {
    #   sddm = {
    #     enable = true;
    #     wayland.enable = true;
    #   };
    # };
    xserver = {
      displayManager = {
        # autoLogin = {
        #   enable = true;
        #   user = "polar";
        # };
        gdm = {
          enable = true;
          wayland = true;
        };
      };
    };
  };
}
