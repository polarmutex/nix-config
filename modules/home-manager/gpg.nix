{pkgs, ...}: {
  services.gpg-agent = {
    enable = true;
    enableExtraSocket = true;
    enableScDaemon = true;
    enableSshSupport = true;
    defaultCacheTtl = 34560000;
    maxCacheTtl = 34560000;
    grabKeyboardAndMouse = false;
    pinentry.package = pkgs.pinentry-curses;
    #extraConfig = ''
    #  extra-socket /run/user/${toString config.home.uid}/gnupg/S.gpg-agent.extra
    #'';
  };

  programs.gpg = let
    keyid = "0x7F1160FAFC739341";
  in {
    publicKeys = [
      {
        source = ./. + "/gpg-${keyid}-2022-01-20.asc";
        trust = 5;
      }
    ];
    # Default/trusted key ID to use (helpful with throw-keyids)
    settings = {
      default-key = keyid;
      trusted-key = keyid;
      # https://github.com/drduh/config/blob/master/gpg.conf
      # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html
      # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Esoteric-Options.html
      # Use AES256, 192, or 128 as cipher
      personal-cipher-preferences = "AES256 AES192 AES";
      # Use SHA512, 384, or 256 as digest
      personal-digest-preferences = "SHA512 SHA384 SHA256";
      # Use ZLIB, BZIP2, ZIP, or no compression
      personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
      # Default preferences for new keys
      default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
      # SHA512 as digest to sign keys
      cert-digest-algo = "SHA512";
      # SHA512 as digest for symmetric ops
      s2k-digest-algo = "SHA512";
      # AES256 as cipher for symmetric ops
      s2k-cipher-algo = "AES256";
      # UTF-8 support for compatibility
      charset = "utf-8";
      # Show Unix timestamps
      fixed-list-mode = "";
      # No comments in signature
      no-comments = "";
      # No version in signature
      no-emit-version = "";
      # Disable banner
      no-greeting = "";
      # Long hexidecimal key format
      keyid-format = "0xlong";
      # Display UID validity
      list-options = "show-uid-validity";
      verify-options = "show-uid-validity";
      # Display all keys and their fingerprints
      with-fingerprint = "";
      # Cross-certify subkeys are present and valid
      require-cross-certification = "";
      # Disable caching of passphrase for symmetrical ops
      no-symkey-cache = "";
      # Enable smartcard
      use-agent = "";
    };
    scdaemonSettings = {
      disable-ccid = true;
      reader-port = "Yubico Yubi";
    };
  };
}
