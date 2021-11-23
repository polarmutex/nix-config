local util = require("polarmutex.util")
local wk = require("which-key")

vim.o.timeoutlen = 300

wk.setup({
    plugins = {
        marks = false, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        spelling = {
            enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 20, -- how many suggestions should be shown in the list?
        },
        presets = {
            operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
            motions = true, -- adds help for motions
            text_objects = true, -- help for text objects triggered after entering an operator
            windows = true, -- default bindings on <c-w>
            nav = true, -- misc bindings to work with windows
            z = true, -- bindings for folds, spelling and others prefixed with z
            g = true, -- bindings for prefixed with g
        },
    },
    -- add operators that will trigger motion and text object completion
    -- to enable all native operators, set the preset / operators plugin above
    operators = { gc = "Comments" },
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
    },
    window = {
        border = "none", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
    },
    layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
    },
    ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
    show_help = true, -- show help message on the command line when the popup is visible
    triggers = "auto", -- automatically setup triggers
    -- triggers = {"<leader>"} -- or specifiy a list manually
})

-- Move to window using the <ctrl> movement keys
--util.nmap("<left>", "<C-w>h")
--util.nmap("<down>", "<C-w>j")
--util.nmap("<up>", "<C-w>k")
--util.nmap("<right>", "<C-w>l")

-- Resize window using <ctrl> arrow keys
util.nnoremap("<S-Up>", ":resize +2<CR>")
util.nnoremap("<S-Down>", ":resize -2<CR>")
util.nnoremap("<S-Left>", ":vertical resize -2<CR>")
util.nnoremap("<S-Right>", ":vertical resize +2<CR>")

-- Move Lines
util.nnoremap("<A-j>", ":m .+1<CR>==")
util.vnoremap("<A-j>", ":m '>+1<CR>gv=gv")
util.inoremap("<A-j>", "<Esc>:m .+1<CR>==gi")
util.nnoremap("<A-k>", ":m .-2<CR>==")
util.vnoremap("<A-k>", ":m '<-2<CR>gv=gv")
util.inoremap("<A-k>", "<Esc>:m .-2<CR>==gi")

-- Switch buffers with tab
--util.nnoremap("<C-Left>", ":bprevious<cr>")
--util.nnoremap("<C-Right>", ":bnext<cr>")

-- Easier pasting
--util.nnoremap("[p", ":pu!<cr>")
--util.nnoremap("]p", ":pu<cr>")

-- Clear search with <esc>
util.map("", "<esc>", ":noh<cr>")

-- better indenting
util.vnoremap("<", "<gv")
util.vnoremap(">", ">gv")

-- Debugging
util.nnoremap("<F5>", ':lua require("dap").continue()<CR>')
util.nnoremap("<F10>", ':lua require("dap").step_over()<CR>')
util.nnoremap("<F11>", ':lua require("dap").step_into()<CR>')

