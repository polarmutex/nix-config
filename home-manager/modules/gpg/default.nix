{ pkgs, config, lib, ... }:
with lib;
{

  home.packages = with pkgs; [
    pass
    pinentry-gtk2
  ];

  home.file.".gnupg/public.key".source = ./public.key;
  home.file.".ssh/authorized_keys".source = ./authorized_keys;
  home.file.".gnupg/gpg.conf".source = ./gpg.conf;
  home.file.".gnupg/gpg_agent.conf".text = ''
    enable-ssh-support
    default-cache-ttl 60
    max-cache-ttl 60
    pinentry-program /home/polar/.nix-profile/bin/pinentry-gtk-2
  '';

  programs.zsh.initExtraBeforeCompInit = ''
    export GPG_TTY=$(tty)
    export GPG_KEY_ID=0x7F1160FAFC739341
    gpg-connect-agent updatestartuptty /bye > /dev/null
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    reset-gpg() {
      export GPG_TTY=$(tty)
      killall gpg-agent
      rm -r ~/.gnupg/private-keys-v1.d
      gpg-connect-agent updatestartuptty /bye
      gpg-connect-agent "learn --force" /bye
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    }
  '';

  home.activation.gpgtrust = hm.dag.entryAfter [ "LinkGeneration" ] ''
    gpg --import ~/.gnupg/public.key
  '';
}
