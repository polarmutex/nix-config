_: {
  config,
  lib,
  ...
}: let
  cfg = config.programs.wezterm;
in {
  options.programs.wezterm = {
    textSize = lib.mkOption {
      type = lib.types.number;
      default = 11;
    };
  };
  config = lib.mkIf cfg.enable {
    home.sessionVariables.TERMINAL = "wezterm start --always-new-process";
    #xdg.configFile."wezterm/wezterm.lua".source = link "wezterm.lua";

    programs.wezterm = {
      extraConfig = ''
         return {
            font = wezterm.font_with_fallback({
                "MonoLisa Custom",
                "Symbols Nerd Font",
            }),
            font_size = ${toString cfg.textSize},
            color_scheme = "polar",
            check_for_updates = false,
            window_background_opacity = 0.9,
            enable_tab_bar = false,
            window_close_confirmation = "NeverPrompt",

            ---front_end = "OpenGL",
            --enable_wayland = false,
        }
      '';
      colorSchemes = {
        polar = {
          foreground = "#c0caf5";
          background = "#1a1b26";
          cursor_bg = "#c0caf5";
          cursor_border = "#c0caf5";
          cursor_fg = "#1a1b26";
          selection_bg = "#33467C";
          selection_fg = "#c0caf5";

          ansi = [
            "#15161E"
            "#f7768e"
            "#9ece6a"
            "#e0af68"
            "#7aa2f7"
            "#bb9af7"
            "#7dcfff"
            "#a9b1d6"
          ];
          brights = [
            "#414868"
            "#f7768e"
            "#9ece6a"
            "#e0af68"
            "#7aa2f7"
            "#bb9af7"
            "#7dcfff"
            "#c0caf5"
          ];
        };
      };
    };
  };
}
