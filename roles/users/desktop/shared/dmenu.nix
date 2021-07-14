{ pkgs, config, lib, ... }:
{

  home.packages = with pkgs; [
    dmenu
  ];

  nixpkgs.overlays = [
    (
      self: super: {
        dmenu = super.dmenu.overrideAttrs (
          oldAttrs: rec {
            src = builtins.fetchGit {
              url = "https://github.com/polarmutex/dmenu";
              rev = "1e6783bc0bba32d402f6185e23702055b7bf0acf";
              ref = "custom";
            };
          }
        );
      }
    )
  ];

}
