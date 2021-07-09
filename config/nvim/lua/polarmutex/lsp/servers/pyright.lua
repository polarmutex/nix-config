local lspconfig = require("lspconfig")
local lspname = "pyright"
local install_path = vim.fn.stdpath("data") .. "/lspinstall/" .. lspname

lspconfig[lspname].setup{
    cmd = { install_path .. "/node_modules/.bin/pyright-langserver", "--stdio" },
    settings = {
        analysis = {autoSearchPaths = true},
        pyright = {useLibraryCodeForTypes = true},
    },
    before_init = function(initialization_params, config)
        -- do I still need this?
        initialization_params["workspaceFolders"] =
            {{name = "workspace", uri = initialization_params["rootUri"]}}
    end,
}
