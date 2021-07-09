local lspconfig = require("lspconfig")
local lspname = "beancount"
local custom_on_attach = require('polarmutex.lsp.attach').default_custom_on_attach
local install_path = vim.fn.stdpath("data") .. "/lspinstall/" .. lspname

lspconfig[lspname].setup{
    cmd = {
         "node",
        -- "--inspect",
         "/home/brian/repos/beancount-language-server.git/feat-diag-rework/packages/beancount-language-server/out/cli.js",
        --"beancount-langserver",
        "--stdio",
    },
    init_options = {
        journalFile = "~/repos/beancount/journal.beancount",
        pythonPath = "~/.cache/pypoetry/virtualenvs/beancount-repo-iwRmyqK8-py3.9/bin/python3",
    },
    flags = {
        -- time in millisec to debounce dichange notifications
        debounce_text_changes = 500,
    },
    on_attach = custom_on_attach,
}
