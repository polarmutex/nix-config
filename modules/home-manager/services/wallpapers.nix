{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.polar.services.wallpapers;
in
{
  ###### interface
  options = {

    polar.services.wallpapers = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable wallpapers";
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    home.file = {
      ".config/wallpapers".source = ../../../wallpapers;
    };

    home.packages = with pkgs; [
      feh
    ];
  };
}
