local lspconfig = require("lspconfig")
local lspname = "svelte"
local install_path = vim.fn.stdpath("data") .. "/lspinstall/" .. lspname

lspconfig[lspname].setup{
    cmd = { install_path .. "/node_modules/.bin/svelteserver" },
    settings = {
        svelte = {
            plugin = {
                html = {completions = {enable = true, emmet = false}},
                svelte = {completions = {enable = true, emmet = false}},
                css = {completions = {enable = true, emmet = false}},
            },
        },
    },
}
