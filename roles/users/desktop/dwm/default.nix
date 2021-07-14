{ pkgs, config, lib, overlays, ... }:
{

  imports = [
    ../shared/st.nix
    ../shared/dmenu.nix
    ../shared/dwmblocks.nix
    ../shared/wallpapers.nix
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
              rev = "f9e8c451445dc9dcf3408397c0a9d3324c2941f6";
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
