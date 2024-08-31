{
  config,
  lib,
  pkgs,
  ...
}: let
  lieerAccounts = lib.filter (a: a.lieer.enable) (lib.attrValues config.accounts.email.accounts);
  lieerSyncAccounts = lib.filterAttrs (_: acc: acc.lieer.enable && acc.lieer.sync.enable) config.accounts.email.accounts;
in {
  accounts.email = {
    maildirBasePath = "${config.xdg.cacheHome}/mail";
    accounts.bryall = {
      address = "bryall@gmail.com";
      realName = "Brian Ryall";
      primary = true;
      flavor = "gmail.com";
      passwordCommand = "op items get Google-bryall --fields 'Passwd'";

      # Lieer syncs everything into a single box.
      # These should be overridden later with the virtual mailbox through
      # notmuch that uses tags to figure out what's what.
      folders = {
        inbox = "mail";
      };

      lieer = {
        enable = true;
        sync.enable = true;
        sync.frequency = "*:0/5"; # Every 5 minutes
        settings = {
          drop_non_existing_label = true;
          ignore_remote_labels = [];
          ignore_tags = ["bryall" "theryalls"];
        };
      };
      neomutt = {
        enable = true;
        mailboxName = "bryall";
        extraConfig = ''
          unmailboxes *
        '';
      };
      notmuch = {
        enable = true;
        neomutt = {
          enable = true;
          virtualMailboxes = [
            {
              name = "Inbox";
              query = "path:/bryall/ AND ((tag:inbox -tag:promotions -tag:social) OR (tag:inbox and tag:flagged))";
            }
            {
              name = "Archive";
              query = "path:/bryall/ AND (NOT tag:inbox AND NOT tag:spam)";
            }
            {
              name = "Personal";
              query = "path:/bryall/ AND tag:personal";
            }
            {
              name = "Flagged";
              query = "path:/bryall/ AND tag:flagged";
            }
            {
              name = "Promotions";
              query = "path:/bryall/ AND tag:promotions";
            }
            {
              name = "Social";
              query = "path:/bryall/ AND tag:social";
            }
            {
              name = "Sent";
              query = "path:/bryall/ AND tag:sent";
            }
          ];
        };
      };
    };
    accounts.theryalls = {
      address = "theryalls@gmail.com";
      realName = "The Ryall";
      primary = false;
      flavor = "gmail.com";
      passwordCommand = "op items get Google-theryalls --fields 'password'";

      # Lieer syncs everything into a single box.
      # These should be overridden later with the virtual mailbox through
      # notmuch that uses tags to figure out what's what.
      folders = {
        inbox = "mail";
      };

      lieer = {
        enable = false;
        sync.enable = true;
        sync.frequency = "*:0/5"; # Every 5 minutes
        settings = {
          drop_non_existing_label = true;
          ignore_remote_labels = [];
          ignore_tags = ["bryall" "theryalls"];
        };
      };
      neomutt = {
        enable = true;
        mailboxName = "theryalls";
        extraConfig = ''
          unmailboxes *
        '';
      };
      notmuch = {
        enable = true;
        neomutt = {
          enable = true;
          virtualMailboxes = [
            {
              name = "Inbox";
              query = "path:/theryalls/ AND ((tag:inbox -tag:promotions -tag:social) OR (tag:inbox and tag:flagged))";
            }
            {
              name = "Archive";
              query = "path:/theryalls/ AND (NOT tag:inbox AND NOT tag:spam)";
            }
            {
              name = "Personal";
              query = "path:/theryalls/ AND tag:personal";
            }
            {
              name = "Flagged";
              query = "path:/theryalls/ AND tag:flagged";
            }
            {
              name = "Promotions";
              query = "path:/theryalls/ AND tag:promotions";
            }
            {
              name = "Social";
              query = "path:/theryalls/ AND tag:social";
            }
            {
              name = "Sent";
              query = "path:/theryalls/ AND tag:sent";
            }
          ];
        };
      };
    };
  };

  programs = {
    # Enable lieer, for syncing GMail via tags rather than folders, which is
    # necessary without token authentication, since lieer is one of the few
    # terminal syncing things that can do the OAUTH2 authentication GMail requires
    # if you're not using an application-specific token.
    lieer.enable = true;

    notmuch.enable = true;

    neomutt = {
      # Enable neomutt.
      enable = true;

      # Check for new mail every two minutes.
      checkStatsInterval = 120;

      # Additional neomutt configuration.
      extraConfig =
        #let
        # A script to find all mailboxes and make mutt entries for them
        # dynamically.
        # findAllMailboxes = let
        #   # A script to take the paths to mail directories and turn them into
        #   # mailbox-name mailbox-path pairs for mutt.
        #   mkMailboxDescription = pkgs.writeScript "mailbox-description.pl" ''
        #     #!${pkgs.perl}/bin/perl
        #
        #     BEGIN {
        #       $basepath = q{${config.accounts.email.maildirBasePath}/}
        #     }
        #
        #     while (<>) {
        #       chomp;
        #
        #       $boxname = s/\Q$basepath\E//r;
        #       print "\"$boxname\" ";
        #       print "\"$_\" ";
        #     }
        #   '';
        # in
        #   pkgs.writeScript "find-mailboxes.sh" ''
        #     #!${pkgs.stdenv.shell}
        #
        #     ${pkgs.findutils}/bin/find \
        #           "${config.accounts.email.maildirBasePath}" \
        #           -type d \
        #           \( -name cur -o -name new \) \
        #           \( \! -empty \) \
        #           -printf '%h\n' \
        #       | ${pkgs.coreutils}/bin/sort \
        #       | ${pkgs.coreutils}/bin/uniq \
        #       | ${mkMailboxDescription}
        #   '';
        #in
        ''
           # Only show the basic mail headers.
           ignore *
           unignore From To Cc Bcc Date Subject

           # Show headers in the following order.
           unhdr_order *
           hdr_order From: To: Cc: Bcc: Date: Subject:

           # Find all mailboxes dynamically.
           # named-mailboxes `{findAllMailboxes}`

           # Personally, I like to see the relative age (yesterday, Saturday or a date if it’s a long time ago):
           set index_format='%4C %Z %<[y?%<[m?%<[d?%[%l:%M%p ]&%[%a %d ]>&%[%b %d ]>&%[%m/%y ]> %-15.15L %s %g'

          folder-hook !notmuch '                \
          unmacro index,pager d;                \
          bind    index,pager d delete-message'

           folder-hook notmuch '                 \
           unbind index,pager d;                 \
           macro index,pager d                   \
           "<modify-tags-then-hide>-unread -inbox -spam +trash<enter><sync-mailbox><check-stats>" \
           "Move message to trash"'
        '';
      # Neomutt settings.
      settings = {
        # If the given mail doesn't have an explicit charset, assume an old,
        # Windows-y compatible charset as fallback.
        assumed_charset = "iso-8859-1";

        # Ask to purge messages marked for delete when closing/syncing a box, with
        # the default to do so.
        delete = "ask-yes";

        # When editing outgoing mail, allow editing the headers too.
        edit_headers = "yes";

        # The format to use for subjects when forwarding messages.
        forward_format = "\"Fwd: %s\"";

        # Send all mail as UTF-8.
        send_charset = "utf-8";

        # Sort the mailboxes in the sidebar by mailbox path.
        sidebar_sort_method = "path";

        # Sort by reverse last message date if messages are in the same thread.
        sort_aux = "reverse-last-date-received";

        # Only group messages as a thread by the In-Reply-To or References headers,
        # rather than matching subject names.
        strict_threads = "yes";

        # Search messages against their decoded contents.
        thorough_search = "yes";
      };

      binds = [
        {
          action = "noop";
          key = "i";
          map = ["index" "pager"];
        }
      ];

      macros = [
        {
          action = "<sync-mailbox><enter-command>source ~/.config/neomutt/bryall<enter><change-folder>!<enter>";
          key = "<f2>";
          map = ["index" "pager"];
        }
        {
          action = "<sync-mailbox><enter-command>source ~/.config/neomutt/theryalls<enter><change-folder>!<enter>";
          key = "<f3>";
          map = ["index" "pager"];
        }
      ];

      sidebar = {
        # Enable the sidebar.
        enable = true;

        # The format to use for the sidebar.
        format = "%D%?F? [%F]?%* %?N?%N/?%S";

        # Make the sidebar 56 characters wide.
        width = 56;
      };

      # Sort messages by thread.
      sort = "threads";

      # Use vim-like keybindings in neomutt.
      vimKeys = true;
    };
  };

  # Enable syncing lieer accounts.
  services.lieer.enable = true;

  # Extra packages to install.
  home.packages = with pkgs; [
    # A utility for extracting URLs from text.
    extract_url
  ];
  home.activation = lib.mkIf (lieerAccounts != []) {
    createLieerMaildir = lib.hm.dag.entryBetween ["linkGeneration"] ["writeBoundary"] ''
      $DRY_RUN_CMD mkdir -m700 -p $VERBOSE_ARG ${
        lib.concatMapStringsSep " "
        (a: "${a.maildir.absPath}/mail/{cur,new,tmp}")
        lieerAccounts
      }
    '';
  };
}
