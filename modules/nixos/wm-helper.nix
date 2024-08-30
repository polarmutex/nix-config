{
  inputs,
  pkgs,
  ...
}: {
  # Graphics support
  #hardware.opengl = {
  #  enable = true;
  #  driSupport = true;
  #  driSupport32Bit = true;
  #};

  # Theming helpers
  programs.dconf.enable = true;
  services = {
    dbus.packages = with pkgs; [dconf];

    libinput = {
      enable = true;
      mouse.naturalScrolling = true;
    };

    xserver = {
      enable = true;
      updateDbusEnvironment = true;
      #videoDrivers = ["modesetting"]; # Base, all hosts should set accordingly
      xkb.layout = "us";

      desktopManager.xterm.enable = false;

      windowManager.leftwm.enable = true;
      windowManager.awesome = {
        enable = true;
        package = inputs.awesome-flake.packages.${pkgs.system}.awesome-git;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    arandr
    st
  ];
}
