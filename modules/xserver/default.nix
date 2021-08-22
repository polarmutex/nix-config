{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.polar.services.xserver;
in
{

  options.polar.services.xserver = { enable = mkEnableOption "X server"; };

  config = mkIf cfg.enable {

    hardware.video.hidpi.enable = lib.mkDefault true;

    services.xserver = {
      enable = true;
      autorun = true;
      layout = "us";
      dpi = 163;

      displayManager.gdm.enable = true;

      desktopManager = {
        xterm.enable = false;
        session = [
          {
            name = "home-manager";
            start = ''
               ${pkgs.runtimeShell} $HOME/.hm-xsession &
              waitPID=$!
            '';
          }
        ];
      };
    };
  };
}
