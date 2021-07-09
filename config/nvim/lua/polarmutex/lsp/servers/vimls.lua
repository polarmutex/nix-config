local lspconfig = require("lspconfig")
local lspname = "vimls"
local install_path = vim.fn.stdpath("data") .. "/lspinstall/" .. lspname

lspconfig[lspname].setup{
    cmd = { install_path .. "/node_modules/.bin/vim-language-server" },
}
