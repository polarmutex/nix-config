_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.profiles.bluetooth;
in {
  options.profiles.bluetooth = {
    enable = lib.mkEnableOption "enable bluetooth";
  };
  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      disabledPlugins = ["sap"];
      settings = {
        General = {
          FastConnectable = "true";
          JustWorksRepairing = "always";
          MultiProfile = "multiple";
        };
      };
    };

    services.blueman.enable = true;

    sound.enable = true;
    hardware.pulseaudio = {
      enable = true;
      package = pkgs.pulseaudio.override {bluetoothSupport = true;};
      extraConfig = ''
        load-module module-bluetooth-discover
        load-module module-bluetooth-policy
        load-module module-switch-on-connect
      '';
    };
  };
}
