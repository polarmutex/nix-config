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
}
