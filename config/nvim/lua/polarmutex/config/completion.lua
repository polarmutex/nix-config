vim.o.completeopt = "menuone,noselect"

-- Don't show the dumb matching stuff.
vim.opt.shortmess:append("c")

local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    mapping = {
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
        --{ name = "buffer" },
        { name = "path" },
        { name = "emoji" },
        { name = "nvim_lua" },
        { name = "nvim_lsp" },
        { name = "luasnip" },
    },
})
