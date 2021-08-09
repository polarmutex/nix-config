local awful = require("awful")

local get_promptbox = function(s)
    return awful.widget.prompt()
end

return get_promptbox
