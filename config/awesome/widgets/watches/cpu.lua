-- Provides:
-- watches::cpu
--      used percentage (integer)

local awful = require("awful")

local update_interval = 5 -- secs

--local cpu_vmstat_script = [[
--    sh -c "vmstat 1 2 | tail -1 | awk '{printf \"%d\", $15}'"
--]]
local cpu_procstat_script = [[
    sh -c "grep '^cpu.' /proc/stat; ps -eo '%p|%c|%C|' -o "%mem" -o '|%a' --sort=-%cpu | head -11 | tail -n +2"
]]

-- Periodically get cpu info
--awful.widget.watch(cpu_vmstat_script, update_interval, function(widget, stdout)
--    -- local cpu_idle = stdout:match('+(.*)%.%d...(.*)%(')
--    local cpu_idle = stdout
--    cpu_idle = string.gsub(cpu_idle, '^%s*(.-)%s*$', '%1')
--    awesome.emit_signal("watches::cpu", 100 - tonumber(cpu_idle))
--end)

-- Periodically get cpu info

-- Splits the string by separator
-- @return table with separated substrings
local function split(string_to_split, separator)
    if separator == nil then
        separator = "%s"
    end
    local t = {}

    for str in string.gmatch(string_to_split, "([^" .. separator .. "]+)") do
        table.insert(t, str)
    end

    return t
end

-- Checks if a string starts with a another string
local function starts_with(str, start)
    return str:sub(1, #start) == start
end

local cpus = {}
local processes = {}
awful.widget.watch(cpu_procstat_script, update_interval, function(widget, stdout)
    local cpu_num = 1
    local proc_num = 1
    for line in stdout:gmatch("[^\r\n]+") do
        if starts_with(line, "cpu") then
            local core = cpus[cpu_num] or { last_active = 0, last_total = 0, usage = 0 }

            local name, user, nice, system, idle, iowait, irq, softirq, steal, _, _ = line:match(
                "(%w+)%s+(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)"
            )

            local total = user + nice + system + idle + iowait + irq + softirq + steal

            local diff_idle = idle - core.last_active
            local diff_total = total - core.last_total
            local usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10

            core.last_total = total
            core.last_active = idle
            core.usage = usage
            core.name = name

            if cpu_num == 1 then
                awesome.emit_signal("watches::cpu", usage)
            end

            cpus[cpu_num] = core

            cpu_num = cpu_num + 1
        else
            local columns = split(line, "|")

            local process = processes[proc_num] or { pid = "", comm = "", cpu = "", mem = "", cmd = "" }

            process.pid = columns[1]
            process.comm = columns[2]
            process.cpu = columns[3]
            process.mem = columns[4]
            process.cmd = columns[5]

            processes[proc_num] = process

            proc_num = proc_num + 1
        end
    end
    awesome.emit_signal("watches::cpu_extra", cpus, processes)
end)
