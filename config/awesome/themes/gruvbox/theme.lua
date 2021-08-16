local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}
theme.dir = string.format("%s/.config/awesome/themes/gruvbox/", os.getenv("HOME"))

-- Fonts
theme.font = "Monolisa 10"
theme.taglist_font = "FiraMono Nerd Font Mono 20"
theme.icon_font = "FiraMono Nerd Font 10"
theme.exit_screen_font = "FiraMono Nerd Font Mono 120"
theme.widget_font = "MonoLisa 10"
theme.notification_font = "Monolisa 10"
theme.tasklist_font = "Monolisa 10"

-- colors
theme.clr = {
    -- Dark Gruvbox Colors
    lightred = "#fb4934",
    red = "#cc241d",
    lightorange = "#fe8019",
    orange = "#d65d0e",
    lightyellow = "#fabd2f",
    yellow = "#d79921",
    lightgreen = "#b8bb26",
    green = "#98971a",
    lightaqua = "#8ec07c",
    aqua = "#689d6a",
    lightblue = "#83a598",
    blue = "#458588",
    lightpurple = "#d3869b",
    purple = "#b16286",
    fg0 = "#fbf1c7",
    fg1 = "#ebdbb2",
    fg2 = "#d5c4a1",
    fg3 = "#bdae93",
    fg4 = "#a89984",
    gray = "#928374",
    bg4 = "#7c6f64",
    bg3 = "#665c54",
    bg2 = "#504945",
    bg1 = "#3c3836",
    bg0_s = "#32302f",
    bg0 = "#282828",
    bg0_h = "#1d2021",
}

theme.bg_normal = theme.clr.bg0_h
theme.bg_focus = theme.clr.bg1
theme.bg_urgent = theme.clr.lightred
theme.bg_minimize = theme.clr.bg0
theme.bg_systray = theme.bg_normal

theme.fg_normal = theme.clr.gray
theme.fg_focus = theme.clr.yellow
theme.fg_urgent = theme.clr.red
theme.fg_minimize = theme.clr.bg1

theme.useless_gap = dpi(3)
theme.border_width = dpi(2)
theme.border_normal = theme.clr.bg0_h
theme.border_focus = theme.clr.yellow
theme.border_marked = theme.clr.lightred

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]

theme.taglist_bg_focus = theme.bg_focus
theme.taglist_bg_urgent = theme.bg_urgent
theme.taglist_bg_occupied = theme.bg_normal
theme.taglist_bg_empty = theme.bg_minimize
theme.taglist_fg_focus = theme.fg_focus
theme.taglist_fg_urgent = theme.fg_urgent
theme.taglist_fg_occupied = theme.fg_normal
theme.taglist_fg_empty = theme.fg_minimize

theme.hotkeys_modifiers_fg = "#51afef"

-- Generate taglist squares:
local taglist_square_size = dpi(0)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
theme.notification_font = "Monolisa 10"
theme.notification_bg = theme.bg_focus
theme.notification_fg = theme.fg_focus
theme.notification_border_width = 0

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path .. "default/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = themes_path .. "default/titlebar/close_normal.png"
theme.titlebar_close_button_focus = themes_path .. "default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path .. "default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus = themes_path .. "default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path .. "default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive = themes_path .. "default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path .. "default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active = themes_path .. "default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path .. "default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive = themes_path .. "default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path .. "default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active = themes_path .. "default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path .. "default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive = themes_path .. "default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path .. "default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active = themes_path .. "default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path .. "default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive = themes_path .. "default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path .. "default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active = themes_path .. "default/titlebar/maximized_focus_active.png"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path .. "default/layouts/fairhw.png"
theme.layout_fairv = themes_path .. "default/layouts/fairvw.png"
theme.layout_floating = themes_path .. "default/layouts/floatingw.png"
theme.layout_magnifier = themes_path .. "default/layouts/magnifierw.png"
theme.layout_max = themes_path .. "default/layouts/maxw.png"
theme.layout_fullscreen = themes_path .. "default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path .. "default/layouts/tilebottomw.png"
theme.layout_tileleft = themes_path .. "default/layouts/tileleftw.png"
theme.layout_tile = themes_path .. "default/layouts/tilew.png"
theme.layout_tiletop = themes_path .. "default/layouts/tiletopw.png"
theme.layout_spiral = themes_path .. "default/layouts/spiralw.png"
theme.layout_dwindle = themes_path .. "default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path .. "default/layouts/cornernww.png"
theme.layout_cornerne = themes_path .. "default/layouts/cornernew.png"
theme.layout_cornersw = themes_path .. "default/layouts/cornersww.png"
theme.layout_cornerse = themes_path .. "default/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_focus)

theme.char_focused_tag = ""
theme.char_empty_tag = ""
theme.char_non_empty_tag = ""

return theme
