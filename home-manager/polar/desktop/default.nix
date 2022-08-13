{ pkgs, ... }: {
  imports = [
    ./firefox.nix
    ./wallpaper.nix
    ./wezterm.nix
  ];
  home.packages = with pkgs; [
    pinentry-gnome
  ];

  services.gpg-agent.pinentryFlavor = "gnome3";

  services.picom = {
    backend = "glx";
    enable = true;
    # package = ; # TODO

    activeOpacity = 1.0;
    shadow = true;
  };
}
