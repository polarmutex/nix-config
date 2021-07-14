{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    gnupg
    yubikey-personalization
    yubioath-desktop
    pinentry-gtk2
  ];

  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;

  environment.shellInit = ''
    export GPG_TTY="$(tty)"
    gpg-connect-agent /bye
  '';

  programs = {
    gnupg.agent = {
      enable = true;
      pinentryFlavor = "gtk2";
    };
  };
}
