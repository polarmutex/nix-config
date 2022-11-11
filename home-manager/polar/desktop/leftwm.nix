{ self
, pkgs
, lib
, ...
}:
{
  home.packages = with pkgs;[
    leftwm
  ];

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
                "1",
                "2",
                "3",
                "4",
                "5",
                "6",
                "7",
                "8",
                "9",
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
            window_rules: [],
            disable_current_tag_swap: false,
            disable_tile_drag: false,
            disable_window_snap: true,
            focus_behaviour: Sloppy,
            focus_new_windows: true,
            sloppy_mouse_follows_focus: true,
            keybind: [
                (command: Execute, value: "dmenu_run", modifier: ["modkey"], key: "p"),
                (command: Execute, value: "wezterm start --always-new-process", modifier: ["modkey", "Shift"], key: "Return"),
                (command: CloseWindow, value: "", modifier: ["modkey", "Shift"], key: "q"),
                (command: SoftReload, value: "", modifier: ["modkey", "Shift"], key: "r"),
                (command: Execute, value: "loginctl kill-session $XDG_SESSION_ID", modifier: ["modkey", "Shift"], key: "x"),
                (command: Execute, value: "slock", modifier: ["modkey", "Control"], key: "l"),
                (command: MoveToLastWorkspace, value: "", modifier: ["modkey", "Shift"], key: "w"),
                (command: SwapTags, value: "", modifier: ["modkey"], key: "w"),
                (command: MoveWindowUp, value: "", modifier: ["modkey", "Shift"], key: "k"),
                (command: MoveWindowDown, value: "", modifier: ["modkey", "Shift"], key: "j"),
                (command: MoveWindowTop, value: "", modifier: ["modkey"], key: "Return"),
                (command: FocusWindowUp, value: "", modifier: ["modkey"], key: "k"),
                (command: FocusWindowDown, value: "", modifier: ["modkey"], key: "j"),
                (command: NextLayout, value: "", modifier: ["modkey", "Control"], key: "k"),
                (command: PreviousLayout, value: "", modifier: ["modkey", "Control"], key: "j"),
                (command: FocusWorkspaceNext, value: "", modifier: ["modkey"], key: "l"),
                (command: FocusWorkspacePrevious, value: "", modifier: ["modkey"], key: "h"),
                (command: MoveWindowUp, value: "", modifier: ["modkey", "Shift"], key: "Up"),
                (command: MoveWindowDown, value: "", modifier: ["modkey", "Shift"], key: "Down"),
                (command: FocusWindowUp, value: "", modifier: ["modkey"], key: "Up"),
                (command: FocusWindowDown, value: "", modifier: ["modkey"], key: "Down"),
                (command: NextLayout, value: "", modifier: ["modkey", "Control"], key: "Up"),
                (command: PreviousLayout, value: "", modifier: ["modkey", "Control"], key: "Down"),
                (command: FocusWorkspaceNext, value: "", modifier: ["modkey"], key: "Right"),
                (command: FocusWorkspacePrevious, value: "", modifier: ["modkey"], key: "Left"),
                (command: GotoTag, value: "1", modifier: ["modkey"], key: "1"),
                (command: GotoTag, value: "2", modifier: ["modkey"], key: "2"),
                (command: GotoTag, value: "3", modifier: ["modkey"], key: "3"),
                (command: GotoTag, value: "4", modifier: ["modkey"], key: "4"),
                (command: GotoTag, value: "5", modifier: ["modkey"], key: "5"),
                (command: GotoTag, value: "6", modifier: ["modkey"], key: "6"),
                (command: GotoTag, value: "7", modifier: ["modkey"], key: "7"),
                (command: GotoTag, value: "8", modifier: ["modkey"], key: "8"),
                (command: GotoTag, value: "9", modifier: ["modkey"], key: "9"),
                (command: MoveToTag, value: "1", modifier: ["modkey", "Shift"], key: "1"),
                (command: MoveToTag, value: "2", modifier: ["modkey", "Shift"], key: "2"),
                (command: MoveToTag, value: "3", modifier: ["modkey", "Shift"], key: "3"),
                (command: MoveToTag, value: "4", modifier: ["modkey", "Shift"], key: "4"),
                (command: MoveToTag, value: "5", modifier: ["modkey", "Shift"], key: "5"),
                (command: MoveToTag, value: "6", modifier: ["modkey", "Shift"], key: "6"),
                (command: MoveToTag, value: "7", modifier: ["modkey", "Shift"], key: "7"),
                (command: MoveToTag, value: "8", modifier: ["modkey", "Shift"], key: "8"),
                (command: MoveToTag, value: "9", modifier: ["modkey", "Shift"], key: "9"),
            ],
            state_path: None,
        )
      '';
    };
  };
}
