_: {
  config,
  lib,
  ...
}: let
  cfg = config.programs.direnv;
in {
  config = lib.mkIf cfg.enable {
    programs.direnv.nix-direnv.enable = true;
  };
}
