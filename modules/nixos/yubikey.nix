{pkgs, ...}: {
  services.udev.packages = with pkgs; [yubikey-personalization];
  services.pcscd.enable = true;

  # # Needed for yubikey to work
  # # from nixos wiki
  # environment.shellInit = ''
  #   export GPG_TTY="$(tty)"
  #   gpg-connect-agent /bye
  #   export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
  # '';

  # # for yubikey logins
  # security.pam.yubico = {
  #   enable = true;
  #   debug = true;
  #   mode = "challenge-response";
  # };

  # security.pam.services.sudo.yubicoAuth = true;

  environment.systemPackages = with pkgs; [
    pcsc-tools
    # yubikey-manager
  ];

  # try to enable gnupg's udev rules
  # to allow it to do ccid stuffs
  hardware.gpgSmartcards.enable = true;
}
