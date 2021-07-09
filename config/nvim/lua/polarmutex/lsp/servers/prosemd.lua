local lsputil = require("lspconfig/util")
local path = lsputil.path
local lspconfig = require("lspconfig")
local configs = require("lspconfig/configs")
local lspname = "prosemd"
local install_path = vim.fn.stdpath("data") .. "/lspinstall/" .. lspname

configs[lspname] = {
    default_config = {
        -- Update the path to prosemd-lsp
        -- cmd = { "/usr/local/bin/prosemd-lsp", "--stdio" },
        -- cmd = { path.join({ vim.loop.os_homedir(), ".cargo/bin/prosemd-lsp" }), "--stdio" },
        cmd = {
            path.join({
                vim.loop.os_homedir(),
                "repos/prosemd-lsp/target/release/prosemd-lsp",
            }), "--stdio",
        },
        filetypes = {"markdown", "svx"},
        root_dir = function(fname)
            return lsputil.find_git_ancestor(fname) or vim.fn.getcwd()
        end,
        settings = {},
    },
}
lspconfig[lspname].setup{}
