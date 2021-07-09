local M = {}

-- @param map {{mode, lhs, rhs, opts}, ..}
-- @param mode string 'n' | 'i' | 'v'
-- @param lhs string key to map
-- @param rhs string command to run
M.keymap = function(map)
    map = map or {}
    local opts = map[4] or {}
    return vim.api.nvim_set_keymap(map[1], map[2], map[3], opts)
end

-- @param maps list of keymaps
M.keymaps = function(maps) for _, m in ipairs(maps) do M.keymap(m) end end

return M
