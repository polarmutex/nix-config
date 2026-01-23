{
  inputs,
  pkgs,
  ...
}: {
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland.override {
      # legacyRenderer = false; # whether to use the legacy renderer (for old GPUs)x
    };
    portalPackage = with pkgs; xdg-desktop-portal-hyprland;
    xwayland.enable = true;
  };
  environment.defaultPackages = with pkgs; [kitty];
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
    ];
  };
  # Optional, hint Electron apps to use Wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
