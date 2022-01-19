{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.polar.programs.firefox;
in
{
  ###### interface
  options = {

    polar.programs.firefox = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable firefox.";
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox;
      profiles = {
        default = {
          name = "default";
          extraConfig = lib.fileContents ./user.js;
        };
      };
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        onepassword-password-manager
        ublock-origin
        darkreader
        privacy-badger
        languagetool
        xbrowsersync
      ];
    };
  };
}

