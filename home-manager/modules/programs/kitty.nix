_: {
  config,
  lib,
  ...
}: let
  cfg = config.programs.kitty;
in {
  options.programs.kitty = {
    textSize = lib.mkOption {
      type = lib.types.number;
      default = 11;
    };
  };
  config = lib.mkIf cfg.enable {
    #home.sessionVariables.TERMINAL = "kitty";

    programs.kitty = {
      font = {
        name = "MonoLisa Custom";
      };
      settings = {
      };
    };
  };
}
