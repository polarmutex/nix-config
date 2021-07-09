local lspstatus = require("lsp-status")
local lspconfig = require("lspconfig")
local lspname = "ccls"
local install_path = vim.fn.stdpath("data") .. "/lspinstall/" .. lspname
local custom_attach = require("polarmutex.lsp.attach").default_custom_on_attach

lspconfig[lspname].setup {
    -- Required for lsp-status
    --handlers = lspstatus.extensions.ccls.setup(),
    --capabilities = lspstatus.capabilities,
    on_attach = custom_attach

}
