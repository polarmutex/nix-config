-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Themes defines colours, icons, fonts and wallpapers.
require("beautiful").init(string.format("%s/.config/awesome/themes/gruvbox/theme.lua", os.getenv("HOME")))

-- Init all modules
require("modules.error_handling")
require("modules.auto_start")
require("modules.sloppy_focus")
--require("modules.set_wallpaper")

require("configuration.layouts")
require("widgets.watches")
require("ui")
--require("configuration.tags")
require("configuration.client")
require("configuration")
_G.root.keys(require("configuration.keybinds.global"))
_G.root.buttons(require("configuration.mouse.desktop"))
