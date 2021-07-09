vim.api.nvim_exec([[
augroup LuaHighlight")
    autocmd!
    autocmd TextYankPost * lua vim.highlight.on_yank { hlgroup = "Substitute", timeout = 150, on_macro = true }
augroup END"
]], false)

