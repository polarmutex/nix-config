{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.polar.programs.firefox;
  # ~/.mozilla/firefox/PROFILE_NAME/prefs.js | user.js
  sharedSettings = {
    # disable updates (pretty pointless with nix)
    "app.update.channel" = "default";

    "browser.search.widget.inNavBar" = true;

    "browser.shell.checkDefaultBrowser" = false;
    "browser.startup.homepage" = "https://nixos.org";
    "browser.tabs.loadInBackground" = true;
    "browser.urlbar.placeholderName" = "DuckDuckGo";
    "browser.urlbar.showSearchSuggestionsFirst" = false;

    "distribution.searchplugins.defaultLocale" = "en-US";
    "general.useragent.locale" = "en-US";
    "extensions.update.enabled" = false;

    "privacy.donottrackheader.enabled" = true;

    # Yubikey
    "security.webauth.u2f" = true;
    "security.webauth.webauthn" = true;
    "security.webauth.webauthn_enable_softtoken" = true;
    "security.webauth.webauthn_enable_usbtoken" = true;

  };
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
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        onepassword-password-manager
        darkreader
        # auto-accepts cookies, use only with privacy-badger & ublock-origin
        i-dont-care-about-cookies
        languagetool
        link-cleaner
        privacy-badger
        ublock-origin
        vimium
      ];

      profiles = {
        default = {
          id = 0;
          settings = sharedSettings;
          #userChrome = disableWebRtcIndicator;
        };

      };
    };
  };
}

