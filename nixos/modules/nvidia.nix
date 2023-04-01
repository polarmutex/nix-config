_: {
  config,
  lib,
  ...
}: let
  cfg = config.profiles.nvidia;
in {
  options.profiles.nvidia = {
    enable = lib.mkEnableOption "enable nvidia";
  };
  config = lib.mkIf cfg.enable {
    boot.blacklistedKernelModules = ["nouveau"];

    services.xserver.videoDrivers = ["nvidia"];

    #virtualisation.docker.enableNvidia = true;
    #virtualisation.podman.enableNvidia = true;
  };
}
