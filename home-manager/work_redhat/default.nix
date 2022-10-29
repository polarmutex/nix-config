{ inputs, pkgs, lib, username, features, ... }:

let
  inherit (lib) optional mkIf;
  inherit (builtins) map pathExists filter;

in
{
  imports = [
    ./cli
  ]
  # Import features that have modules
  ++ filter pathExists (map (feature: ./${feature}) features);

  programs = {
    home-manager.enable = true;
  };

  home.sessionVariables = {
    GTK_IM_MODULE = "ibus";
    _JAVA_AWT_WM_NONREPARENTING = 1;
  };

  home.packages = with pkgs; [
    lazygit
  ];

  home = {
    inherit username;
    stateVersion = "22.05";
    homeDirectory = "/home/${username}";
  };

  home.sessionPath = [
  ];

  #xsession = {
  #  enable = true;
  #  windowManager = {
  #    awesome = {
  #      enable = true;
  #      package = pkgs.awesome-git;
  #      luaModules = [
  #        pkgs.awesome-battery-widget-git
  #        pkgs.bling-git
  #        pkgs.rubato-git
  #      ];
  #    };
  #  };
  #  #initExtra = ''
  #  #  xrdb ~/.Xresources
  #  #'';
  #};
  #home.file = {
  #  ".config/awesome".source = "${pkgs.awesome-config-polar}";
  #};

  services = {

    # Applets, shown in tray
    # Networking
    #network-manager-applet.enable = true;

    # Bluetooth
    #blueman-applet.enable = true;

    # Pulseaudio
    #pasystray.enable = true;
  };

}
