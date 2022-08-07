{ pkgs, ... }: {
  imports = [
    ./firefox.nix
    ./wezterm.nix
  ];
  home.packages = with pkgs; [
    pinentry-gnome
  ];

  services.gpg-agent.pinentryFlavor = "gnome3";
}
