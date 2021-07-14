local actions = require("telescope.actions")
local sorters = require("telescope.sorters")

require("telescope").setup({
    defaults = {
        prompt_prefix = " >",

        winblend = 0,
        preview_cutoff = 120,

        scroll_strategy = "cycle",
        layout_strategy = "vertical",
        layout_defaults = {
            horizontal = {
                width_padding = 0.1,
                height_padding = 0.1,
                preview_width = 0.6,
            },
            vertical = { width_padding = 0.05, height_padding = 1, preview_height = 0.5 },
        },

        sorting_strategy = "descending",
        prompt_position = "bottom",
        color_devicons = true,

        mappings = { i = { ["<c-x>"] = false, ["<C-q>"] = actions.send_to_qflist } },

        borderchars = {
            { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        },

        file_sorter = sorters.get_fzy_sorter,

        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    },

    extensions = {
        fzy_native = { override_generic_sorter = false, override_file_sorter = true },

        fzf_writer = { use_highlighter = false, minimum_grep_characters = 4 },
    },
})

-- Load the fzy native extension at the start.
require("telescope").load_extension("fzy_native")
require("telescope").load_extension("octo")
require("telescope").load_extension("dap")
require("telescope").load_extension("git_worktree")
