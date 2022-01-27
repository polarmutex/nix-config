{ pkgs, config, lib, ... }:
with lib;
let
  dot = path: "${config.home.homeDirectory}/repos/personal/nix-dotfiles/${path}";

  link = path:
    let
      fullpath = dot path;
    in
    config.lib.file.mkOutOfStoreSymlink fullpath;

  link-one = from: to: path:
    let
      paths = builtins.attrNames { "${path}" = "directory"; };
      mkPath = path:
        let
          orig = "${from}/${path}";
        in
        {
          name = "${to}/${path}";
          value = {
            source = link orig;
          };
        };
    in
    builtins.listToAttrs (
      map mkPath paths
    );

  name = "Brian Ryall";

  cfg = config.polar.programs.neomutt;
in
{
  ###### interface
  options = {

    polar.programs.neomutt = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable neomutt";
      };
    };
  };

  ###### implementation
  config = mkIf cfg.enable {

    accounts.email = {
      maildirBasePath = "/home/polar/Mail";
      accounts = {
        protonmail = {
          address = "brian@brianryall.xyz";
          userName = "brian@brianryall.xyz";
          passwordCommand = "cat /var/run/secrets/protonmail_pw";
          primary = true;
          realName = "${name}";
          neomutt.enable = true;
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
          mbsync = {
            enable = true;
            create = "maildir";
          };
          notmuch.enable = true;
        };
      };
    };

    programs = {
      neomutt = {
        enable = true;
        vimKeys = true;
        sidebar = {
          enable = true;
        };
        extraConfig = ''
        '';
      };
      mbsync.enable = true;
      notmuch = {
        enable = true;
      };
    };

    home.packages = with pkgs; [
      protonmail-bridge
    ];

    #xdg.configFile = link-one "config" "." "nvim";

  };
}
