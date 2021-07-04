{ pkgs, config, lib, ...}:
{
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # TODO autorandr

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    displayManager.session = [
      {
        manage = "desktop";
        name = "xsession";
        start = "exec $HOME/.xsession";
      }
    ];

    displayManager.defaultSession = "xsession";
    displayManager.job.logToJournal = true;
  };

  environment.systemPackages = with pkgs; [
  ];

  services.gnome.gnome-keyring.enable = true;
  services.accounts-daemon.enable = true;
}
