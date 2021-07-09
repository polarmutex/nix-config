--Remap escape to leave terminal mode
vim.api.nvim_exec([[
  augroup SpellCheck
    autocmd!
    autocmd BufNewFile,BufRead *.md setlocal spell
  augroup end
]], false)
