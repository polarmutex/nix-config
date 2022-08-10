{ inputs, pkgs, lib, username, features, ... }:

let
  inherit (lib) optional mkIf;
  inherit (builtins) map pathExists filter;

  workInclude = {
    user = {
      name = "Brian Ryall";
      email = (builtins.fromJSON (builtins.readFile ../../.secrets/work/info.json)).work_email;
    };
  };

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
    ansible
    arandr
    brave
  ];

  home = {
    inherit username;
    stateVersion = "22.05";
    homeDirectory = "/home/${username}";
  };

  programs.zsh.initExtra = ''
    export PATH=$HOME/netbeans-12.0/netbeans/bin:$HOME/.local/bin:$PATH:$HOME/.cargo/env
    export JDTLS_HOME=$HOME/jdtls
    xhost +local:docker
  '';

  polar.programs.awesome.enable = true;

  xsession = {
    enable = true;
    windowManager = {
      awesome = {
        enable = true;
        package = pkgs.awesome-git;
        luaModules = [
          pkgs.awesome-battery-widget-git
          pkgs.bling-git
          pkgs.rubato-git
        ];
      };
    };
    #initExtra = ''
    #  xrdb ~/.Xresources
    #'';
  };

  services = {

    # Applets, shown in tray
    # Networking
    network-manager-applet.enable = true;

    # Bluetooth
    #blueman-applet.enable = true;

    # Pulseaudio
    #pasystray.enable = true;
  };

}
