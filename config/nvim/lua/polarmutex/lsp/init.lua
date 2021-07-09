local lspconfig = require("lspconfig")
-- local lspinstall = require("polarmutex.lsp.install")

-- require('vim.lsp.log').set_level("trace")
-- require('vim.lsp.log').set_level("debug")

require("polarmutex.lsp.handlers")

-- require("polarmutex.lsp.servers.prosemd").setup()

require("polarmutex.lsp.servers.beancount")
require("polarmutex.lsp.servers.clangd")
-- require("polarmutex.lsp.servers.ccls")
require("polarmutex.lsp.servers.efm")
require("polarmutex.lsp.servers.prosemd")
require("polarmutex.lsp.servers.pyright")
require("polarmutex.lsp.servers.sumneko")
-- require("polarmutex.lsp.servers.nlua")
require("polarmutex.lsp.servers.svelte")
require("polarmutex.lsp.servers.typescript")
require("polarmutex.lsp.servers.vimls")
