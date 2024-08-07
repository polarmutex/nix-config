-- window_decorations = "RESIZE",
-- native_macos_fullscreen_mode = true,
local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.automatically_reload_config = true

config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
-- config.animation_fps = 1
--config.cursor_blink_ease_in = "Constant"
--config.cursor_blink_ease_out = "Constant"

--config.underline_thickness = 3
--config.cursor_thickness = 4
--config.underline_position = -6
config.window_decorations = "RESIZE"

config.font_size = 11
config.font = wezterm.font_with_fallback({
	"MonoLisa Custom",
	"Symbols Nerd Font",
	"Symbola",
})
--config.bold_brightens_ansi_colors = true
config.check_for_updates = false
config.enable_tab_bar = false
--config.window_close_confirmation = "NeverPrompt"

-- Cursor
--config.default_cursor_style = "BlinkingBar"
--config.force_reverse_video_cursor = true
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.window_background_opacity = 0.9
config.scrollback_lines = 10000

config.color_scheme = "polar"
config.color_schemes = {
	["polar"] = {
		foreground = "#dcd7ba",
		background = "#1f1f28",
		cursor_bg = "#c8c093",
		cursor_border = "#c8c093",
		cursor_fg = "#c8c093",
		selection_fg = "#c8c093",
		selection_bg = "#2d4f67",

		scrollbar_thumb = "#16161d",
		split = "#16161d",

		ansi = { "#090618", "#c34043", "#76946a", "#c0a36e", "#7e9cd8", "#957fb8", "#6a9589", "#c8c093" },
		brights = { "#727169", "#e82424", "#98bb6c", "#e6c384", "#7fb4ca", "#938aa9", "#7aa89f", "#dcd7ba" },
		indexed = { [16] = "#ffa066", [17] = "#ff5d62" },
	},
}

return config
