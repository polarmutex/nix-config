local lspstatus = require("lsp-status")
local lspconfig = require("lspconfig")
local lspname = "clangd"
local install_path = vim.fn.stdpath("data") .. "/lspinstall/" .. lspname
local custom_attach = require("polarmutex.lsp.attach").default_custom_on_attach

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.semanticHighlighting = true

lspconfig[lspname].setup {
    cmd = {
        "clangd", "--background-index", "--clang-tidy", "--completion-style=detailed",
        "--suggest-missing-includes", "--cross-file-rename"
    },
    init_options = {
        clangdFileStatus = true,
        usePlaceholders = true,
        completeUnimported = true,
        semanticHighlighting = true
    },
    -- Required for lsp-status
    handlers = lspstatus.extensions.clangd.setup(),
    capabilities = vim.tbl_extend("keep", capabilities, lspstatus.capabilities),
    on_attach = custom_attach

}
