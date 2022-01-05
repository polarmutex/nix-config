{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.polar.defaults.locale;
in
{

  options.polar.defaults.locale = {
    enable = mkEnableOption "Locale defaults";
  };

  config = mkIf cfg.enable {

    # Set localization and tty options
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };

    # Set the timezone
    time.timeZone = "America/New_York";
  };
}
