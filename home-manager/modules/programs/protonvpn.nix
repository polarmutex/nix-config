_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.protonvpn-cli;
in {
  options.programs.protonvpn-cli = {
    enable = lib.mkEnableOption "protonvpn-cli";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      protonvpn-cli
    ];
  };
}
