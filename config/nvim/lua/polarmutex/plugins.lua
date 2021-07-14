local packer = require("polarmutex.util.packer")

local config = {
    profile = {
        enable = true,
        threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
    },
    display = {
        open_fn = function()
            return require("packer.util").float({ border = "single" })
        end,
    },
    -- list of plugins that should be taken from ~/projects
    -- this is NOT packer functionality!
    local_plugins = {},
}

local function plugins(use)
    -- Packer can manage itself as an optional plugin
    use({ "wbthomason/packer.nvim", opt = true })

    use({ "nvim-lua/plenary.nvim", module = "plenary" })
    use({ "nvim-lua/popup.nvim", module = "popup" })

    -- LSP
    use({
        "neovim/nvim-lspconfig",
        config = function()
            require("polarmutex.config.lsp")
        end,
        requires = {
            "folke/lua-dev.nvim",
            "jose-elias-alvarez/null-ls.nvim",
            "jose-elias-alvarez/nvim-lsp-ts-utils",
        },
    })

    -- Lsp Comptetion
    use({
        "hrsh7th/nvim-compe",
        event = "InsertEnter",
        opt = true,
        config = function()
            require("polarmutex.config.completion")
        end,
        requires = {},
    })

    -- Tree Sitter
    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        requires = {
            { "nvim-treesitter/playground", cmd = "TSHighlightCapturesUnderCursor" },
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        config = function()
            require("polarmutex.config.treesitter")
        end,
    })

    -- Fuzzy Finder
    use({
        "nvim-telescope/telescope.nvim",
        config = function()
            require("polarmutex.config.telescope")
        end,
        --keys = { "<leader><space>", "<leader>fz", "<leader>pp" },
        requires = {
            "nvim-telescope/telescope-project.nvim",
            "nvim-lua/popup.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-symbols.nvim",
            "nvim-telescope/telescope-fzy-native.nvim",
        },
    })

    -- Git
    use({
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("polarmutex.config.gitsigns")
        end,
    })
    use({
        "TimUntersberger/neogit",
        cmd = "Neogit",
        config = function()
            require("polarmutex.config.neogit")
        end,
    })
    use({
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
        config = function()
            --require("polarmutex.config.diffview")
        end,
    })

    -- Key Mappings
    use({
        "folke/which-key.nvim",
        event = "VimEnter",
        config = function()
            require("polarmutex.config.which-key")
        end,
    })

    -- Dashboard
    use({
        "glepnir/dashboard-nvim",
        config = function()
            require("polarmutex.config.dashboard")
        end,
    })

    -- Undo
    use({ "mbbill/undotree", cmd = "UndotreeToggle" })

    use({
        "RRethy/vim-illuminate",
        event = "CursorHold",
        module = "illuminate",
        config = function()
            vim.g.Illuminate_delay = 1000
        end,
    })
end

return packer.setup(config, plugins)
