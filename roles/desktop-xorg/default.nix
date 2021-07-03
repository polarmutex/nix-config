{ pkgs, config, lib, ...}:
{
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # TODO autorandr

  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    displayManager.session = [
      {
        manage = "desktop";
        name = "xsession";
        start = "exec $HOME/.xsession";
      }
    ];

    displayManager.defaultSession = "xsession";
    displayManager.job.logToJournal = true;
    libinput.enable = true;
  };

  environment.systemPackages = with pkgs; [
    lightdm
  ];

  services.gnome.gnome-keyring.enable = true;
  services.account-daemon.enable = true;
  environment.pathToLink = [ "/share/accountsservices" ];
}
