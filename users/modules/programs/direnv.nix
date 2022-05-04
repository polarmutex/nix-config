{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.polar.programs.direnv;
in
{

  ###### interface
  options = {

    polar.programs.direnv = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable direnv";
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
  };

}
