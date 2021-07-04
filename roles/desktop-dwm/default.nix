{ pkgs, config, lib, ...}:
{
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # TODO autorandr

nixpkgs.overlays = [
    (self: super: {
      dwm = super.dwm.overrideAttrs(_: {
        src = builtins.fetchGit {
          url = "https://github.com/polarmutex/dwm";
          rev = "f9e8c451445dc9dcf3408397c0a9d3324c2941f6";
          ref = "custom";
        };
      });
      st = super.st.overrideAttrs( oldAttrs : rec {
        src = builtins.fetchGit {
          url = "https://github.com/polarmutex/st";
          rev = "8684c90a1d5a15491a52d763c5625c3479887df7";
          ref = "custom";
        };
        buildInputs = oldAttrs.buildInputs ++ [ pkgs.harfbuzz.dev ];
      });
      dmenu = super.dmenu.overrideAttrs( oldAttrs : rec {
        src = builtins.fetchGit {
          url = "https://github.com/polarmutex/dmenu";
          rev = "1e6783bc0bba32d402f6185e23702055b7bf0acf";
          ref = "custom";
        };
      });
    })
  ];

  services.xserver.windowManager.dwm.enable = true;
  services.xserver = {
    displayManager = {
      defaultSession = "none+dwm";
      gdm.enable = true;
    };
  };

  services.gnome.gnome-keyring.enable = true;
  services.accounts-daemon.enable = true;
  environment.pathsToLink = [ "/share/accountsservices" ];
}
