local wezterm = require("wezterm")
wezterm.add_to_config_reload_watch_list("~/.config/wezterm")
return {
	--font = wezterm.font("MonoLisa Nerd Font"),
	font_size = 11,
	check_for_updates = false,
	window_background_opacity = 0.9,
	enable_tab_bar = false,

	front_end = "OpenGL",
	enable_wayland = false,

	colors = {
		foreground = "#c0caf5",
		background = "#1a1b26",
		cursor_bg = "#c0caf5",
		cursor_border = "#c0caf5",
		cursor_fg = "#1a1b26",
		selection_bg = "#33467C",
		selection_fg = "#c0caf5",

		ansi = { "#15161E", "#f7768e", "#9ece6a", "#e0af68", "#7aa2f7", "#bb9af7", "#7dcfff", "#a9b1d6" },
		brights = { "#414868", "#f7768e", "#9ece6a", "#e0af68", "#7aa2f7", "#bb9af7", "#7dcfff", "#c0caf5" },
	},
}
