--Remap escape to leave terminal mode and start in insert mode
vim.api.nvim_exec([[
  augroup Terminal
    autocmd!
    au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
    au TermOpen * set nonu
    au TermOpen * :startinsert
  augroup end
]], false)
