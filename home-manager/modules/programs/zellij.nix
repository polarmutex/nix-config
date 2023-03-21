_: {
  config,
  lib,
  ...
}: let
  cfg = config.programs.zellij;
in {
  config = lib.mkIf cfg.enable {
    programs.zellij = {
      settings = {
        theme = "Tokyo Night";
      };
    };
  };
}
