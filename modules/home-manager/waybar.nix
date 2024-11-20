{pkgs, ...}: let
  waybar_config = let
    font = "MonoLisa";
    fontsize = "12";
    primary_accent = "cba6f7";
    secondary_accent = "89b4fa";
    tertiary_accent = "f5f5f5";
    background = "11111B";
    opacity = ".85";
    cursor = "Numix-Cursor";
  in {
    mainBar = {
      layer = "top";
      position = "left";
      width = 48;
      margin-top = 0;
      margin-bottom = 0;
      margin-left = 0;
      margin-right = 0;
      spacing = 0;
      gtk-layer-shell = true;
      modules-left = [
        "custom/notification"
        "bluetooth"
      ];
      modules-center = [
        "hyprland/workspaces"
        "hyprland/submap"
      ];
      modules-right = [
        "tray"
        "memory"
        "cpu"
        "clock"
      ];
      bluetooth = {
        format-disabled = "";
        format-off = "";
        format-on = "󰂯";
        format-connected = "󰂯";
        format-connected-battery = "󰂯";
        tooltip-format-connected = "{device_enumerate}";
        tooltip-format-enumerate-connected = "{device_alias} 󰂄{device_battery_percentage}% {device_address}";
        on-click = "blueman-manager";
        tooltip = true;
      };
      clock = {
        interval = 1;
        format = "󰥔\n{:%I\n%M\n%p}";
        # format-alt = "󰣆\n{:%d\n%m\n%y\n󰥔\n%I\n%M\n%p}";
        tooltip = true;
        # tooltip-format = "{calendar}";
        # calendar = {
        #   mode = "year";
        #   mode-mon-col = 3;
        #   format = {
        #     today = "<span color='#0dbc79'>{}</span>";
        #   };
      };
      "hyprland/submap" = {
        format = "{}";
        tooltip = false;
      };
      "hyprland/workspaces" = {
        disable-scroll = true;
        active-only = false;
        all-outputs = true;
        on-click = "activate";
        format = "{icon} - {name}";
        format-icons = {
          active = "";
          urgent = "";
          default = "";
          empty = "";
        };
        persistent-workspaces = {
          "*" = 8;
          #   "1" = [];
          #   "2" = [];
          #   "3" = [];
          #   "4" = [];
          #   "5" = [];
          #   "6" = [];
          #   "7" = [];
          #   "8" = [];
        };
      };
      memory = {
        format = "󰍛";
        format-alt = "󰍛 {used}/{total} GiB";
        tooltip = true;
        interval = 5;
      };
      cpu = {
        format = "󰻠";
        format-alt = "󰻠 {usage} %";
        interval = 5;
      };
      network = {
        format-wifi = "  {signalStrength}%";
        format-ethernet = "󰈀 100% ";
        tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
        format-linked = "{ifname} (No IP)";
        format-disconnected = "󰖪 0% ";
      };
      tray = {
        icon-size = 20;
        spacing = 8;
      };
      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = "󰝟";
        format-icons = {
          default = ["󰕿" "󰖀" "󰕾"];
        };
        # on-scroll-up= "bash ~/.scripts/volume up";
        # on-scroll-down= "bash ~/.scripts/volume down";
        scroll-step = 5;
        on-click = "pavucontrol";
      };
      "custom/randwall" = {
        format = "󰏘";
        # on-click= "bash $HOME/.config/hypr/randwall.sh";
        # on-click-right= "bash $HOME/.config/hypr/wall.sh";
      };
      "custom/launcher" = {
        format = "";
        # on-click= "bash $HOME/.config/rofi/launcher.sh";
        # on-click-right= "bash $HOME/.config/rofi/run.sh";
        tooltip = "false";
      };
      "custom/notification" = {
        exec = "~/.config/waybar/scripts/notification.sh";
        on-click = "dunstctl set-paused toggle";
        on-click-right = "wallpaper";
        return-type = "json";
        max-length = 50;
        format = "{}";
      };
    };
  };

  waybar_style = let
    font = "MonoLisa";
    fontsize = "12";
    primary_accent = "cba6f7";
    secondary_accent = "89b4fa";
    tertiary_accent = "f5f5f5";
    background = "11111B";
    opacity = ".85";
    cursor = "Numix-Cursor";
  in ''
      @define-color white      #F2F2F2;
    @define-color black      #000203;
    @define-color text       #BECBCB;
    @define-color lightgray  #686868;
    @define-color darkgray   #353535;
    @define-color red        #F38BA8;

    @define-color black-transparent-1 rgba(0, 0, 0, 0.1);
    @define-color black-transparent-2 rgba(0, 0, 0, 0.2);
    @define-color black-transparent-3 rgba(0, 0, 0, 0.3);
    @define-color black-transparent-4 rgba(0, 0, 0, 0.4);
    @define-color black-transparent-5 rgba(0, 0, 0, 0.5);
    @define-color black-transparent-6 rgba(0, 0, 0, 0.6);
    @define-color black-transparent-7 rgba(0, 0, 0, 0.7);
    @define-color black-transparent-8 rgba(0, 0, 0, 0.8);
    @define-color black-transparent-9 rgba(0, 0, 0, 0.9);
    @define-color black-solid         rgba(0, 0, 0, 1.0);

    * {
        font-family:
            Iosevka,
            Material Design Icons Desktop;
        font-size: 13px;
        padding: 0;
        margin: 0;
    }

    window#waybar {
        background-color: @black-transparent-9;
        color: @text;
        border-radius: 0;
    }

    tooltip {
        background: @black-solid;
        border: 1px solid @darkgray;
        border-radius: 0;
    }
    tooltip label {
        color: @text;
    }

    #workspaces {
    }

    #workspaces button {
        background-color: transparent;
        color: @lightgray;
        transition: all 0.3s ease;
    }

    #workspaces button:hover {
        box-shadow: inherit;
        text-shadow: inherit;
        background: transparent;
        border: 1px solid rgba(0, 0, 0, 0);
        color: @white;
        transition: all 0.3s ease;
    }

    #workspaces button.focused,
    #workspaces button.active {
        color: @white;
        transition: all 0.3s ease;
        animation: colored-gradient 10s ease infinite;
    }

    #workspaces button.urgent {
        background-color: @red;
        color: @black;
        transition: all 0.3s ease;
    }

    /* -------------------------------------------------------------------------------- */

    #submap,
    #mode,
    #tray,
    #cpu,
    #memory,
    #backlight,
    #pulseaudio.audio,
    #pulseaudio.microphone,
    #network.wlo1,
    #network.eno1,
    #bluetooth,
    #battery,
    #clock,
    #mpd,
    #custom-media,
    #custom-notification {
        background-color: transparent;
        color: @text;
        margin-top: 4px;
        margin-bottom: 4px;
        margin-left: 0;
        margin-right: 0;
        border-radius: 20px;
        transition: all 0.3s ease;
    }

    #submap {
        border: 0;
    }

    /* -------------------------------------------------------------------------------- */

    /* If workspaces is the leftmost module, omit left margin */
    .modules-left > widget:first-child > #workspaces button,
    .modules-left > widget:first-child > #tray,
    .modules-left > widget:first-child > #cpu,
    .modules-left > widget:first-child > #memory,
    .modules-left > widget:first-child > #backlight,
    .modules-left > widget:first-child > #pulseaudio.audio,
    .modules-left > widget:first-child > #pulseaudio.microphone,
    .modules-left > widget:first-child > #network.wlo1,
    .modules-left > widget:first-child > #network.eno1,
    .modules-left > widget:first-child > #bluetooth,
    .modules-left > widget:first-child > #battery,
    .modules-left > widget:first-child > #clock,
    .modules-left > widget:first-child > #custom-notification {
        margin-top: 4px;
    }

    .modules-right > widget:last-child > #workspaces button,
    .modules-right > widget:last-child > #tray,
    .modules-right > widget:last-child > #cpu,
    .modules-right > widget:last-child > #memory,
    .modules-right > widget:last-child > #backlight,
    .modules-right > widget:last-child > #pulseaudio.audio,
    .modules-right > widget:last-child > #pulseaudio.microphone,
    .modules-right > widget:last-child > #network.wlo1,
    .modules-right > widget:last-child > #network.eno1,
    .modules-right > widget:last-child > #bluetooth,
    .modules-right > widget:last-child > #battery,
    .modules-right > widget:last-child > #clock,
    .modules-right > widget:last-child > #custom-notification {
        margin-bottom: 4px;
    }

    /* -------------------------------------------------------------------------------- */

    #tray {
        background-color: transparent;
        padding: 1px 5px;
    }
    #tray menu {
        padding: 2px;
        border-radius: 0;
    }

    /* -------------------------------------------------------------------------------- */

    #backlight-slider {
        margin-top: 10px;
    }

    #backlight-slider slider {
        min-height: 0px;
        min-width: 0px;
        opacity: 0;
        background-image: none;
        border: none;
        box-shadow: none;
    }
    #backlight-slider trough {
        min-height: 80px;
        min-width: 10px;
        border-radius: 5px;
        background-color: black;
    }
    #backlight-slider highlight {
        min-width: 6px;
        border: 1px solid @text;
        border-radius: 5px;
        background-color: @text;
    }

    /* -------------------------------------------------------------------------------- */

    #pulseaudio-slider {
        margin-top: 6px;
    }

    #pulseaudio-slider slider {
        min-height: 0px;
        min-width: 0px;
        opacity: 0;
        background-image: none;
        border: none;
        box-shadow: none;
    }
    #pulseaudio-slider trough {
        min-height: 80px;
        min-width: 5px;
        border-radius: 5px;
        background-color: black;
    }
    #pulseaudio-slider highlight {
        min-width: 5px;
        border: 1px solid @text;
        border-radius: 5px;
        background-color: @text;
    }
  '';
in {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = waybar_config;
    style = waybar_style;
  };
}
