{ self
, pkgs
, lib
, ...
}:
{
  home.packages = with pkgs;[
    leftwm
    feh
  ];

  services.random-background = {
    enable = true;
    display = "scale";
    interval = "30m";
    imageDirectory = "%h/.config/wallpapers";
  };

  xdg.configFile = {
    "leftwm/config.ron" = {
      text = ''
        //  _        ___                                      ___ _
        // | |      / __)_                                   / __|_)
        // | | ____| |__| |_ _ _ _ ____      ____ ___  ____ | |__ _  ____    ____ ___  ____
        // | |/ _  )  __)  _) | | |    \    / ___) _ \|  _ \|  __) |/ _  |  / ___) _ \|  _ \
        // | ( (/ /| |  | |_| | | | | | |  ( (__| |_| | | | | |  | ( ( | |_| |  | |_| | | | |
        // |_|\____)_|   \___)____|_|_|_|   \____)___/|_| |_|_|  |_|\_|| (_)_|   \___/|_| |_|
        // A WindowManager for Adventurers                         (____/
        // For info about configuration please visit https://github.com/leftwm/leftwm/wiki

        #![enable(implicit_some)]
        (
            modkey: "Mod4",
            mousekey: "Mod4",
            workspaces: [],
            tags: [
                "a",
                "r",
                "s",
                "t",
                "n",
                "e",
                "i",
                "o",
            ],
            max_window_width: None,
            layouts: [
                MainAndVertStack,
                MainAndHorizontalStack,
                MainAndDeck,
                GridHorizontal,
                EvenHorizontal,
                EvenVertical,
                Fibonacci,
                LeftMain,
                CenterMain,
                CenterMainBalanced,
                CenterMainFluid,
                Monocle,
                RightWiderLeftStack,
                LeftWiderRightStack,
            ],
            layout_mode: Workspace,
            insert_behavior: Bottom,
            scratchpad: [
                (name: "Alacritty", value: "alacritty", x: 860, y: 390, height: 300, width: 200),
            ],
            window_rules: [
                (window_class: "Gcr-prompter", spawn_floating: true),
            ],
            disable_current_tag_swap: false,
            disable_tile_drag: false,
            disable_window_snap: true,
            focus_behaviour: Sloppy,
            focus_new_windows: true,
            sloppy_mouse_follows_focus: true,
            keybind: [
                (command: GotoTag, value: "1", modifier: ["modkey"], key: "a"),
                (command: GotoTag, value: "2", modifier: ["modkey"], key: "r"),
                (command: GotoTag, value: "3", modifier: ["modkey"], key: "s"),
                (command: GotoTag, value: "4", modifier: ["modkey"], key: "t"),
                (command: GotoTag, value: "5", modifier: ["modkey"], key: "n"),
                (command: GotoTag, value: "6", modifier: ["modkey"], key: "e"),
                (command: GotoTag, value: "7", modifier: ["modkey"], key: "i"),
                (command: GotoTag, value: "8", modifier: ["modkey"], key: "o"),
                (command: MoveToTag, value: "1", modifier: ["modkey", "Shift"], key: "a"),
                (command: MoveToTag, value: "2", modifier: ["modkey", "Shift"], key: "r"),
                (command: MoveToTag, value: "3", modifier: ["modkey", "Shift"], key: "s"),
                (command: MoveToTag, value: "4", modifier: ["modkey", "Shift"], key: "t"),
                (command: MoveToTag, value: "5", modifier: ["modkey", "Shift"], key: "n"),
                (command: MoveToTag, value: "6", modifier: ["modkey", "Shift"], key: "e"),
                (command: MoveToTag, value: "7", modifier: ["modkey", "Shift"], key: "i"),
                (command: MoveToTag, value: "8", modifier: ["modkey", "Shift"], key: "o"),
                (command: CloseWindow, value: "", modifier: ["modkey", "Shift"], key: "c"),
                (command: SoftReload, value: "", modifier: ["modkey", "Shift"], key: "z"),

                (command: Execute, value: "wezterm start --always-new-process", modifier: ["modkey"], key: "Return"),
                (command: Execute, value: "rofi -show", modifier: ["modkey"], key: "d"),
                (command: IncreaseMainWidth, value: "1", modifier: ["modkey"], key: "l"),
                (command: DecreaseMainWidth, value: "1", modifier: ["modkey"], key: "h"),
                (command: FocusWindowUp, value: "", modifier: ["modkey"], key: "k"),
                (command: FocusWindowDown, value: "", modifier: ["modkey"], key: "j"),
                (command: MoveWindowUp, value: "", modifier: ["modkey", "Shift"], key: "k"),
                (command: MoveWindowDown, value: "", modifier: ["modkey", "Shift"], key: "j"),

                //(command: Execute, value: "loginctl kill-session $XDG_SESSION_ID", modifier: ["modkey", "Shift"], key: "x"),
                //(command: Execute, value: "slock", modifier: ["modkey", "Control"], key: "l"),
                //(command: MoveToLastWorkspace, value: "", modifier: ["modkey", "Shift"], key: "w"),
                //(command: SwapTags, value: "", modifier: ["modkey"], key: "w"),
                //(command: MoveWindowTop, value: "", modifier: ["modkey", "Shift"], key: "Return"),
                //(command: NextLayout, value: "", modifier: ["modkey", "Control"], key: "k"),
                //(command: PreviousLayout, value: "", modifier: ["modkey", "Control"], key: "j"),
                //(command: FocusWorkspaceNext, value: "", modifier: ["modkey"], key: "l"),
                //(command: FocusWorkspacePrevious, value: "", modifier: ["modkey"], key: "h"),
            ],
            state_path: None,
        )
      '';
    };

    "leftwm/themes/current/theme.toml" = {
      text = ''
        border_width = 4
        margin = 5
        workspace_margin = 5
        default_border_color = '#676e8a'
        floating_border_color = '#3cc5f8;'
        focused_border_color = '#ffd543'
      '';
      # bug with ron
      #text = ''
      #  (border_width: 5,
      #  margin: 5,
      #  default_border_color: "#37474F",
      #  floating_border_color: "#225588",
      #  focused_border_color: "#732735",
      #  )
      #'';
    };

    "leftwm/themes/current/up" = {
      source = pkgs.writeTextFile {
        name = "up.sh";
        text = ''
          #!/usr/bin/env bash
          SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

          # Down the last running theme
          if [ -f "/tmp/leftwm-theme-down" ]; then
            echo "running down"
            /tmp/leftwm-theme-down
            rm -f /tmp/leftwm-theme-down
          fi
          ln -s $SCRIPTPATH/down /tmp/leftwm-theme-down

          # start eww daemon
          echo "starting daemon"
          eww daemon &

          echo "leftwm-command"
          ${pkgs.leftwm}/bin/leftwm-command "LoadTheme $SCRIPTPATH/theme.toml"

          #open eww 'bar' windows
          echo "start eww"
          #this is a bit of an uggly hack, a more elegant way will hopefully be possible with a future `eww` version
          sleep 1
          index=0
          echo "sizes"
          sizes=( ''$(leftwm-state -q -n -t ''$SCRIPTPATH/sizes.liquid | sed -r '/^\s*$/d' ) )
          echo "sizes done"
          for size in "''${sizes[@]}"
          do
            echo "opening bar0"
            eww open bar''$index
            let index=index+1
            echo "done"
          done
          echo "start eww done"
        '';
        executable = true;
      };
    };

    "leftwm/themes/current/sizes.liquid" = {
      text = ''
        {% for workspace in workspaces %}
        {{workspace.w}}x{{workspace.h}}+{{workspace.x}}+{{workspace.y}}
        {% endfor %}
      '';
    };

    "leftwm/themes/current/down" = {
      source = pkgs.writeTextFile {
        name = "down.sh";
        text = ''
          #!/usr/bin/env bash

          SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

          echo "unload theme"
          ${pkgs.leftwm}/bin/leftwm-command "UnloadTheme"

          echo "kill eww"
          if [ -x "$(command -v eww)" ]; then
            eww kill
          fi
        '';
        executable = true;
      };
    };
  };
  programs.rofi = {
    enable = true;
    theme = ./dots.rasi;
    extraConfig = {
      font = "MonoLisa Custom 11";
      modi = "drun";
      show-icons = true;
      drun-display-format = "{name}";
      case-sensitive = false;
    };
  };
}
