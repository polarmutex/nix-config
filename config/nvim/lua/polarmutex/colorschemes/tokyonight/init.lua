local util = require("polarmutex.colorschemes.utils")
local theme = require("polarmutex.colorschemes.tokyonight.theme")

local M = {}

function M.colorscheme(config)
    util.load(theme.setup(config))
end

return M
