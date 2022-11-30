{ pkgs, ... }: {
  imports = [
    ./firefox.nix
    ./fonts.nix
    ./thunar.nix
    ./wallpaper.nix
    ./wezterm.nix
  ];
  home.packages = with pkgs; [
    anki-bin
    brave
    networkmanager
    sioyek
    vscodium
  ];

  services = {

    # Applets, shown in tray
    # Networking
    network-manager-applet.enable = true;

    # Bluetooth
    blueman-applet.enable = true;

    # Pulseaudio
    pasystray.enable = true;
  };

  services.picom = {
    backend = "glx";
    enable = true;
    # package = ; # TODO

    activeOpacity = 1.0;
    shadow = true;
  };
}
