{ pkgs, ... }:
{
  environment.systemPackages = with pkgs;
    [
      st
      dmenu
    ];

  services.xserver = {
    displayManager = {
      lightdm.enable = true;
    };
    windowManager.dwm.enable = true;
  };
}
