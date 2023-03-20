{...}: {
  config,
  lib,
  ...
}: let
  cfg = config.profiles.openssh;
in {
  options.profiles.openssh = {
    enable = lib.mkEnableOption "enable openssh";
  };
  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings.PermitRootLogin = lib.mkDefault "no";
    };
  };
}
