vim.o.completeopt = "menuone,noselect"

local has_cmp, cmp = pcall(require, "cmp")
if has_cmp then
    cmp.setup({
        mapping = {
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-e>"] = cmp.mapping.close(),
            ["<c-y>"] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Insert,
                select = true,
            }),
        },
        sources = {
            { name = "buffer" },
            { name = "path" },
            { name = "nvim_lua" },
            { name = "nvim_lsp" },
            { name = "emoji" },
        },
    })
end
