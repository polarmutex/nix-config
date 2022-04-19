{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.polar.fonts;
in
{
  ###### interface
  options = {

    polar.fonts = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable fonts";
      };
    };
  };
  ###### implementation

  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    home.packages = [
      (pkgs.nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
    ];

    home.file.".local/share/fonts/MonoLisa-Regular-Nerd-Font-Complete.otf".source = ../../.secrets/MonoLisa-Regular-Nerd-Font-Complete.otf;
    home.file.".local/share/fonts/MonoLisa-Regular-Italic-Nerd-Font-Complete.otf".source = ../../.secrets/MonoLisa-Regular-Italic-Nerd-Font-Complete.otf;
    home.file.".local/share/fonts/MonoLisa-Bold-Nerd-Font-Complete.otf".source = ../../.secrets/MonoLisa-Bold-Nerd-Font-Complete.otf;
    home.file.".local/share/fonts/MonoLisa-Bold-Italic-Nerd-Font-Complete.otf".source = ../../.secrets/MonoLisa-Bold-Italic-Nerd-Font-Complete.otf;
  };
}
