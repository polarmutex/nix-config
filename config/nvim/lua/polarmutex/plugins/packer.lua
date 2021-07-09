-- Look into
-- https://github.com/lervag/wiki.vim
-- https://github.com/ihsanturk/neuron.vim
-- https://github.com/kdheepak/lazygit.nvim
-- https://github.com/johannesthyssen/vim-signit
-- https://github.com/kyazdani42/nvim-tree.lua
-- https://github.com/mkitt/tabline.vim
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.cmd("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
    vim.cmd("packadd packer.nvim")
end

vim.cmd [[packadd packer.nvim]]

local packer_ok, packer = pcall(require, "packer")

if packer_ok then

    local use = packer.use
    local local_use = function(first, second)
        local plug_path
        local home

        if second == nil then
            plug_path = first
            home = "polarmutex"
        else
            plug_path = second
            home = first
        end

        if vim.fn.isdirectory(vim.fn.expand("~/repos/" .. plug_path)) == 1 then
            use("~/repos/" .. plug_path)
        elseif vim.fn.isdirectory(vim.fn.expand("~/dev/" .. plug_path)) == 1 then
            use("~/dev/" .. plug_path)
        else
            use(string.format("%s/%s", home, plug_path))
        end
    end

    packer.init {display = {open_fn = require("packer.util").float}}

    local plugins = function()
        -- Packer can manage itself as an optional plugin
        use {
            "wbthomason/packer.nvim",
            opt = true,
            run = function()
                vim.cmd([[PackerCompile]])
            end,
        }

        -- LSP
        use("neovim/nvim-lspconfig")
        use {
            "hrsh7th/nvim-compe",
            config = function()
                require("polarmutex.plugins.completion")
            end
        }
        use("nvim-lua/lsp-status.nvim")
        use {
            "glepnir/lspsaga.nvim",
            config = function()
                require("polarmutex.plugins.lspsaga")
            end
        }
        use {"lspcontainers/lspcontainers.nvim"}
        use("onsails/lspkind-nvim")
        use("kosayoda/nvim-lightbulb")
        use("tjdevries/nlua.nvim")

        -- Tree-Sitter
        use({
            "nvim-treesitter/nvim-treesitter",
            run = function()
                vim.cmd([[TSUpdate]])
            end,
            config = function()
                require("polarmutex.plugins.treesitter")
            end
        })
        -- local_use('polarmutex','nvim-treesitter')
        use("nvim-treesitter/playground")
        -- use 'nvim-treesitter/completion-treesitter'
        local_use("polarmutex", "beancount.nvim")
        local_use("polarmutex", "contextprint.nvim")
        -- haringsrob/nvim_context_vt

        -- Telescope (fuzzy finder)
        use {
            "nvim-telescope/telescope.nvim",
            requires = {
                {"nvim-lua/popup.nvim"}, {"nvim-telescope/telescope-fzy-native.nvim"},
                {"nvim-telescope/telescope-fzf-writer.nvim"},
                {"nvim-telescope/telescope-packer.nvim"},
                {"nvim-telescope/telescope-github.nvim"},
                {"nvim-telescope/telescope-packer.nvim"}
            },
            config = function()
                require("polarmutex.plugins.telescope.config")
            end
        }
        use("kyazdani42/nvim-web-devicons")
        use("phaazon/hop.nvim")

        -- Debug adapter protocol
        use {
            "mfussenegger/nvim-dap",
            config = function()
                require("polarmutex.plugins.dap")
            end
        }
        use("mfussenegger/nvim-dap-python")
        use("mfussenegger/nvim-lua-debugger")
        use("theHamsta/nvim-dap-virtual-text")
        use("nvim-telescope/telescope-dap.nvim")

        -- Terminal / File Nav
        use {
            "ThePrimeagen/harpoon",
            config = function()
                require("polarmutex.plugins.harpoon")
            end
        }
        use {
            "norcalli/nvim-terminal.lua",
            config = function()
                require("polarmutex.plugins.nvim-terminal")
            end
        }

        -- Git
        use {
            "TimUntersberger/neogit",
            config = function()
                require("polarmutex.plugins.neogit")
            end
        }
        use {
            "lewis6991/gitsigns.nvim",
            config = function()
                require("polarmutex.plugins.gitsigns")
            end
        }
        use("pwntester/octo.nvim")
        use("ThePrimeagen/git-worktree.nvim")
        -- use("~/repos/git-worktree.nvim.git/master")
        use({"ruifm/gitlinker.nvim"})

        -- plenary
        use {"nvim-lua/plenary.nvim"}

        -- keymaps
        use {
            "folke/which-key.nvim",
            config = function()
                require("polarmutex.plugins.which-key")
            end
        }
        -- Increment / Decrement
        use {
            "monaqa/dial.nvim",
            config = function()
                require("polarmutex.plugins.dial")
            end
        }

        -- text maniuplation
        use("tpope/vim-surround") -- Surround text objects easily
        use("tpope/vim-commentary") -- Easily comment out lines or objects
        -- use 'tpope/vim-repeat'         -- Repeat actions better
        use("tpope/vim-abolish") -- Cool things with words!

        -- Convert binary, hex, etc..
        use("glts/vim-radical")

        -- Add some color
        use {
            "norcalli/nvim-colorizer.lua",
            opt = false,
            config = function()
                require("polarmutex.plugins.colorizer")
            end
        }

        -- :Messages <- view messages in quickfix list
        -- :Verbose  <- view verbose output in preview window.
        -- :Time     <- measure how long it takes to run some stuff.
        use("tpope/vim-scriptease")

        -- Quickfix enhancements. See :help vim-qf
        -- use 'romainl/vim-qf'

        -- Better profiling output for startup.
        use("tweekmonster/startuptime.vim")

        -- Neovim in the browser
        use({
            "glacambre/firenvim",
            run = function()
                vim.fn["firenvim#install"](0)
            end
        })

        -- Whitespace
        -- do I still want this?
        -- use 'ntpeters/vim-better-whitespace'

        use("RRethy/vim-illuminate")
        -- highlight current word

        -- Undo
        use("mbbill/undotree")

        -- Test
        use("vim-test/vim-test")

        -- Games/ Utils
        use("takac/vim-hardtime")
        use("ThePrimeagen/vim-be-good")
        -- use_local 'vim-be-good'
        -- use 'ThePrimeagen/vim-apm'
        -- local_use('polarmutex','vim-apm')

        -- tasks
        local_use("polarmutex", "tasks.nvim")
    end

    packer.startup(plugins)
end
