local M = {}
local p = require 'polarmutex.colorschemes.gruvbox.palette'

function M.setup()
    vim.g.terminal_color_0 = p.bg0
    vim.g.terminal_color_1 = p.neutral_red
    vim.g.terminal_color_2 = p.neutral_green
    vim.g.terminal_color_3 = p.neutral_yellow
    vim.g.terminal_color_4 = p.neutral_blue
    vim.g.terminal_color_5 = p.neutral_purple
    vim.g.terminal_color_6 = p.neutral_cyan
    vim.g.terminal_color_7 = p.fg4
    vim.g.terminal_color_8 = p.gray
    vim.g.terminal_color_9 = p.red
    vim.g.terminal_color_10 = p.green
    vim.g.terminal_color_11 = p.yellow
    vim.g.terminal_color_12 = p.blue
    vim.g.terminal_color_13 = p.purple
    vim.g.terminal_color_14 = p.cyan
    vim.g.terminal_color_15 = p.fg1
end

return M
