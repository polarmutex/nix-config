vim.o.completeopt = "menuone,noselect"

local has_compe, compe = pcall(require, "compe")
if has_compe then
    compe.setup({
        enabled = true,
        autocomplete = true,
        debug = false,
        min_length = 1,
        preselect = "enabled",
        throttle_time = 80,
        source_timeout = 200,
        incomplete_delay = 400,
        allow_prefix_unmatch = false,
        max_abbr_width = 100,
        max_kind_width = 100,
        max_menu_width = 100,
        documentation = true,

        source = {
            nvim_lsp = true,
            buffer = false,
            path = true,
            calc = true,
            vsnip = false,
            nvim_lua = true,
            spell = true,
            tags = false,
            snippets_nvim = false,
            treesitter = false,
        },
    })
end
