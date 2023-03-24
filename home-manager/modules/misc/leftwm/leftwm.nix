_: {
  config,
  lib,
  pkgs,
  ...
}: let
  ronLib = (pkgs.formats.ron {}).lib;

  inherit (ronLib) enum;
  struct = ronLib.struct ""; # I don't need named structs in this config

  bind' = modifier: key: command: value: {
    inherit key modifier value;
    command = enum command;
  };

  bind = modifier: key: command: {
    inherit modifier key;
    command = enum command;
  };

  execute = modifier: key: value: {
    command = enum "Execute";
    inherit modifier key value;
  };

  gototag = modifier: key: value: {
    command = enum "GotoTag";
    inherit modifier key value;
  };

  movetotag = modifier: key: value: {
    command = enum "MoveToTag";
    inherit modifier key value;
  };

  # Bindings for common controls
  mod = "modkey";
  shift = "Shift";
  ctrl = "Control";
  alt = "Alt";
  return = "Return";

  leftwm-command = "${pkgs.leftwm}/bin/leftwm-command";
  eww-command = "${pkgs.eww}/bin/eww";
  feh = "${pkgs.feh}/bin/feh";
  wezterm = "${pkgs.wezterm}/bin/wezterm";
  rofi = "${pkgs.rofi}/bin/rofi";
  xset = "${pkgs.xorg.xset}/bin/xset";
  maim = "${pkgs.maim}/bin/maim";
  dunstify = "${pkgs.dunst}/bin/dunstify";
  amixer = "${pkgs.alsa-utils}/bin/amixer";
  light = "${pkgs.light}/bin/light";

  screenshot = pkgs.writeShellScript "take-screenshot.sh" ''
    if [ "$1" == "-s" ]; then
      cmd="${maim} -s"
    else
      cmd="${maim}"
    fi
    if eval "$cmd $HOME/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"; then
      ${dunstify} -u low "Screenshot taken" "at $(date +%r)"
    fi
  '';
  cfg = config.misc.leftwm;
