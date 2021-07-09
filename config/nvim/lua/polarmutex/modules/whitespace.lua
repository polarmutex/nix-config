
local M = {}

M.TrimWhitespace = function()
    local save = vim.api.nvim_call_function("winsaveview", {})
    vim.api.nvim_command([[keeppatterns %s/\s\+$//e]])
    vim.api.nvim_call_function("winrestview", {save})
end

M.setup = function()
    vim.cmd([[ autocmd BufWritePre * :lua require('polarmutex.modules.whitespace').TrimWhitespace() ]])
end

return M
