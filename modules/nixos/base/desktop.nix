{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.custom.base.desktop;
in

{

  ###### interface

  options = {

    custom.base.desktop = {
      enable = mkEnableOption "basic desktop config";

      enableXserver = mkEnableOption "xserver config" // { default = true; };

      laptop = mkEnableOption "services and config for battery, network, backlight";

      hidpi = mkEnableOption "hi dpi monitor" // { default = false; };
    };

  };


  ###### implementation

  config = mkIf cfg.enable (mkMerge [
    {

      boot = {
        # The default max inotify watches is 8192.
        # Nowadays most apps require a good number of inotify watches,
        # the value below is used by default on several other distros.
        kernel.sysctl."fs.inotify.max_user_watches" = 524288;

        tmpOnTmpfs = true;
      };

      environment.systemPackages = with pkgs; [
        exfat
        ntfs3g
        st
        dmenu
        arandr
      ];

      fonts = {
        enableDefaultFonts = true;
        enableGhostscriptFonts = true;
        fontDir.enable = true;

        fonts = with pkgs; [
          corefonts
          monolisa-font
          (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
        ];
      };


      services.blueman.enable = true;
      custom.services.openssh.enable = true;

      services.xserver = mkIf cfg.enableXserver {
        enable = true;

        displayManager.lightdm.enable = true;

        windowManager.dwm.enable = true;
      };

      # Enable sound.
      sound.enable = true;
      hardware.pulseaudio = {
        enable = true;
        package = pkgs.pulseaudioFull;
        extraModules = [ pkgs.pulseaudio-modules-bt ];
        extraConfig = ''
          load-module module-switch-on-connect
        '';
      };

      hardware.bluetooth.enable = true;

      xdg = {
        autostart.enable = true;
        icons.enable = true;
        menus.enable = true;
        mime.enable = true;
        sounds.enable = true;
      };
    }

    (mkIf cfg.laptop
      {
        hardware = {

          # for bluetooth support
          pulseaudio.package = pkgs.pulseaudioFull;
        };

        networking.networkmanager.enable = true;

        #programs.light.enable = true;

        services = {
          blueman.enable = true;

          upower.enable = true;

        };

        users.users.polar.extraGroups = [ "networkmanager" "video" ];
      }
    )

    (mkIf cfg.hidpi
      {
        hardware.video.hidpi.enable = lib.mkDefault true;
        services.xserver.dpi = 163;
      })

  ]);

}
