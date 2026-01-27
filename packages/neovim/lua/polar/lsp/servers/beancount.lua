local map = vim.keymap.set
map("n", "<Leader>mc", "<cmd>%s/txn/*/gc<CR>", {
    desc = "beancount-nvim: mark transactions as reconciled",
    noremap = true,
    silent = true,
})
map("n", "<Leader>mt", function()
    require("telescope").extensions.beancount.copy_transactions(require("telescope.themes").get_ivy({}))
end, {
    desc = "Telescope: beancount: copy beancount transactions",
    noremap = true,
    silent = true,
})

---@type vim.lsp.Config
return {
    -- cmd = {"beancount-language-server"},
    -- cmd = { "/home/polar/repos/personal/beancount-language-server/main/target/release/beancount-language-server" },
    -- cmd = { "/home/polar/repos/personal/beancount-language-server/develop/target/debug/beancount-language-server" },
    cmd = { "/home/polar/repos/personal/beancount-language-server/develop/target/release/beancount-language-server" },
    -- cmd = { "/home/polar/repos/personal/beancount-language-server/develop/target/debug/beancount-language-server" },

    filetypes = { "beancount" },
    root_dir = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1]),
    capabilities = require("polar.lsp").make_client_capabilities(),
    -- single_file_support = true,
    init_options = {
        journal_file = "~/repos/personal/beancount/main/main.beancount",
        diagnostics = {
            enabled = false,
            providers = {
                tree_sitter = { enabled = true },
                style = { enabled = true },
            },
        },
        formatting = {
            number_currency_spacing = 1,
            indent_width = 2,
        },
    },
    settings = {},
    reuse_client = function(client, conf)
        return client.name == conf.name and client.config.root_dir == conf.root_dir
    end,
}
