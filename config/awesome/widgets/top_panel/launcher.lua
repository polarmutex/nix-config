local awful = require("awful")
local beautiful = require("beautiful")
require("widgets.mainmenu")

local mylauncher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = mymainmenu,
})

return mylauncher
