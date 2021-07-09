-- Put these in an autocmd group, so that you can revert them with:
-- :augroup vimStartup | au! | augroup END

-- When editing a file, always jump to the last known cursor position.
-- Don't do it when the position is invalid, when inside an event handler
-- (happens when dropping a file on gvim) and for a commit message (it's
-- likely a different one than last time).

vim.api.nvim_exec([[
augroup vimStartup
    autocmd!
    autocmd BufReadPost * if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit' | exe "normal! g`\"" | endif
augroup END
]], false)

