{pkgs, ...}: let
  realName = "Brian Ryall";
  #gpg = {
  #  key = "789B 8E4F 0588 6159 46E4  B83A 7F11 60FA FC73 9341";
  #  signByDefault = true;
  #};
  #signature = {
  #  showSignature = "append";
  #  text = ''
  #    ${realName}
  #    https://misterio.me
  #    PGP: ${gpg.key}
  #  '';
  #};

  proton = {
    primary = true;
    address = "brian@brianryall.xyz";
    aliases = [];
    inherit realName;
    userName = "bryall@proton.me";
    mbsync = {
      enable = true;
      create = "maildir";
      expunge = "both";
      patterns = ["INBOX" "Sent" "Drafts" "Spam" "Archive" "Trash"]; #"Labels/*"
      #extraConfig.channel = {
      #  MaxMessages = 2000;
      #  ExpireUnread = "yes";
      #};
    };
    imap = {
      host = "127.0.0.1";
      port = 1143;
      tls = {
        enable = true;
        useStartTls = true;
        certificatesFile = "/home/polar/.config/protonmail/bridge/cert.pem";
      };
    };
    smtp = {
      host = "127.0.0.1";
      port = 1025;
      tls = {
        enable = true;
        useStartTls = true;
        certificatesFile = "/home/polar/.config/protonmail/bridge/cert.pem";
      };
    };
    passwordCommand = "${pkgs.pass}/bin/pass show proton-bridge";
    #neomutt.enable = true;
  };
in {
  accounts.email = {
    maildirBasePath = "mail";
    accounts = {
      inherit proton;
    };
  };

  program = {
    password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [exts.pass-otp]);
    };
    mbsync = {
      enable = true;
    };
    neomutt = {
    };
  };

  #services.mbsync = {
  #  enable = true; # disabled because it kept asking for my password
  #  verbose = true; # to help debug problems in journalctl
  #  frequency = "*:0/5";
  #  # TODO add a echo for the log
  #  postExec = "${pkgs.notmuch}/bin/notmuch new";
  #};
  #systemd.user.services.mbsync = {
  #  Service = {
  #    # TODO need DBUS_SESSION_BUS_ADDRESS
  #    FailureAction = ''${pkgs.libnotify}/bin/notify-send --app-name="%N" "Failure"'';
  #  };
  #};

  #programs.msmtp.enable = true;
  #programs.notmuch = {
  #  enable = true;
  #  hooks.preNew = "${pkgs.isync}/bin/mbsync -a";
  #};
  #programs.alot = {
  #  enable = true;
  #};

  home.packages = with pkgs; [
    #protonmail-bridge
    thunderbird
    mutt-wizard
    notmuch
    afew
    lynx
  ];

  systemd.user.services."proton-bridge" = {
    Unit.Description = "Bridge to ProtonMail";
    Install.WantedBy = ["default.target" "mbsync.service"];
    Service.ExecStart = "${pkgs.protonmail-bridge}/bin/protonmail-bridge --noninteractive";
    Service.Environment = "PATH=${pkgs.pass}/bin";
  };
}
