local actions = require("telescope.actions")
local themes = require("telescope.themes")

local M = {}

-- GIT
M.git_files = function()
    local opts = themes.get_dropdown({
        winblend = 10,
        border = true,
        previewer = false,
        shorten_path = false,
    })

    require("telescope.builtin").git_files(opts)
end
M.git_branches = function() require("telescope.builtin").git_branches({}) end
M.git_commits = function() require("telescope.builtin").git_commits({}) end
M.git_bcommits = function() require("telescope.builtin").git_bcommits({}) end
M.gh_pull_request = function() require("telescope").extensions.octo.prs({}) end
M.gh_issues = function() require("telescope").extensions.octo.issues({}) end
M.git_worktrees = function()
    local opts = themes.get_dropdown({
        winblend = 10,
        border = true,
        previewer = false,
        shorten_path = false,
    })
    require("telescope").extensions.git_worktree.git_worktrees(opts)
end
M.git_worktree_create = function()
    local opts = themes.get_dropdown({
        winblend = 10,
        border = true,
        previewer = false,
        shorten_path = false,
    })
    require("telescope").extensions.git_worktree.create_git_worktree(opts)
end

-- Files / Meta
M.nvim_dotfiles = function()
    require("telescope.builtin").find_files({
        prompt_title = "~ dotfiles ~",
        shorten_path = false,
        cwd = "~/.config/nvim",

        layout_strategy = "horizontal",
        layout_config = {preview_width = 0.65},
    })
end
M.builtin = function() require("telescope.builtin").builtin() end
M.fd = function() require("telescope.builtin").fd() end
M.buffers = function()
    local opts = {}
    require("telescope.builtin").buff(opts)
end
M.current_buffers = function()
    local opts = {winblend = 10, previewer = false, shorten_path = false}
    require("telescope.builtin").current_buffer_fuzzy_find(opts)
end
M.live_grep = function()
    require("telescope").extensions.fzf_writer.staged_grep(
        {shorten_path = true, previewer = false, fzf_separator = "|>"})
end
M.grep_last_search = function(opts)
    opts = opts or {}

    -- \<getreg\>\C
    -- -> Subs out the search things
    local register = vim.fn.getreg("/"):gsub("\\<", ""):gsub("\\>", ""):gsub("\\C", "")

    opts.shorten_path = true
    opts.word_match = "-w"
    opts.search = register

    require("telescope.builtin").grep_string(opts)
end

-- LSP
M.lsp_code_actions = function()
    local opts = themes.get_dropdown({
        winblend = 10,
        border = true,
        previewer = false,
        shorten_path = false,
    })

    require("telescope.builtin").lsp_code_actions(opts)
end

-- Plugins
function M.installed_plugins()
    require("telescope.builtin").find_files({
        cwd = vim.fn.stdpath("data") .. "/site/pack/packer/start/",
    })
end

-- Neovim
M.help_tags = function()
    local opts = {show_version = true}
    require("telescope.builtin").help_tags(opts)
end

return setmetatable({}, {
    __index = function(_, k)
        if M[k] then
            return M[k]
        else
            return require("telescope.builtin")[k]
        end
    end,
})
