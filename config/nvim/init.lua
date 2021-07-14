--    _       _ __    __
--   (_)___  (_) /_  / /_  ______ _
--  / / __ \/ / __/ / / / / / __ `/
-- / / / / / / /__ / / /_/ / /_/ /
--/_/_/ /_/_/\__(_)_/\__,_/\__,_/

require("polarmutex.options")
require("polarmutex.util")

vim.defer_fn(function()
    require("polarmutex.plugins")
end, 0)

--vim.api.nvim_exec([[
--augroup start_screen
--    autocmd!
--    autocmd VimEnter * ++once lua require('polarmutex.modules.start-screen').start()
--augroup END
--]], false)

-- automatically run packer compile on plugin change
vim.api.nvim_command("autocmd BufWritePost plugins.lua PackerCompile")
