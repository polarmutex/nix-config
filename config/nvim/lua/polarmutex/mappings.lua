local wk = require("which-key")

local leader = {
    ["w"] = {
        name = "+windows",
        ["w"] = {"<C-W>p", "other-window"},
        ["d"] = {"<C-W>c", "delete-window"},
        ["-"] = {"<C-W>s", "split-window-below"},
        ["|"] = {"<C-W>v", "split-window-right"},
        ["2"] = {"<C-W>v", "layout-double-columns"},
        ["h"] = {"<C-W>h", "window-left"},
        ["j"] = {"<C-W>j", "window-below"},
        ["l"] = {"<C-W>l", "window-right"},
        ["k"] = {"<C-W>k", "window-up"},
        ["H"] = {"<C-W>5<", "expand-window-left"},
        ["J"] = {":resize +5", "expand-window-below"},
        ["L"] = {"<C-W>5>", "expand-window-right"},
        ["K"] = {":resize -5", "expand-window-up"},
        ["="] = {"<C-W>=", "balance-window"},
        ["s"] = {"<C-W>s", "split-window-below"},
        ["v"] = {"<C-W>v", "split-window-right"}
    },
    b = {
        name = "+buffer",
        ["b"] = {"<cmd>:e #<cr>", "Switch to Other Buffer"},
        ["p"] = {"<cmd>:BufferLineCyclePrev<CR>", "Previous Buffer"},
        ["["] = {"<cmd>:BufferLineCyclePrev<CR>", "Previous Buffer"},
        ["n"] = {"<cmd>:BufferLineCycleNext<CR>", "Next Buffer"},
        ["]"] = {"<cmd>:BufferLineCycleNext<CR>", "Next Buffer"},
        ["d"] = {"<cmd>:bd<CR>", "Delete Buffer"},
        ["g"] = {"<cmd>:BufferLinePick<CR>", "Goto Buffer"}
    },
    g = {
        name = "+git",
        g = {"<cmd>Neogit<CR>", "NeoGit"},
        l = {
            function()
                require"util".float_terminal("lazygit")
            end, "LazyGit"
        },
        c = {"<Cmd>Telescope git_commits<CR>", "commits"},
        b = {"<Cmd>Telescope git_branches<CR>", "branches"},
        s = {"<Cmd>Telescope git_status<CR>", "status"},
        d = {"<cmd>DiffviewOpen<cr>", "DiffView"},
        i = {":lua require(\"polarmutex.plugins.telescope\").gh_issues()<CR>"},
        h = {name = "+hunk"}
    },
    ["h"] = {
        name = "+help",
        t = {"<cmd>:Telescope builtin<cr>", "Telescope"},
        c = {"<cmd>:Telescope commands<cr>", "Commands"},
        h = {"<cmd>:Telescope help_tags<cr>", "Help Pages"},
        m = {"<cmd>:Telescope man_pages<cr>", "Man Pages"},
        k = {"<cmd>:Telescope keymaps<cr>", "Key Maps"},
        s = {"<cmd>:Telescope highlights<cr>", "Search Highlight Groups"},
        l = {[[<cmd>TSHighlightCapturesUnderCursor<cr>]], "Highlight Groups at cursor"},
        f = {"<cmd>:Telescope filetypes<cr>", "File Types"},
        o = {"<cmd>:Telescope vim_options<cr>", "Options"},
        a = {"<cmd>:Telescope autocommands<cr>", "Auto Commands"},
        p = {
            name = "+packer",
            p = {"<cmd>PackerSync<cr>", "Sync"},
            s = {"<cmd>PackerStatus<cr>", "Status"},
            i = {"<cmd>PackerInstall<cr>", "Install"},
            c = {"<cmd>PackerCompile<cr>", "Compile"}
        }
    },
    u = {"<cmd>UndotreeToggle<CR>", "Undo Tree"},
    s = {
        name = "+search",
        g = {"<cmd>Telescope live_grep<cr>", "Grep"},
        b = {"<cmd>Telescope current_buffer_fuzzy_find<cr>", "Buffer"},
        s = {"<cmd>Telescope lsp_document_symbols<cr>", "Goto Symbol"},
        h = {"<cmd>Telescope command_history<cr>", "Command History"},
        m = {"<cmd>Telescope marks<cr>", "Jump to Mark"},
        r = {"<cmd>lua require('spectre').open()<CR>", "Replace (Spectre)"},
        d = {
            ":lua require(\"polarmutex.plugins.telescope\").nvim_dotfiles()<CR>",
            "Search dotfiles"
        }

    },
    f = {
        name = "+file",
        t = {"<cmd>NvimTreeToggle<cr>", "NvimTree"},
        f = {"<cmd>Telescope find_files<cr>", "Find File"},
        r = {"<cmd>Telescope oldfiles<cr>", "Open Recent File"},
        n = {"<cmd>enew<cr>", "New File"},
        z = "Zoxide",
        d = "Dot Files"
    },
    o = {
        name = "+open",
        p = {"<cmd>MarkdownPreview<cr>", "Markdown Preview"},
        g = {"<cmd>Glow<cr>", "Markdown Glow"}
    },
    p = {
        name = "+project",
        p = "Open Project",
        b = {":Telescope file_browser cwd=~/repos<CR>", "Browse ~/repos"}
    },
    t = {
        name = "+tabs",
        t = {"<cmd>tabnew<CR>", "New Tab"},
        n = {"<cmd>tabnext<CR>", "Next"},
        d = {"<cmd>tabclose<CR>", "Close"},
        p = {"<cmd>tabprevious<CR>", "Previous"},
        ["]"] = {"<cmd>tabnext<CR>", "Next"},
        ["["] = {"<cmd>tabprevious<CR>", "Previous"},
        f = {"<cmd>tabfirst<CR>", "First"},
        l = {"<cmd>tablast<CR>", "Last"}
    },
    ["`"] = {"<cmd>:e #<cr>", "Switch to Other Buffer"},
    [" "] = "Find File",
    ["."] = {":Telescope file_browser<CR>", "Browse Files"},
    [","] = {"<cmd>Telescope buffers show_all_buffers=true<cr>", "Switch Buffer"},
    ["/"] = {"<cmd>Telescope live_grep<cr>", "Search"},
    [":"] = {"<cmd>Telescope command_history<cr>", "Command History"},
    q = {
        name = "+quit/session",
        q = {"<cmd>:qa<cr>", "Quit"},
        ["!"] = {"<cmd>:qa!<cr>", "Quit without saving"},
        s = {[[<cmd>lua require("config.session").load()<cr>]], "Restore Session"},
        l = {
            [[<cmd>lua require("config.session").load({last=true})<cr>]],
            "Restore Last Session"
        },
        d = {[[<cmd>lua require("config.session").stop()<cr>]], "Stop Current Session"}
    },
    x = {
        name = "+errors",
        x = {"<cmd>LspTroubleToggle<cr>", "Trouble"},
        w = {"<cmd>LspTroubleWorkspaceToggle<cr>", "Workspace Trouble"},
        d = {"<cmd>LspTroubleDocumentToggle<cr>", "Document Trouble"},
        l = {"<cmd>lopen<cr>", "Open Location List"},
        q = {"<cmd>copen<cr>", "Open Quickfix List"}
    },
    m = {
        name = "+beancount",
        c = {":%s/txn/*/gc<CR>", "changet uncleared transactions"},
        t = {
            ":lua require('plenary.reload').reload_module('beancount'); require('beancount').CopyTransaction()<CR>",
            "find tranctions to copy"
        }
    }
}

