{ pkgs, config, lib, overlays, ... }:
{

  imports = [
    ../shared/st.nix
    ../shared/dmenu.nix
    ../shared/dwmblocks.nix
    ../shared/wallpapers.nix
    ../shared/bluetooth.nix
  ];

  home.packages = with pkgs; [
    dwm
  ];

  nixpkgs.overlays = [
    (
      self: super: {
        dwm = super.dwm.overrideAttrs (
          _: {
            src = builtins.fetchGit {
              url = "https://github.com/polarmutex/dwm";
              rev = "cd9d41d8bc5b983aa5a2ec608cc1a6230bf12308";
              ref = "custom";
            };
          }
        );
      }
    )
  ];

  xsession = {
    enable = true;
    windowManager = {
      command = "${pkgs.dwm}/bin/dwm";
    };
    initExtra = ''
      feh --bg-fill --random ~/.config/wallpapers/* &
      xrdb ~/.Xresources
    '';
  };

}
