{ pkgs, ... }: {
  imports = [
    ./firefox.nix
    ./thunar.nix
    ./wallpaper.nix
    ./wezterm.nix
  ];
  home.packages = with pkgs; [
    networkmanager
    pinentry-gnome
    vscodium
  ];

  services.gpg-agent.pinentryFlavor = "gnome3";

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
