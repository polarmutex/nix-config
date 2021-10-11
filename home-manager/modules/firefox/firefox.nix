{ pkgs, config, lib, ... }:
{
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
}

