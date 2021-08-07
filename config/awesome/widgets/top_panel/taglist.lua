local awful = require("awful")
local gears = require("gears")
local gfs = gears.filesystem
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
--local helpers = require("helpers")
local modkey = require("configuration.keybinds.mod").modKey

local get_taglist = function(s)
    -- Taglist buttons
    local taglist_buttons = gears.table.join(
        awful.button({}, 1, function(t)
            t:view_only()
        end),
        awful.button({ modkey }, 1, function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end),
        awful.button({}, 3, awful.tag.viewtoggle),
        awful.button({ modkey }, 3, function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end),
        awful.button({}, 4, function(t)
            awful.tag.viewnext(t.screen)
        end),
        awful.button({}, 5, function(t)
            awful.tag.viewprev(t.screen)
        end)
    )

    local update_taglist = function(self, t, index, tags)
        local has_client = false
        local has_focus = false

        for _, c in ipairs(client.get()) do
            if t == c.first_tag then
                has_client = true
                break
            end
        end
        for _, tag in ipairs(awful.screen.focused().selected_tags) do
            if t == tag then
                has_focus = true
            end
        end

        self.fg = beautiful.foreground
        if has_focus then
            self:get_children_by_id("index_role")[1].markup = "<b> " .. beautiful.char_focused_tag .. " </b>"
            self.fg = beautiful.clr.yellow
        elseif has_client then
            self:get_children_by_id("index_role")[1].markup = "<b> " .. beautiful.char_non_empty_tag .. " </b>"
            self.fg = beautiful.clr.green
        else
            self:get_children_by_id("index_role")[1].markup = "<b> " .. beautiful.char_empty_tag .. " </b>"
            self.fg = beautiful.clr.gray
        end
    end

    local taglist = awful.widget.taglist({
        screen = s,
        filter = awful.widget.taglist.filter.all,
        widget_template = {
            {
                {
                    {
                        {
                            {
                                id = "index_role",
                                widget = wibox.widget.textbox,
                                font = beautiful.font_taglist,
                            },
                            widget = wibox.container.margin,
                        },
                        shape = gears.shape.circle,
                        widget = wibox.container.background,
                    },
                    {
                        {
                            id = "icon_role",
                            widget = wibox.widget.imagebox,
                        },
                        widget = wibox.container.margin,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left = 8,
                right = 8,
                widget = wibox.container.margin,
            },
            style = { shape = gears.shape.rounded_bar },
            id = "background_role",
            widget = wibox.container.background,
            create_callback = function(self, c3, index, objects)
                update_taglist(self, c3, index, objects)
                self:connect_signal("mouse::enter", function()
                    if self.bg ~= beautiful.xbackground then
                        self.backup = self.bg
                        self.has_backup = true
                    end
                    self.bg = beautiful.xbackground
                end)
                self:connect_signal("mouse::leave", function()
                    if self.has_backup then
                        self.bg = self.backup
                    end
                end)
            end,
            update_callback = function(self, c3, index, objects)
                update_taglist(self, c3, index, objects)
            end,
        },
        buttons = taglist_buttons,
    })

    return taglist
end

return get_taglist