for i = 0, 10 do
    leader[tostring(i)] = "which_key_ignore"
end

wk.register(leader, {prefix = "<leader>"})

wk.register({g = {name = "+goto", h = "Hop Word"}, s = "Hop Word1"})

-- LSP
-- {n, "K", "<cmd>lua vim.lsp.buf.hover()<cr>", silent},
-- {n, "g0", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", silent},
-- {n, "gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", silent},
-- {n, "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", silent},
-- {n, "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", silent},

-- Testing
-- {n, "<F5>", ":lua require(\"dap\").continue()<CR>", silent},
-- {n, "<F10>", ":lua require(\"dap\").step_over()<CR>", silent},
-- {n, "<leader>db", ":lua require(\"dap\").toggle_breakpoint()<CR>", silent},
-- {n, "<leader>dr", ":lua require(\"dap.repl\").open()<CR>", silent},
-- {n, "<leader>dh", ":lua require(\"dap.ui.variables\").hover()<CR>", silent},

-- Harpoon
-- {n, "<leader>te", ":lua require(\"harpoon.term\").gotoTerminal(2)<CR>"},
-- {n, "<leader>ce", ":lua require(\"harpoon.term\").sendCommand(1, 2)<CR>"},
-- {n, "<leader>tu", ":lua require(\"harpoon.term\").gotoTerminal(1)<CR>"},
-- {n, "<leader>cu", ":lua require(\"harpoon.term\").sendCommand(1, 1)<CR>"}, {
--    n, "<leader>cp",
--    ":lua require('plenary.reload').reload_module('contextprint'); require('contextprint').add_statement()<CR>",
-- },
-- {n, "<leader>hp", "<cmd>lua require(\"gitsigns\").preview_hunk()<CR>"},
-- {n, "<leader>hr", "<cmd>lua require(\"gitsigns\").reset_hunk()<CR>"},
-- {n, "<leader>hR", "<cmd>lua require(\"gitsigns\").reset_buffer()<CR>"},
-- {n, "<leader>hs", "<cmd>lua require(\"gitsigns\").stage_hunk()<CR>"},
-- {n, "<leader>hu", "<cmd>lua require(\"gitsigns\").undo_stage_hunk()<CR>"},
-- {n, "<leader>gw", "<cmd>lua require(\"polarmutex.plugins.telescope\").git_worktrees()<CR>"},
-- {n, "<leader>gwc","<cmd>lua require(\"polarmutex.plugins.telescope\").git_worktree_create()<CR>"},

-- }, {n, "<leader>sf", ":lua require(\"polarmutex.plugins.telescope\").fd()<CR>"},
-- " Use alt + hjkl to resize windows
-- {n, "<M-j>", ":resize -3<CR>"}, {n, "<M-k>", ":resize +3<CR>"},
-- {n, "<M-h>", ":vertical resize -3<CR>"}, {n, "<M-l>", ":vertical resize +3<CR>"}, -- " visual move and highligh
-- " from the Primeagen
-- {n, "<C-j>", ":m .+1<CR>==", silent}, {n, "<C-k>", ":m .-2<CR>==", silent},
-- {v, "<C-j>", ":m '>+1<CR>gv=gv", silent}, {v, "<C-k>", ":m '<-2<CR>gv=gv", silent}, -- Allow ESC to leave terminal
-- {t, "<Esc>", "<C-\\><C-n>"}, -- "tab management with t leader
-- {n, "tn", ":tabnew<CR>"}, {n, "tq", ":tabclose<CR>"}, -- Save and Quit
-- {n, "<leader>w", ":w<cr>"}, {n, "<leader>q", ":q<cr>"},

-- Replace the word under cursor
-- {n, "<leader>*", ":%s/<c-r><c-w>//g<left><left>"},
