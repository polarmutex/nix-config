local lspstatus = require("lsp-status")
local lspconfig = require("lspconfig")
local lspname = "clangd"
local install_path = vim.fn.stdpath("data") .. "/lspinstall/" .. lspname
local custom_attach = require("polarmutex.lsp.attach").default_custom_on_attach

lspconfig[lspname].setup {
    -- Required for lsp-status
    handlers = lspstatus.extensions.clangd.setup(),
    capabilities = lspstatus.capabilities,
    on_attach = custom_attach,
    configurationSources = {"flake8"},
    plugins = {
        autopep8 = {enabled = false},
        flake8 = {enabled = true},
        jedi_completion = {enabled = false},
        jedi_definition = {enabled = false},
        jedi_symbols = {enabled = false},
        jedi_references = {enabled = false},
        mccabe = {enabled = false},
        preload = {enabled = true},
        pydocstyle = {enabled = false},
        pyflakes = {enabled = false},
        pylint = {enabled = true},
        pycodestyle = {enabled = false},
        rope_completion = {enabled = false},
        yapf = {enabled = false}
    }
}
