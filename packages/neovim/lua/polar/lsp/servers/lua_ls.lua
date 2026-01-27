-- vim.bo.comments = ":---,:--"

---@type vim.lsp.Config
return {
    cmd = { "lua-language-server" },
    root_markers = {
        ".luarc.json",
        ".luarc.jsonc",
        ".luacheckrc",
        ".stylua.toml",
        "stylua.toml",
        "selene.toml",
        "selene.yml",
        ".git",
    },
    filetypes = { "lua" },
    -- before_init = require("neodev.lsp").before_init,
    on_init = function(client)
        client.settings = vim.tbl_deep_extend("force", client.settings, {
            Lua = {
                runtime = {
                    version = "LuaJIT",
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global, etc.
                    globals = {
                        "Snacks",
                        --     "vim",
                        --     "describe",
                        --     "it",
                        --     "assert",
                        --     "stub",
                    },
                    -- disable = {
                    --     "duplicate-set-field",
                    -- },
                },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME,
                        -- Depending on the usage, you might want to add additional paths here.
                        -- "${3rd}/luv/library"
                        -- "${3rd}/busted/library",
                    },
                    -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                    -- library = vim.api.nvim_get_runtime_file("", true)
                },
                telemetry = {
                    enable = false,
                },
                hint = { -- inlay hints (supported in Neovim >= 0.10)
                    enable = true,
                },
                format = {
                    enable = false,
                },
            },
        })
    end,
}
