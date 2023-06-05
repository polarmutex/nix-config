_: {
  config,
  lib,
  ...
}: let
  cfg = config.programs.kitty;
in {
  options.programs.kitty = {
    textSize = lib.mkOption {
      type = lib.types.number;
      default = 11;
    };
  };
  config = lib.mkIf cfg.enable {
    #home.sessionVariables.TERMINAL = "kitty";

    programs.kitty = {
      font = {
        name = "MonoLisa Custom";
      };
      settings = {
        enable_audio_bell = "no";
        visual_bell_duration = "1.0";

        dim_opacity = "0.95";
        background_opacity = "0.90";
        background = "#222436";
        foreground = "#c8d3f5";
        selection_background = "#2d3f76";
        selection_foreground = "#c8d3f5";
        url_color = "#4fd6be";
        cursor = "#c8d3f5";
        cursor_text_color = "#222436";

        # Tabs
        active_tab_background = "#82aaff";
        active_tab_foreground = "#1e2030";
        inactive_tab_background = "#2f334d";
        inactive_tab_foreground = "#545c7e";
        #tab_bar_background = "#1b1d2b";

        # Windows
        active_border_color = "#82aaff";
        inactive_border_color = "#2f334d";

        # normal
        color0 = "#1b1d2b";
        color1 = "#ff757f";
        color2 = "#c3e88d";
        color3 = "#ffc777";
        color4 = "#82aaff";
        color5 = "#c099ff";
        color6 = "#86e1fc";
        color7 = "#828bb8";

        # bright
        color8 = "#444a73";
        color9 = "#ff757f";
        color10 = "#c3e88d";
        color11 = "#ffc777";
        color12 = "#82aaff";
        color13 = "#c099ff";
        color14 = "#86e1fc";
        color15 = "#c8d3f5";

        # extended colors
        color16 = "#ff966c";
        color17 = "#c53b53";
        symbol_map = let
          mappings = [
            "U+23FB-U+23FE"
            "U+2B58"
            "U+E200-U+E2A9"
            "U+E0A0-U+E0A3"
            "U+E0B0-U+E0BF"
            "U+E0C0-U+E0C8"
            "U+E0CC-U+E0CF"
            "U+E0D0-U+E0D2"
            "U+E0D4"
            "U+E700-U+E7C5"
            "U+F000-U+F2E0"
            "U+2665"
            "U+26A1"
            "U+F400-U+F4A8"
            "U+F67C"
            "U+E000-U+E00A"
            "U+F300-U+F313"
            "U+E5FA-U+E62B"
          ];
        in
          (builtins.concatStringsSep "," mappings) + " Symbols Nerd Font";
      };
    };
  };
}
