_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.profiles.wm-helper;
in {
  options.profiles.wm-helper = {
    enable = lib.mkEnableOption "enable wm-helper";
  };
  config = lib.mkIf cfg.enable {
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
    };

    environment.systemPackages = with pkgs; [
      arandr
      st
    ];
  };
}
