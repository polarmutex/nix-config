local M = {}
local highlights = require('polarmutex.colorschemes.gruvbox.highlights')
local terminal = require('polarmutex.colorschemes.gruvbox.terminal')

local function colorscheme()
    vim.cmd("hi clear")
    if vim.fn.exists("syntax_on") then vim.cmd("syntax reset") end
    vim.o.background = "dark"
    vim.o.termguicolors = true
    highlights.setup()
    terminal.setup()
end

function M.setup() colorscheme() end

return M
