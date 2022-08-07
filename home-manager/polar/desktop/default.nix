{ pkgs, ... }: {
  imports = [
    ./firefox.nix
    ./wezterm.nix
  ];
  home.packages = with pkgs; [
  ];
}
