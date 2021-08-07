local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
--local helpers = require("helpers")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

--local configuration = require("configuration.config")

-- Separators
local spr = wibox.widget.textbox("     ")
local half_spr = wibox.widget.textbox("  ")

-- Clock
local clockicon = wibox.widget.textbox(
    string.format('<span color="%s" font="' .. beautiful.icon_font .. '"> </span>', beautiful.clr.purple)
)

-- Calendar
local calendaricon = wibox.widget.textbox(
    string.format('<span color="%s" font="' .. beautiful.icon_font .. '"> </span>', beautiful.clr.yellow)
)
local calendar = wibox.widget.textclock(
    '<span font="' .. beautiful.widget_font .. '" color="' .. beautiful.clr.yellow .. '"> %-d %b %Y (%a)</span>'
)

-- CPU
local cpuicon = wibox.widget.textbox(
    string.format('<span color="%s" font="' .. beautiful.icon_font .. '"> </span>', beautiful.clr.orange)
)
local cpu = require("widgets.top_panel.cpu")

-- Mem
local memicon = wibox.widget.textbox(
    string.format('<span color="%s" font="' .. beautiful.icon_font .. '"> </span>', beautiful.clr.red)
)
local mem = require("widgets.top_panel.ram")

awful.screen.connect_for_each_screen(function(s)
    -- Tagtable for each screen.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    s.mytaglist = require("widgets.top_panel.taglist")(s)
    s.mylayoutbox = require("widgets.top_panel.layoutbox")(s)

    s.wibox = awful.wibar({
        height = dpi(20),
        screen = mouse.screen,
        expand = true,
        visible = true,
        bg = beautiful.bg_normal,
    })
    s.wibox:setup({
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            {
                layout = wibox.layout.fixed.horizontal,
                {
                    s.mytaglist,
                    bg = beautiful.bg_light,
                    shape = gears.shape.rounded_rect,
                    widget = wibox.container.background,
                },
            },
            widget = wibox.container.margin,
        },
        { -- Center widgets
            layout = wibox.layout.align.horizontal,
        },
        {
            {

                {
                    {
                        layout = wibox.layout.fixed.horizontal,
                        --half_spr,
                        cpuicon,
                        cpu,
                        --half_spr,
                    },
                    bg = beautiful.bg_light,
                    shape = gears.shape.rounded_rect,
                    widget = wibox.container.background,
                },
                {
                    {
                        layout = wibox.layout.fixed.horizontal,
                        --half_spr,
                        memicon,
                        mem,
                        --half_spr,
                    },
                    bg = beautiful.bg_light,
                    shape = gears.shape.rounded_rect,
                    widget = wibox.container.background,
                },
                {
                    {
                        layout = wibox.layout.fixed.horizontal,
                        --half_spr,
                        --volicon,
                        --vol,
                        --half_spr,
                    },
                    bg = beautiful.bg_light,
                    shape = gears.shape.rounded_rect,
                    widget = wibox.container.background,
                },
                {
                    {
                        layout = wibox.layout.fixed.horizontal,
                        --half_spr,
                        calendaricon,
                        calendar,
                        --half_spr,
                    },
                    bg = beautiful.bg_light,
                    shape = gears.shape.rounded_rect,
                    widget = wibox.container.background,
                },
                half_spr,
                layout = wibox.layout.fixed.horizontal,
                {
                    {
                        layout = wibox.layout.fixed.horizontal,
                        wibox.widget.systray(),
                    },
                    bg = beautiful.bg_light,
                    shape = gears.shape.rounded_rect,
                    widget = wibox.container.background,
                },
                half_spr,
                {
                    {
                        layout = wibox.layout.fixed.horizontal,
                        s.mylayoutbox,
                        half_spr,
                        clockicon,
                        require("widgets.top_panel.textclock"),
                    },
                    bg = beautiful.bg_light,
                    shape = gears.shape.rounded_rect,
                    widget = wibox.container.background,
                },
                {
                    {
                        layout = wibox.layout.align.horizontal,
                        --power,
                    },
                    widget = wibox.container.background,
                    bg = beautiful.bg_light,
                    shape = gears.shape.rounded_rect,
                },
            },
            widget = wibox.container.margin,
        },
    })
end)