local leader = {
    ["w"] = {
        name = "+windows",
        ["w"] = { "<C-W>p", "other-window" },
        ["d"] = { "<C-W>c", "delete-window" },
        ["-"] = { "<C-W>s", "split-window-below" },
        ["|"] = { "<C-W>v", "split-window-right" },
        ["2"] = { "<C-W>v", "layout-double-columns" },
        ["h"] = { "<C-W>h", "window-left" },
        ["j"] = { "<C-W>j", "window-below" },
        ["l"] = { "<C-W>l", "window-right" },
        ["k"] = { "<C-W>k", "window-up" },
        ["H"] = { "<C-W>5<", "expand-window-left" },
        ["J"] = { ":resize +5", "expand-window-below" },
        ["L"] = { "<C-W>5>", "expand-window-right" },
        ["K"] = { ":resize -5", "expand-window-up" },
        ["="] = { "<C-W>=", "balance-window" },
        ["s"] = { "<C-W>s", "split-window-below" },
        ["v"] = { "<C-W>v", "split-window-right" },
    },
    b = {
        name = "+buffer",
        ["b"] = { "<cmd>:e #<cr>", "Switch to Other Buffer" },
        ["p"] = { "<cmd>:BufferLineCyclePrev<CR>", "Previous Buffer" },
        ["["] = { "<cmd>:BufferLineCyclePrev<CR>", "Previous Buffer" },
        ["n"] = { "<cmd>:BufferLineCycleNext<CR>", "Next Buffer" },
        ["]"] = { "<cmd>:BufferLineCycleNext<CR>", "Next Buffer" },
        ["d"] = { "<cmd>:bd<CR>", "Delete Buffer" },
        ["g"] = { "<cmd>:BufferLinePick<CR>", "Goto Buffer" },
    },
    d = {
        name = "+debug",
        h = { ':lua require("dap.ui.variables").hover()<CR>', "hover variables" },
        r = { ':lua require("dap.repl").open()<CR>', "Open REPL" },
        p = {
            ":lua require('plenary.reload').reload_module('contextprint'); require('contextprint').add_statement()<CR>",
            "add context print statement",
        },
    },
    g = {
        name = "+git",
        g = { "<cmd>Neogit<CR>", "NeoGit" },
        l = {
            function()
                require("polarmutex.util").float_terminal("lazygit")
            end,
            "LazyGit",
        },
        c = { "<Cmd>Telescope git_commits<CR>", "commits" },
        b = { "<Cmd>Telescope git_branches<CR>", "branches" },
        s = { "<Cmd>Telescope git_status<CR>", "status" },
        d = { "<cmd>DiffviewOpen<cr>", "DiffView" },
        w = {
            name = "+git worktrees",
            w = { "<cmd>Telescope git_worktree git_worktrees<CR>", "Switch/Delete" },
            c = { "<cmd>Telescope git_worktree create_git_worktree<CR>", "Create" },
        },
        h = { name = "+hunk" },
    },
    ["h"] = {
        name = "+help",
        t = { "<cmd>:Telescope builtin<cr>", "Telescope" },
        c = { "<cmd>:Telescope commands<cr>", "Commands" },
        h = { "<cmd>:Telescope help_tags<cr>", "Help Pages" },
        m = { "<cmd>:Telescope man_pages<cr>", "Man Pages" },
        k = { "<cmd>:Telescope keymaps<cr>", "Key Maps" },
        s = { "<cmd>:Telescope highlights<cr>", "Search Highlight Groups" },
        l = { [[<cmd>TSHighlightCapturesUnderCursor<cr>]], "Highlight Groups at cursor" },
        f = { "<cmd>:Telescope filetypes<cr>", "File Types" },
        o = { "<cmd>:Telescope vim_options<cr>", "Options" },
        a = { "<cmd>:Telescope autocommands<cr>", "Auto Commands" },
        p = {
            name = "+packer",
            p = { "<cmd>PackerSync<cr>", "Sync" },
            s = { "<cmd>PackerStatus<cr>", "Status" },
            i = { "<cmd>PackerInstall<cr>", "Install" },
            c = { "<cmd>PackerCompile<cr>", "Compile" },
        },
    },
    m = {
        name = "+beancount",
        c = { ":%s/txn/*/gc<CR>", "Maked as reconsiled" },
        t = {
            ":lua require('plenary.reload').reload_module('beancount'); require('beancount').CopyTransaction()<CR>",
            "copy transactions",
        },
    },
    u = { "<cmd>UndotreeToggle<CR>", "Undo Tree" },
    s = {
        name = "+search",
        g = { "<cmd>Telescope live_grep<cr>", "Grep" },
        b = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Buffer" },
        s = {
            function()
                require("telescope.builtin").lsp_document_symbols({
                    symbols = { "Class", "Function", "Method", "Constructor", "Interface", "Module" },
                })
            end,
            "Goto Symbol",
        },
        h = { "<cmd>Telescope command_history<cr>", "Command History" },
        m = { "<cmd>Telescope marks<cr>", "Jump to Mark" },
        r = { "<cmd>lua require('spectre').open()<CR>", "Replace (Spectre)" },
    },
    f = {
        name = "+file",
        f = { "<cmd>Telescope find_files<cr>", "Find File" },
        t = { ':lua require("harpoon.ui").nav_file(1)', "harpoon nav file 1" },
        s = { ':lua require("harpoon.ui").nav_file(2)', "harpoon nav file 2" },
        r = { ':lua require("harpoon.ui").nav_file(3)', "harpoon nav file 3" },
        n = { ':lua require("harpoon.ui").nav_file(4)', "harpoon nav file 4" },
        a = { ':lua require("harpoon.mark").add_file()<CR><cr>', "harpoon add file" },
        u = { ':lua require("harpoon.ui").toggle_quick_menu()<cr>', "harpoon ui toggle" },
    },
    p = {
        name = "+project",
        p = "Open Project",
        b = { ":Telescope file_browser cwd=~/projects<CR>", "Browse ~/projects" },
    },
    t = {
        name = "toggle",
        b = { ':lua require("dap").toggle_breakpoint()<CR>', "toggle breakpoint" },
        f = {
            require("polarmutex.config.lsp.formatting").toggle,
            "Format on Save",
        },
        s = {
            function()
                util.toggle("spell")
            end,
            "Spelling",
        },
        w = {
            function()
                util.toggle("wrap")
            end,
            "Word Wrap",
        },
        n = {
            function()
                util.toggle("relativenumber", true)
                util.toggle("number")
            end,
            "Line Numbers",
        },
    },
    [" "] = "Find File",
    ["."] = { ":Telescope file_browser<CR>", "Browse Files" },
    [","] = { "<cmd>Telescope buffers show_all_buffers=true<cr>", "Switch Buffer" },
    ["/"] = { "<cmd>Telescope live_grep<cr>", "Search" },
    [":"] = { "<cmd>Telescope command_history<cr>", "Command History" },
    ["*"] = { ":%s/<c-r><c-w>//g<left><left>", "replace word under cursor" },
    q = {
        name = "+quit/session",
        q = { "<cmd>:qa<cr>", "Quit" },
        ["!"] = { "<cmd>:qa!<cr>", "Quit without saving" },
        s = { [[<cmd>lua require("persistence").load()<cr>]], "Restore Session" },
        l = { [[<cmd>lua require("persistence").load({last=true})<cr>]], "Restore Last Session" },
        d = { [[<cmd>lua require("persistence").stop()<cr>]], "Stop Current Session" },
    },
    x = {
        name = "+errors",
        x = { "<cmd>TroubleToggle<cr>", "Trouble" },
        w = { "<cmd>TroubleWorkspaceToggle<cr>", "Workspace Trouble" },
        d = { "<cmd>TroubleDocumentToggle<cr>", "Document Trouble" },
        t = { "<cmd>TodoTrouble<cr>", "Todo Trouble" },
        T = { "<cmd>TodoTelescope<cr>", "Todo Telescope" },
        l = { "<cmd>lopen<cr>", "Open Location List" },
        q = { "<cmd>copen<cr>", "Open Quickfix List" },
    },
    D = {
        function()
            util.docs()
        end,
        "Create Docs from README.md",
    },
}

for i = 0, 10 do
    leader[tostring(i)] = "which_key_ignore"
end

wk.register(leader, { prefix = "<leader>" })
