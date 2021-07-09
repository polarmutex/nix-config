--    ____      _ __        _
--   /  _/___  (_) /__   __(_)___ ___
--   / // __ \/ / __/ | / / / __ `__ \
-- _/ // / / / / /__| |/ / / / / / / /
-- /___/_/ /_/_/\__(_)___/_/_/ /_/ /_/

package.loaded["polarmutex.globals"] = nil

local modules = {
    -- cool opt tricks
    "polarmutex.globals",

    -- load plugins
    "polarmutex.plugins.packer",

    "polarmutex.lsp",
    "polarmutex.settings",
    "polarmutex.mappings",

    "polarmutex.modules.whitespace",
    "polarmutex.modules.spell",
    "polarmutex.modules.terminal",
    "polarmutex.modules.statusline",
    "polarmutex.modules.cur-col-line",
    "polarmutex.modules.cursor-last-edit",
    "polarmutex.modules.highlight-yank",
}

local errors = {}
for _, v in pairs(modules) do
    local ok, err = pcall(require, v)
    if not ok then
	table.insert(errors, err)
    end
end

if not vim.tbl_isempty(errors) then
    for _, v in pairs(errors) do
        print(v)
    end
end

vim.api.nvim_exec([[
augroup start_screen
    autocmd!
    autocmd VimEnter * ++once lua require('polarmutex.modules.start-screen').start()
augroup END
]], false)

-- automatically run packer compile on plugin change
vim.api.nvim_command("autocmd BufWritePost packer.lua PackerCompile")

