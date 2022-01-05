{ pkgs, config, lib, ... }:
let
  inherit (pkgs) runtimeShell;
  scripts = import ./dwmblocks-scripts.nix { inherit pkgs; };
in
{

  home.packages = with pkgs; [
    dwmblocks
    scripts.clock
    scripts.cpu
    scripts.memory
  ];

  nixpkgs.overlays = [
    (
      self: super: {
        dwmblocks = super.dwmblocks.overrideAttrs (
          oldAttrs: rec {
            src = builtins.fetchGit {
              url = "https://github.com/polarmutex/dwmblocks";
              rev = "b8e8e4ba1203e57f2895dc61f756afac9b51ef56";
              ref = "custom";
            };
          }
        );
      }
    )
  ];

  xsession = {
    initExtra = ''
      dwmblocks &
    '';
  };

}
