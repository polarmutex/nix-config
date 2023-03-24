_: {
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  # ~/.mozilla/firefox/PROFILE_NAME/prefs.js | user.js
  # https://www.youtube.com/watch?v=F7-bW2y6lcI
  sharedSettings = {
    "ui.systemUsesDarkTheme" = 1;
    "font.name.serif.x-western" = "MonoLisa Custom";

    # Firefox hardening using preferences (automated)
    "app.normandy.first_run" = false;
    "app.update.auto" = false;
    "browser.contentblocking.category" = "custom";
    "browser.download.useDownloadDir" = false;
    "browser.formfill.enable" = false;
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
    "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
    "browser.newtabpage.activity-stream.feeds.topsites" = false;
    "browser.search.suggest.enabled" = false;
    "browser.urlbar.placeholderName" = "DuckDuckGo";
    "datareporting.healthreport.uploadEnabled" = false;
    "doh-rollout.disable-heuristics" = true;
    "dom.forms.autocomplete.formautofill" = true;
    "dom.security.https_only_mode_ever_enabled" = true;
    "dom.security.https_only_mode" = true;
    "extensions.formautofill.addresses.enabled" = false;
    "extensions.formautofill.creditCards.enabled" = false;
    "extensions.pocket.enabled" = false;
    "identity.fxaccounts.enabled" = false;
    "layout.spellcheckDefault" = 1; # Used to disable spellchecker… set to `0` for increased privacy
    "network.cookie.cookieBehavior" = 1;
    "network.cookie.lifetimePolicy" = 2;
    "network.proxy.socks_remote_dns" = true;
    "network.trr.mode" = 5;
    "places.history.enabled" = false;
    "privacy.donottrackheader.enabled" = true;
    "privacy.history.custom" = true;
    "privacy.sanitize.sanitizeOnShutdown" = true;
    "privacy.trackingprotection.enabled" = true;
    "privacy.trackingprotection.socialtracking.enabled" = true;
    "signon.management.page.breach-alerts.enabled" = false;
    "signon.rememberSignons" = false;
    # Firefox hardening using about:config (arkenfox/user.js recommendations=automated)
    "accessibility.force_disabled" = 1;
    "app.normandy.api_url" = "";
    "app.normandy.enabled" = false;
    "app.shield.optoutstudies.enabled" = false;
    "beacon.enabled" = false;
    "browser.pagethumbnails.capturing_disabled" = true;
    "browser.ping-centre.telemetry" = false;
    "browser.places.speculativeConnect.enabled" = false;
    "browser.sessionstore.privacy_level" = 2;
    "browser.ssl_override_behavior" = 1;
    "browser.tabs.crashReporting.sendReport" = false;
    "browser.uitour.enabled" = false;
    "browser.uitour.url" = "";
    "browser.urlbar.speculativeConnect.enabled" = false;
    "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
    "browser.urlbar.suggest.quicksuggest.sponsored" = false;
    "browser.urlbar.trimURLs" = false;
    "browser.xul.error_pages.expert_bad_cert" = true;
    "captivedetect.canonicalURL" = "";
    "datareporting.policy.dataSubmissionEnabled" = false;
    "dom.security.https_only_mode_send_http_background_request" = false;
    "extensions.getAddons.showPane" = false;
    "extensions.htmlaboutaddons.recommendations.enabled" = false;
    "geo.provider.use_corelocation" = false;
    "network.auth.subresource-http-auth-allow" = 1;
    "network.captive-portal-service.enabled" = false;
    "network.connectivity-service.enabled" = false;
    "network.dns.disableIPv6" = true;
    "network.dns.disablePrefetch" = true;
    "network.http.speculative-parallel-limit" = 0;
    "network.predictor.enabled" = false;
    "network.prefetch-next" = false;
    "pdfjs.enableScripting" = false;
    "privacy.userContext.enabled" = true;
    "privacy.userContext.ui.enabled" = true;
    "security.cert_pinning.enforcement_level" = 2;
    "security.mixed_content.block_display_content" = true;
    "security.OCSP.require" = true;
    "security.pki.crlite_mode" = 2;
    "security.pki.sha1_enforcement_level" = 1;
    "security.remote_settings.crlite_filters.enabled" = true;
    "security.ssl.require_safe_negotiation" = true;
    "security.ssl.treat_unsafe_negotiation_as_broken" = true;
    "security.tls.enable_0rtt_data" = false;
    "toolkit.coverage.endpoint.base" = "";
    "toolkit.coverage.opt-out" = true;
    "toolkit.telemetry.coverage.opt-out" = true;
    # Firefox fingerprinting hardening using about:config (automated)
    "privacy.resistFingerprinting" = false; # Used to help resist fingerprinting but breaks dark mode and screenshots (among other features)… set to `true` for increased privacy
    "privacy.resistFingerprinting.block_mozAddonManager" = true;
    "privacy.resistFingerprinting.letterboxing" = true; # Used to help resist fingerprinting… set to `false` to disable letterboxing
    "webgl.disabled" = true;
  };
  cfg = config.programs.firefox;
in {
  config = lib.mkIf cfg.enable {
    programs.firefox = {
      package = pkgs.firefox.override {
        cfg = {
          smartcardSupport = true;
        };
      };

      profiles = {
        default = {
          id = 0;
          settings = sharedSettings;
          #userChrome = disableWebRtcIndicator;
          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            duckduckgo-privacy-essentials
            i-dont-care-about-cookies # auto-accepts cookies=use only with privacy-badger & ublock-origin
            #languagetool
            multi-account-containers
            onepassword-password-manager
            tree-style-tab # vertical tabs
            ublock-origin
            vimium
            privacy-badger
          ];
        };
      };
    };
  };
}
