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
  services.dbus.packages = with pkgs; [dconf];

  services.xserver = {
    enable = true;
    updateDbusEnvironment = true;
    #videoDrivers = ["modesetting"]; # Base, all hosts should set accordingly
    layout = "us";
    libinput = {
      enable = true;
      mouse.naturalScrolling = true;
    };

    desktopManager.xterm.enable = false;

    windowManager.leftwm.enable = true;
    windowManager.awesome = {
      enable = true;
      package = inputs.awesome-flake.packages.${pkgs.system}.awesome-git;
    };
  };

  environment.systemPackages = with pkgs; [
    arandr
    st
  ];
}
