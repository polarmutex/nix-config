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
    use({
        "lewis6991/impatient.nvim",
        config = function()
            require("impatient")
        end,
    })

    -- LSP
    use({
        "neovim/nvim-lspconfig",
        config = function()
            require("polarmutex.config.lsp")
        end,
        requires = {
            "nvim-lua/lsp-status.nvim",
            "folke/lua-dev.nvim",
            "jose-elias-alvarez/null-ls.nvim",
            "jose-elias-alvarez/nvim-lsp-ts-utils",
            "onsails/lspkind-nvim",
        },
    })
    use({
        "folke/trouble.nvim",
        event = "BufReadPre",
        cmd = { "TroubleToggle", "Trouble" },
        config = function()
            require("trouble").setup({ auto_open = false })
        end,
    })
    use({ "mfussenegger/nvim-jdtls" })

    -- Lsp Completion
    use({
        "hrsh7th/nvim-cmp",
        config = function()
            require("polarmutex.config.completion")
        end,
        requires = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-emoji",
            "saadparwaiz1/cmp_luasnip",
        },
    })
    use({ "L3MON4D3/LuaSnip" })

    -- Tree Sitter
    use({
        "nvim-treesitter/nvim-treesitter",
        --run = ":TSUpdate",
        requires = {
            "nvim-treesitter/playground",
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        config = function()
            require("polarmutex.config.treesitter")
        end,
    })
    use({ "polarmutex/contextprint.nvim" })
    use({
        "b3nj5m1n/kommentary",
        opt = true,
        keys = { "gc", "gcc" },
        config = function()
            require("polarmutex.config.comments")
        end,
        requires = "JoosepAlviste/nvim-ts-context-commentstring",
    })

    -- Fuzzy Finder / File / Buffer Nav
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
    use({
        "ThePrimeagen/harpoon",
        config = function()
            require("polarmutex.config.harpoon")
        end,
    })
    --use({
    --    "ggandor/lightspeed.nvim",
    --    event = "BufReadPost",
    --    config = function()
    --        require("polarmutex.config.lightspeed")
    --    end,
    --})

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
            require("diffview").setup({})
        end,
    })
    use({ "ThePrimeagen/git-worktree.nvim" })
    use({ "ruifm/gitlinker.nvim" })
    use({
        "pwntester/octo.nvim",
        config = function()
            require("polarmutex.config.octo")
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

    -- Debugging
    use({
        "mfussenegger/nvim-dap",
        config = function()
            require("nvim-dap-virtual-text").setup()
            require("polarmutex.config.dap")
        end,
        requires = {
            "mfussenegger/nvim-dap-python",
            "mfussenegger/nvim-lua-debugger",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-telescope/telescope-dap.nvim",
        },
    })

    -- statusline
    use({
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
        config = function()
            require("polarmutex.config.statusline")
        end,
    })

    -- Dashboard
    use({
        "goolord/alpha-nvim",
        requires = { "kyazdani42/nvim-web-devicons" },
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

    -- Session
    use({
        "folke/persistence.nvim",
        event = "VimEnter",
        module = "persistence",
        config = function()
            require("persistence").setup()
        end,
    })

    -- Theme
    use({
        "kyazdani42/nvim-web-devicons",
        module = "nvim-web-devicons",
        config = function()
            require("nvim-web-devicons").setup({ default = true })
        end,
    })
    use({
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("polarmutex.config.colorizer")
        end,
    })
    use({
        "norcalli/nvim-terminal.lua",
        ft = "terminal",
        config = function()
            require("terminal").setup()
        end,
    })
    use({
        "lukas-reineke/indent-blankline.nvim",
        event = "BufReadPre",
        config = function()
            require("polarmutex.config.blankline")
        end,
    })
    use({
        "karb94/neoscroll.nvim",
        keys = { "<C-u>", "<C-d>", "gg", "G" },
        config = function()
            require("polarmutex.config.scroll")
        end,
    })
    use({
        "edluffy/specs.nvim",
        after = "neoscroll.nvim",
        config = function()
            require("polarmutex.config.specs")
        end,
    })

    -- Increment / Decrement
    use({
        "monaqa/dial.nvim",
        config = function()
            require("polarmutex.config.dial")
        end,
    })

    -- Beancount
    use({
        "polarmutex/beancount.nvim",
    })

    --delibrate practice
    use({ "ThePrimeagen/vim-be-good" })

    -- utilities
    use({ "tweekmonster/startuptime.vim", cmd = "StartupTime" })
    use({
        "folke/todo-comments.nvim",
        cmd = { "TodoTrouble", "TodoTelescope" },
        event = "BufReadPost",
        config = function()
            require("todo-comments").setup()
        end,
    })
end

return packer.setup(config, plugins)
