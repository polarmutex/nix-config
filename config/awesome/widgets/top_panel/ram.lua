local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")

local ram = wibox.widget.textbox("")

awesome.connect_signal("watches::ram", function(used, total)
    local used_ram_percentage = string.format("%.1f%% ", (used / total) * 100)
    ram.markup = helpers.colorize_text(used_ram_percentage, beautiful.clr.red)
end)

return ram
