--local Util = require("lazy.core.util")

local M = {}

-- Fast implementation to check if a table is a list
---@param t table
function M.is_list(t)
    local i = 0
    ---@diagnostic disable-next-line: no-unknown
    for _ in pairs(t) do
        i = i + 1
        if t[i] == nil then
            return false
        end
    end
    return true
end

local function can_merge(v)
    return type(v) == "table" and (vim.tbl_isempty(v) or not M.is_list(v))
end

--- Merges the values similar to vim.tbl_deep_extend with the **force** behavior,
--- but the values can be any type, in which case they override the values on the left.
--- Values will me merged in-place in the first left-most table. If you want the result to be in
--- a new table, then simply pass an empty table as the first argument `vim.merge({}, ...)`
--- Supports clearing values by setting a key to `vim.NIL`
---@generic T
---@param ... T
---@return T
function M.merge(...)
    local ret = select(1, ...)
    if ret == vim.NIL then
        ret = nil
    end
    for i = 2, select("#", ...) do
        local value = select(i, ...)
        if can_merge(ret) and can_merge(value) then
            for k, v in pairs(value) do
                ret[k] = M.merge(ret[k], v)
            end
        elseif value == vim.NIL then
            ret = nil
        elseif value ~= nil then
            ret = value
        end
    end
    return ret
end

function M.fg(name)
    ---@type {foreground?:number}?
    local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name })
        or vim.api.nvim_get_hl_by_name(name, true)
    local fg = hl and hl.fg or hl.foreground
    return fg and { fg = string.format("#%06x", fg) }
end

function M.on_attach(on_attach)
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local buffer = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            on_attach(client, buffer)
        end,
    })
end

---@param name string
function M.opts(name)
    local plugin = require("lazy.core.config").plugins[name]
    if not plugin then
        return {}
    end
    local Plugin = require("lazy.core.plugin")
    return Plugin.values(plugin, "opts", false)
end

local enabled = true
function M.toggle_diagnostics()
    enabled = not enabled
    if enabled then
        vim.diagnostic.enable()
        --Util.info("Enabled diagnostics", { title = "Diagnostics" })
    else
        vim.diagnostic.disable()
        --Util.warn("Disabled diagnostics", { title = "Diagnostics" })
    end
end

-- Find either the Nix-generated version of the plugin if it is
-- found, or fall back to fetching it remotely if it is not.
-- Don't mistake this for "use" from packer.nvim
M.use = function(name, spec)
    spec = spec or {}
    local plugin_name = name:match("[^/]+$")
    local plugin_dir = vim.fn.stdpath("data") .. "/plugins/" .. plugin_name
    if vim.fn.isdirectory(plugin_dir) > 0 then
        spec["dir"] = plugin_dir
    else
        spec[1] = name
    end
    return spec
end

return M
