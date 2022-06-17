{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.polar.programs.firefox;
  # ~/.mozilla/firefox/PROFILE_NAME/prefs.js | user.js
  # https://www.youtube.com/watch?v=F7-bW2y6lcI
  sharedSettings = {
    /* 0101: disable default browser check
      * [SETTING] General>Startup>Always check if Firefox is your default browser ***/
    "browser.shell.checkDefaultBrowser" = false;
    /* 0102: set startup page [SETUP-CHROME]
      * 0=blank, 1=home, 2=last visited page, 3=resume previous session
      * [NOTE] Session Restore is cleared with history (2811, 2812), and not used in Private Browsing mode
      * [SETTING] General>Startup>Restore previous session ***/
    "browser.startup.page" = 3;
    /* 0103: set HOME+NEWWINDOW page
      * about:home=Activity Stream (default, see 0105), custom URL, about:blank
      * [SETTING] Home>New Windows and Tabs>Homepage and new windows ***/
    "browser.startup.homepage" = "https://nixos.org";
    /* 0104: set NEWTAB page
      * true=Activity Stream (default, see 0105), false=blank page
      * [SETTING] Home>New Windows and Tabs>New tabs ***/
    "browser.newtabpage.enabled" = false;
    "browser.newtab.preload" = false;
    /* 0105: disable some Activity Stream items
      * Activity Stream is the default homepage/newtab based on metadata and browsing behavior
      * [SETTING] Home>Firefox Home Content>...  to show/hide what you want ***/
    "browser.newtabpage.activity-stream.feeds.telemetry" = false;
    "browser.newtabpage.activity-stream.telemetry" = false;
    "browser.newtabpage.activity-stream.feeds.snippets" = false; # [DEFAULT: false]
    "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
    "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
    "browser.newtabpage.activity-stream.showSponsored" = false;
    "browser.newtabpage.activity-stream.feeds.discoverystreamfeed" = false; # [FF66+]
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false; # [FF83+]
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false; # disable CFR [FF67+] [SETTING] General>Browsing>Recommend extensions as you browse
    "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false; # disable CFR [FF67+] [SETTING] General>Browsing>Recommend features as you browse
    /* 0106: clear default topsites
      * [NOTE] This does not block you from adding your own ***/
    "browser.newtabpage.activity-stream.default.sites" = "";

    /*** [SECTION 0200]: GEOLOCATION / LANGUAGE / LOCALE ***/

    /*** [SECTION 0300]: QUIETER FOX ***/
    /* 0330: disable new data submission [FF41+]
      * If disabled, no policy is shown or upload takes place, ever
      * [1] https://bugzilla.mozilla.org/1195552 ***/
    "datareporting.policy.dataSubmissionEnabled" = false;
    /* 0331: disable Health Reports
      * [SETTING] Privacy & Security>Firefox Data Collection & Use>Allow Firefox to send technical... data ***/
    "datareporting.healthreport.uploadEnabled" = false;
    /* 0340: disable Studies
      * [SETTING] Privacy & Security>Firefox Data Collection & Use>Allow Firefox to install and run studies ***/
    "app.shield.optoutstudies.enabled" = false;

    /*** [SECTION 0400]: SAFE BROWSING (SB)
      SB has taken many steps to preserve privacy. If required, a full url is never sent
      to Google, only a part-hash of the prefix, hidden with noise of other real part-hashes.
      Firefox takes measures such as stripping out identifying parameters and since SBv4 (FF57+)
      doesn't even use cookies. (#Turn on browser.safebrowsing.debug to monitor this activity)
      [1] https://feeding.cloud.geek.nz/posts/how-safe-browsing-works-in-firefox/
      [2] https://wiki.mozilla.org/Security/Safe_Browsing
      [3] https://support.mozilla.org/kb/how-does-phishing-and-malware-protection-work
      ***/
    /*** [SECTION 0600]: BLOCK IMPLICIT OUTBOUND [not explicitly asked for - e.g. clicked on] ***/
    /*** [SECTION 0700]: DNS / DoH / PROXY / SOCKS / IPv6 ***/

    /*** [SECTION 0800]: LOCATION BAR / SEARCH BAR / SUGGESTIONS / HISTORY / FORMS ***/
    /* 0807: disable location bar contextual suggestions [FF92+]
      * [SETTING] Privacy & Security>Address Bar>Suggestions from...
      * [1] https://blog.mozilla.org/data/2021/09/15/data-and-firefox-suggest/ ***/
    "browser.urlbar.suggest.quicksuggest.nonsponsored" = false; # [FF95+]
    "browser.urlbar.suggest.quicksuggest.sponsored" = false;

    /*** [SECTION 0900]: PASSWORDS
      [1] https://support.mozilla.org/kb/use-primary-password-protect-stored-logins-and-pas
      ***/
    /*** [SECTION 1000]: DISK AVOIDANCE ***/
    /*** [SECTION 1200]: HTTPS (SSL/TLS / OCSP / CERTS / HPKP)
      Your cipher and other settings can be used in server side fingerprinting
      [TEST] https://www.ssllabs.com/ssltest/viewMyClient.html
      [TEST] https://browserleaks.com/ssl
      [TEST] https://ja3er.com/
      [1] https://www.securityartwork.es/2017/02/02/tls-client-fingerprinting-with-bro/
      ***/
    /*** [SECTION 1400]: FONTS ***/
    /*** [SECTION 1600]: HEADERS / REFERERS
      full URI: https://example.com:8888/foo/bar.html?id=1234
      scheme+host+port+path: https://example.com:8888/foo/bar.html
      scheme+host+port: https://example.com:8888
      [1] https://feeding.cloud.geek.nz/posts/tweaking-referrer-for-privacy-in-firefox/
      ***/
    /*** [SECTION 1700]: CONTAINERS ***/
    /*** [SECTION 2000]: PLUGINS / MEDIA / WEBRTC ***/
    /*** [SECTION 2400]: DOM (DOCUMENT OBJECT MODEL) ***/
    /*** [SECTION 2600]: MISCELLANEOUS ***/

    /*** [SECTION 2700]: ETP (ENHANCED TRACKING PROTECTION) ***/
    /* 2701: enable ETP Strict Mode [FF86+]
      * ETP Strict Mode enables Total Cookie Protection (TCP)
      * [NOTE] Adding site exceptions disables all ETP protections for that site and increases the risk of
      * cross-site state tracking e.g. exceptions for SiteA and SiteB means PartyC on both sites is shared
      * [1] https://blog.mozilla.org/security/2021/02/23/total-cookie-protection/
      * [SETTING] to add site exceptions: Urlbar>ETP Shield
      * [SETTING] to manage site exceptions: Options>Privacy & Security>Enhanced Tracking Protection>Manage Exceptions ***/
    "browser.contentblocking.category" = "strict";

    /*** [SECTION 2800]: SHUTDOWN & SANITIZING ***/
    /* 2801: delete cookies and site data on exit
      * 0=keep until they expire (default), 2=keep until you close Firefox
      * [NOTE] A "cookie" block permission also controls localStorage/sessionStorage, indexedDB,
      * sharedWorkers and serviceWorkers. serviceWorkers require an "Allow" permission
      * [SETTING] Privacy & Security>Cookies and Site Data>Delete cookies and site data when Firefox is closed
      * [SETTING] to add site exceptions: Ctrl+I>Permissions>Cookies>Allow
      * [SETTING] to manage site exceptions: Options>Privacy & Security>Permissions>Settings ***/
    "network.cookie.lifetimePolicy" = 2;

    /*** [SECTION 4500]: RFP (RESIST FINGERPRINTING)
      RFP covers a wide range of ongoing fingerprinting solutions.
      It is an all-or-nothing buy in: you cannot pick and choose what parts you want
      [WARNING] DO NOT USE extensions to alter RFP protected metrics
      418986 - limit window.screen & CSS media queries (FF41)
      [TEST] https://arkenfox.github.io/TZP/tzp.html#screen
      1281949 - spoof screen orientation (FF50)
      1281963 - hide the contents of navigator.plugins and navigator.mimeTypes (FF50-99)
      FF53: fixes GetSupportedNames in nsMimeTypeArray and nsPluginArray (1324044)
      1330890 - spoof timezone as UTC0 (FF55)
      1360039 - spoof navigator.hardwareConcurrency as 2 (FF55)
      1217238 - reduce precision of time exposed by javascript (FF55)
      FF56
      1369303 - spoof/disable performance API
      1333651 - spoof User Agent & Navigator API
      version: spoofed as ESR (FF102+ this is limited to Android)
      OS: JS spoofed as Windows 10, OS 10.15, Android 10, or Linux | HTTP Headers spoofed as Windows or Android
      1369319 - disable device sensor API
      1369357 - disable site specific zoom
      1337161 - hide gamepads from content
      1372072 - spoof network information API as "unknown" when dom.netinfo.enabled = true
      1333641 - reduce fingerprinting in WebSpeech API
      FF57
      1369309 - spoof media statistics
      1382499 - reduce screen co-ordinate fingerprinting in Touch API
      1217290 & 1409677 - enable some fingerprinting resistance for WebGL
      1382545 - reduce fingerprinting in Animation API
      1354633 - limit MediaError.message to a whitelist
      FF58-90
      967895 - spoof canvas and enable site permission prompt (FF58)
      1372073 - spoof/block fingerprinting in MediaDevices API (FF59)
      Spoof: enumerate devices as one "Internal Camera" and one "Internal Microphone"
      Block: suppresses the ondevicechange event
      1039069 - warn when language prefs are not set to "en*" (also see 0210, 0211) (FF59)
      1222285 & 1433592 - spoof keyboard events and suppress keyboard modifier events (FF59)
      Spoofing mimics the content language of the document. Currently it only supports en-US.
      Modifier events suppressed are SHIFT and both ALT keys. Chrome is not affected.
      1337157 - disable WebGL debug renderer info (FF60)
      1459089 - disable OS locale in HTTP Accept-Language headers (ANDROID) (FF62)
      1479239 - return "no-preference" with prefers-reduced-motion (FF63)
      1363508 - spoof/suppress Pointer Events (FF64)
      1492766 - spoof pointerEvent.pointerid (FF65)
      1485266 - disable exposure of system colors to CSS or canvas (FF67)
      1494034 - return "light" with prefers-color-scheme (FF67)
      1564422 - spoof audioContext outputLatency (FF70)
      1595823 - return audioContext sampleRate as 44100 (FF72)
      1607316 - spoof pointer as coarse and hover as none (ANDROID) (FF74)
      1621433 - randomize canvas (previously FF58+ returned an all-white canvas) (FF78)
      1653987 - limit font visibility to bundled and "Base Fonts" (Windows, Mac, some Linux) (FF80)
      1461454 - spoof smooth=true and powerEfficient=false for supported media in MediaCapabilities (FF82)
      FF91+
      531915 - use fdlibm's sin, cos and tan in jsmath (FF93, ESR91.1)
      1756280 - enforce navigator.pdfViewerEnabled as true and plugins/mimeTypes as hard-coded values (FF100)
      ***/
    /*** [SECTION 5000]: OPTIONAL OPSEC
      Disk avoidance, application data isolation, eyeballs...
      ***/
    /* 5010: disable location bar suggestion types
      * [SETTING] Privacy & Security>Address Bar>When using the address bar, suggest ***/
    "browser.urlbar.suggest.history" = false;
    "browser.urlbar.suggest.bookmark" = false;
    "browser.urlbar.suggest.openpage" = false;
    "browser.urlbar.suggest.topsites" = false; # [FF78+]

    /*** [SECTION 5500]: OPTIONAL HARDENING
      Not recommended. Overriding these can cause breakage and performance issues,
      they are mostly fingerprintable, and the threat model is practically nonexistent
      ***/
    /*** [SECTION 5500]: OPTIONAL HARDENING
      Not recommended. Overriding these can cause breakage and performance issues,
      they are mostly fingerprintable, and the threat model is practically nonexistent
      ***/

    /*** [SECTION 7000]: DON'T BOTHER ***/
    /* 7015: enable the DNT (Do Not Track) HTTP header
      * [WHY] DNT is enforced with Tracking Protection which is used in ETP Strict (2701) ***/
    "privacy.donottrackheader.enabled" = true; #TODO

    /*** [SECTION 8000]: DON'T BOTHER: FINGERPRINTING
      [WHY] They are insufficient to help anti-fingerprinting and do more harm than good
      [WARNING] DO NOT USE with RFP. RFP already covers these and they can interfere
      ***/

    /*** [SECTION 9000]: PERSONAL
      Non-project related but useful. If any interest you, add them to your overrides
      ***/
    "ui.systemUsesDarkTheme" = 1;
    # disable updates (pretty pointless with nix)
    "app.update.channel" = "default";
    "extensions.update.enabled" = false;
    # Yubikey
    "security.webauth.u2f" = true;
    "security.webauth.webauthn" = true;
    "security.webauth.webauthn_enable_softtoken" = true;
    "security.webauth.webauthn_enable_usbtoken" = true;
    "browser.urlbar.placeholderName" = "DuckDuckGo";
    "browser.search.defaultenginename" = "DuckDuckGo";
    "font.name.serif.x-western" = "MonoLisa Nerd Font";


    # TODO Enable DNS over HTTPS
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
        vimium
        ublock-origin
        multi-account-containers
        # smart-referer
        skip-redirect
        canvasblocker

        #darkreader
        # auto-accepts cookies, use only with privacy-badger & ublock-origin
        i-dont-care-about-cookies
        languagetool
        link-cleaner
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

