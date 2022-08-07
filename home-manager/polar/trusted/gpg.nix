{ config, pkgs, lib, ... }:
{
  #services.gpg-agent = {
  #  enable = true;
  #  enableSshSupport = true;
  #  pinentryFlavor = "curses";
  #};

  programs.gpg = let
    keyid = "0x7F1160FAFC739341";
  in {
    enable = true;
    publicKeys = [
      {
        source = ./. + "/gpg-${keyid}-2022-01-20.asc";
        trust = 5;
      }
    ];
    settings = {
      # from: https://github.com/drduh/config/blob/master/gpg.conf
      personal-cipher-preferences = "AES256 AES192 AES";
      personal-digest-preferences = "SHA512 SHA384 SHA256";
      personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
      default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
      cert-digest-algo = "SHA512";
      s2k-digest-algo = "SHA512";
      s2k-cipher-algo = "AES256";
      charset = "utf-8";
      fixed-list-mode = true;
      no-comments = true;
      no-emit-version = true;
      no-greeting = true;
      keyid-format = "0xlong";
      list-options = "show-uid-validity";
      verify-options = "show-uid-validity";
      with-fingerprint = true;
      require-cross-certification = true;
      no-symkey-cache = true;
      use-agent = true;
      throw-keyids = true;
      default-key = keyid;
      trusted-key = keyid;
      keyserver = "hkps://keys.openpgp.org";
    };
  };
}
