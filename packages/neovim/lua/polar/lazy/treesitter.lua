return {
    {
        "nvim-treesitter",
        event = "DeferredUIEnter",
        after = function()
            require("nvim-treesitter").setup({
                modules = {},
                sync_install = false,
                ignore_install = {},
                ensure_installed = {},
                auto_install = false,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            })
        end,
    },
}