in {
  options.misc.leftwm = {
    enable = lib.mkEnableOption "The leftwm window manager";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      #pkgs.slop
      #pkgs.maim
      #xclip
      eww
      pamixer
      brightnessctl
    ];

    xsession.windowManager.leftwm = {
      enable = true;

      settings = struct {
        modkey = "Mod4";
        mousekey = "Mod4";
        workspaces = [];
        tags = ["a" "r" "s" "t" "n" "e" "i" "o"];
        layouts = map enum [
          "MainAndVertStack"
          "MainAndHorizontalStack"
          "MainAndDeck"
          "GridHorizontal"
          "EvenHorizontal"
          "Fibonacci"
          "LeftMain"
          "CenterMain"
          "CenterMainBalanced"
          "CenterMainFluid"
          "Monocle"
          "RightWiderLeftStack"
          "LeftWiderRightStack"
          "EvenVertical"
        ];
        layout_mode = enum "Workspace";
        insert_behavior = enum "Bottom";
        scratchpad = map struct [
          {
            name = "Terminal";
            value = "${wezterm}";
            x = 0.25;
            y = 0.25;
            height = 0.5;
            width = 0.5;
          }
        ];
        window_rules = map struct [
          {
            window_class = "Gcr-prompter";
            spawn_floating = true;
          }
        ];
        disable_current_tag_swap = false;
        disable_tile_drag = false;
        disable_window_snap = true;
        focus_behaviour = enum "Sloppy"; # Bri*ish
        focus_new_windows = true;
        sloppy_mouse_follows_focus = true;
        max_window_width = null;

        keybind = map struct (lib.lists.flatten [
          # General
          (bind [mod shift] "c" "CloseWindow")
          (bind [mod shift] "z" "SoftReload")
          (bind [mod ctrl alt] "z" "HardReload")
          #(bind [mod shift] "f" "ToggleFloating")
          #(bind [mod] "f" "ToggleFullScreen")

          # Tags
          (gototag [mod] "a" "1")
          (gototag [mod] "r" "2")
          (gototag [mod] "s" "3")
          (gototag [mod] "t" "4")
          (gototag [mod] "n" "5")
          (gototag [mod] "e" "6")
          (gototag [mod] "i" "7")
          (gototag [mod] "o" "8")

          (movetotag [mod shift] "a" "1")
          (movetotag [mod shift] "r" "2")
          (movetotag [mod shift] "s" "3")
          (movetotag [mod shift] "t" "4")
          (movetotag [mod shift] "n" "5")
          (movetotag [mod shift] "e" "6")
          (movetotag [mod shift] "i" "7")
          (movetotag [mod shift] "o" "8")
          #(bind [mod] "w" "SwapTags")
          #(bind [mod] "z" "RotateTag")

          # Scratchpads
          (bind' [ctrl alt] "t" "ToggleScratchPad" "Terminal")

          # Layouts
          #(bind [mod ctrl] "k" "NextLayout")
          #(bind [mod ctrl] "Up" "NextLayout")
          #(bind [mod ctrl] "j" "PreviousLayout")
          #(bind [mod ctrl] "Down" "PreviousLayout")
          #(bind' [mod ctrl] "m" "SetLayout" "Monocle")
          #(bind' [mod ctrl] "f" "SetLayout" "Fibonacci")

          # Workspace
          #(bind [mod shift] "l" "FocusWorkspaceNext")
          #(bind [mod shift] "Right" "FocusWorkspaceNext")
          #(bind [mod shift] "h" "FocusWorkspacePrevious")
          #(bind [mod shift] "Left" "FocusWorkspacePrevious")
          #(bind [mod shift] "w" "MoveToLastWorkspace")

          # Window
          (bind' [mod] "l" "IncreaseMainWidth" "1")
          (bind' [mod] "h" "DecreaseMainWidth" "1")
          (bind [mod] "k" "FocusWindowUp")
          (bind [mod] "j" "FocusWindowDown")
          #(bind [mod] "t" "FocusWindowTop")
          (bind [mod shift] "k" "MoveWindowUp")
          (bind [mod shift] "j" "MoveWindowDown")
          #(bind [mod shift] "t" "MoveWindowTop")

          # External
          (execute [mod] return wezterm)
          (execute [mod] "d" "${rofi} -show drun")
          #(execute [mod shift] "Return" ''${rofi} -show combi -combi-modi "drun,window,run,ssh" -modi combi'')
          #(execute [mod] "l" "${xset} s activate")
          #(execute [mod ctrl alt] "q" "loginctl kill-session $XDG_SESSION_ID")
          #(execute [mod] "Print" "${screenshot} -s")
          #(execute [] "Print" "${screenshot}")
          #(execute [] "XF86XK_AudioRaiseVolume" "${amixer} sset Master 5%+")
          #(execute [] "XF86XK_AudioLowerVolume" "${amixer} sset Master 5%-")
          #(execute [] "XF86XK_AudioMute" "${amixer} sset Master toggle")
          #(execute [] "XF86XK_AudioMicMute" "${amixer} sset Capture toggle")
          #k(execute [] "XF86XK_MonBrightnessUp" "${light} -A 5")
          #(execute [] "XF86XK_MonBrightnessDown" "${light} -U 5")
          #(execute [] "XF86XK_Calculator" "rofi -modi calc -show calc")
          #(execute [ctrl alt] "Delete" "rofi-power-menu")
        ]);
      };

      themes = {
        # I literally don't know what to name this.
        polar = {
          theme = struct {
            border_width = 4;
            margin = 5;
            default_border_color = "#676e8a";
            floating_border_color = "#3cc5f8";
            focused_border_color = "#ffd543";
          };

          up = ''
            export SCRIPTPATH="$(cd "$(dirname "$0")"; pwd -P)"
            if [ -f "/tmp/leftwm-theme-down" ]; then
                /tmp/leftwm-theme-down
                rm /tmp/leftwm-theme-down
            fi
            ln -s $SCRIPTPATH/down /tmp/leftwm-theme-down
            ${eww-command} daemon &
            ${leftwm-command} "LoadTheme $SCRIPTPATH/theme.ron"

            systemctl --user restart random-background

            sleep 1
            index=0
            sizes=( ''$(leftwm-state -q -n -t ''$SCRIPTPATH/sizes.liquid | sed -r '/^\s*$/d' ) )
            for size in "''${sizes[@]}"
            do
              eww open bar''$index
              let index=index+1
            done
          '';

          down = ''
            export SCRIPTPATH="$(cd "$(dirname "$0")"; pwd -P)"
            ${leftwm-command} "UnloadTheme"
            if [ -x "$(command -v eww)" ]; then
              eww kill
            fi
          '';
        };
      };

      theme = "polar";
    };

    xdg.configFile = {
      "leftwm/themes/polar/sizes.liquid" = {
        text = ''
          {% for workspace in workspaces %}
          {{workspace.w}}x{{workspace.h}}+{{workspace.x}}+{{workspace.y}}
          {% endfor %}
        '';
      };
    };
  };
}
