local lspconfig = require("lspconfig")
local lspname = "tsserver"
local install_path = vim.fn.stdpath("data") .. "/lspinstall/typescript"

lspconfig[lspname].setup{
    cmd = { install_path .. "/node_modules/.bin/typescript-language-server" },
    filetypes = {
        "javascript", "javascriptreact", "javascript.jsx", "typescript",
        "typescriptreact", "typescript.tsx",
    },
}
