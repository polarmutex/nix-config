{...}: {
  config,
  lib,
  ...
}: let
  cfg = config.profiles.mosh;
in {
  options.profiles.mosh = {
    enable = lib.mkEnableOption "enable mosh";
  };
  config = lib.mkIf cfg.enable {
    programs.mosh.enable = true;
  };
}
