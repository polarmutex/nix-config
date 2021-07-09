local lspconfig = require("lspconfig")
local custom_attach = require("polarmutex.lsp.attach")

require("nlua.lsp.nvim").setup(lspconfig, {
    on_attach = custom_attach,

    root_dir = function(fname)
        if string.find(vim.fn.fnamemodify(fname, ":p"), "neovim/") then
            return vim.fn.expand("~/repos/dotfiles/neovim/")
        end

        return lspconfig_util.find_git_ancestor(fname) or
                   lspconfig_util.path.dirname(fname)
    end,

    globals = {
        -- Colorbuddy
        "Color", "c", "Group", "g", "s", -- Custom
        "RELOAD",
    },
})
