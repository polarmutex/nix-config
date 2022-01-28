local opt = vim.opt
local cmd = vim.cmd
local indent = 4

vim.g.mapleader = " "
vim.g.maplocalleader = ","
opt.autowrite = true -- enable auto write
opt.clipboard = "unnamedplus" -- sync with system clipboard
opt.colorcolumn = "80" -- highlight col 80
opt.conceallevel = 2 -- Hide * markup for bold and italic
opt.confirm = true -- confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
-- opt.foldexpr = "nvim_treesitter#foldexpr()" -- TreeSitter folding
-- opt.foldlevel = 6
-- opt.foldmethod = "expr" -- TreeSitter folding
opt.grepprg = "rg --vimgrep"
opt.grepformat = "%f:%l:%c:%m"
opt.hidden = true -- Enable modified buffers in background
opt.hlsearch = true -- I wouldn't use this without my DoNoHL function
opt.ignorecase = true -- Ignore case
opt.inccommand = "split" -- preview incremental substitute
opt.incsearch = true -- Makes search act like search in modern browsers
opt.joinspaces = false -- No double spaces with join after a dot
opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "n" -- enable mouse mode
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend TODO try 17
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.scrolloff = 4 -- Lines of context
opt.shiftround = true -- Round indent
opt.shiftwidth = indent -- Size of an indent
opt.showmatch = true -- show matching brackets when text indicator is over them
opt.showmode = false -- dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "auto:3" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.tabstop = indent -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- save swap file and trigger CursorHold
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.wrap = false -- Disable line wrap
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }

-- TODO: w, {v, b, l}
opt.formatoptions = opt.formatoptions
    - "a" -- Auto formatting is BAD.
    - "t" -- Don't auto format my code. I got linters for that.
    + "c" -- In general, I like it when comments respect textwidth
    + "q" -- Allow formatting comments w/ gq
    - "o" -- O and o, don't continue comments
    + "r" -- But do continue when pressing enter.
    + "n" -- Indent past the formatlistpat, not underneath it.
    + "j" -- Auto-remove comments if possible.
    - "2" -- I'm not in gradeschool anymore

opt.shortmess = opt.shortmess - "S" -- Show Search count

-- don't load the plugins below
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_2html_plugin = 1

-- Check if we need to reload the file when it changed
cmd("au FocusGained * :checktime")

-- show cursor line only in active window
cmd([[
  autocmd InsertLeave,WinEnter * set cursorline
  autocmd InsertEnter,WinLeave * set nocursorline
]])

-- go to last loc when opening a buffer
cmd([[
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif
]])

-- Highlight on yank
cmd("au TextYankPost * lua vim.highlight.on_yank {}")

cmd([[autocmd BufRead,BufNewFile *.nix setfiletype nix]])
