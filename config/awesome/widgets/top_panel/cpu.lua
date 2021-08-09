local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")

local cpu = wibox.widget.textbox("")

local popup = awful.popup({
    ontop = true,
    visible = false,
    shape = gears.shape.rounded_rect,
    border_width = 1,
    border_color = beautiful.bg_normal,
    maximum_width = 400,
    offset = { y = 5 },
    widget = {},
})

cpu:buttons(awful.util.table.join(awful.button({}, 1, function()
    if popup.visible then
        popup.visible = not popup.visible
    else
        popup:move_next_to(mouse.current_widget_geometry)
    end
end)))

local function create_process_header(params)
    local res = wibox.widget({
        helpers.create_textbox({ markup = "<b>PID</b>" }),
        helpers.create_textbox({ markup = "<b>Name</b>" }),
        {
            helpers.create_textbox({ markup = "<b>%CPU</b>" }),
            helpers.create_textbox({ markup = "<b>%MEM</b>" }),
            nil,
            layout = wibox.layout.align.horizontal,
        },
        layout = wibox.layout.ratio.horizontal,
    })
    res:ajust_ratio(2, 0.2, 0.47, 0.33)

    return res
end

awesome.connect_signal("watches::cpu", function(value)
    local formatted_percentage = string.format("%.1f%%", value)

    cpu.markup = helpers.colorize_text(formatted_percentage .. " ", beautiful.clr.orange)
end)

awesome.connect_signal("watches::cpu_extra", function(cores, processes)
    -- Process the CPU Cores
    local cpu_rows = {
        spacing = 4,
        layout = wibox.layout.fixed.vertical,
    }
    for i, core in pairs(cores) do
        local row = wibox.widget({
            helpers.create_textbox({ text = core.name }),
            helpers.create_textbox({ text = math.floor(core.usage) .. "%" }),
            {
                max_value = 100,
                value = core.usage,
                forced_height = 20,
                forced_width = 150,
                paddings = 1,
                margins = 4,
                border_width = 1,
                border_color = beautiful.bg_focus,
                background_color = beautiful.bg_normal,
                bar_border_width = 1,
                bar_border_color = beautiful.bg_focus,
                color = "linear:150,0:0,0:0,#D08770:0.3,#BF616A:0.6," .. beautiful.fg_normal,
                widget = wibox.widget.progressbar,
            },
            layout = wibox.layout.ratio.horizontal,
        })
        row:ajust_ratio(2, 0.15, 0.15, 0.7)
        cpu_rows[i] = row
    end

    --Process the process rows
    local process_rows = {
        layout = wibox.layout.fixed.vertical,
    }

    for i, process in pairs(processes) do
        local pid_name_rest = wibox.widget({
            helpers.create_textbox({ text = process.pid }),
            helpers.create_textbox({ text = process.comm }),
            {
                helpers.create_textbox({ text = process.cpu, align = "center" }),
                helpers.create_textbox({ text = process.mem, align = "center" }),
                layout = wibox.layout.fixed.horizontal,
            },
            layout = wibox.layout.ratio.horizontal,
        })
        pid_name_rest:ajust_ratio(2, 0.2, 0.47, 0.33)
        local row = wibox.widget({
            {
                pid_name_rest,
                top = 4,
                bottom = 4,
                widget = wibox.container.margin,
            },
            widget = wibox.container.background,
        })
        process_rows[i] = row
    end

    -- Update the popup
    popup:setup({
        {
            cpu_rows,
            {
                orientation = "horizontal",
                forced_height = 15,
                color = beautiful.bg_focus,
                widget = wibox.widget.separator,
            },
            create_process_header({}),
            process_rows,
            layout = wibox.layout.fixed.vertical,
        },
        margins = 8,
        widget = wibox.container.margin,
    })
end)

return cpu
