AddKeyOpts = function(keys, opts)
  return vim.tbl_map(function(key)
    if type(key[#key]) == "table" then
      key[#key] = vim.tbl_deep_extend("keep", key[#key], opts)
    end
    return key
  end, keys)
end

-- require("polar.core.ui.statusline")
-- require("polar.core.ui.winbar")
require("polar.core.ui.statuscolumn")

require("polar.config.options")
require("polar.config.keymaps")
require("polar.config.autocmds")

-- require("kanagawa").setup({
--     commentStyle = { italic = true },
--     theme = "wave",
-- })

-- require("tokyonight").setup({
--     style = "moon",
--     transparent = false,
--     ---@param highlights tokyonight.Highlights
--     ---@param colors ColorScheme
--     on_highlights = function(highlights, colors)
--         highlights["StlModeNormal"] = { fg = colors.black, bg = colors.blue, bold = true }
--         highlights["StlModeInsert"] = { fg = colors.black, bg = colors.green, bold = true }
--         highlights["StlModeVisual"] = { fg = colors.black, bg = colors.magenta, bold = true }
--         highlights["StlModeReplace"] = { fg = colors.black, bg = colors.red, bold = true }
--         highlights["StlModeCommand"] = { fg = colors.black, bg = colors.yellow, bold = true }
--         highlights["StlModeTerminal"] = { fg = colors.black, bg = colors.green1, bold = true }
--         highlights["StlModePending"] = { fg = colors.black, bg = colors.red, bold = true }
--
--         highlights["StlModeSepNormal"] = { fg = colors.blue, bg = colors.bg_statusline }
--         highlights["StlModeSepInsert"] = { fg = colors.green, bg = colors.bg_statusline }
--         highlights["StlModeSepVisual"] = { fg = colors.magenta, bg = colors.bg_statusline }
--         highlights["StlModeSepReplace"] = { fg = colors.red, bg = colors.bg_statusline }
--         highlights["StlModeSepCommand"] = { fg = colors.yellow, bg = colors.bg_statusline }
--         highlights["StlModeSepTerminal"] = { fg = colors.green1, bg = colors.bg_statusline }
--         highlights["StlModeSepPending"] = { fg = colors.red, bg = colors.bg_statusline }
--
--         highlights["StlIcon"] = { fg = colors.fg, bg = colors.bg_statusline }
--
--         highlights["StlComponentInactive"] = { fg = colors.bg_statusline, bg = colors.bg_statusline }
--         highlights["StlComponentOn"] = { fg = colors.green, bg = colors.bg_statusline }
--         highlights["StlComponentOff"] = { fg = colors.red, bg = colors.bg_statusline }
--
--         highlights["StlDiagnosticError"] = { fg = colors.error, bg = colors.bg_statusline }
--         highlights["StlDiagnosticWarn"] = { fg = colors.warning, bg = colors.bg_statusline }
--         highlights["StlDiagnosticInfo"] = { fg = colors.info, bg = colors.bg_statusline }
--         highlights["StlDiagnosticHint"] = { fg = colors.hint, bg = colors.bg_statusline }
--
--         highlights["StlSearchCnt"] = { fg = colors.orange, bg = colors.bg_statusline }
--
--         highlights["StlMacroRecording"] = "StlComponentOff"
--         highlights["StlMacroRecorded"] = "StlComponentOn"
--
--         highlights["StlFiletype"] = { fg = colors.fg, bg = colors.bg_statusline }
--
--         highlights["StlLocComponent"] = "StlModeNormal"
--         highlights["StlLocComponentSep"] = "StlModeSepNormal"
--
--         highlights["WinbarHeader"] = { fg = colors.fg, bg = colors.blue0 }
--         highlights["WinbarTriangleSep"] = { fg = colors.blue0 }
--         highlights["WinbarModified"] = { fg = colors.fg, bg = colors.bg }
--         highlights["WinbarError"] = { fg = colors.error, bg = colors.bg }
--         highlights["WinbarWarn"] = { fg = colors.warning, bg = colors.bg }
--         highlights["WinbarSpecialIcon"] = { fg = colors.fg, bg = colors.bg }
--         highlights["WinbarPathPrefix"] = { fg = colors.fg, bg = colors.bg, bold = true }
--     end,
-- })

-- vim.cmd([[colorscheme kanagawa]])
-- vim.cmd([[colorscheme tokyonight]])

-- require("diffview").setup()

vim.filetype.add({
  extension = {
    -- cxx = 'cpp', -- avro

    -- NOTE: Example for a more complex filetype detection...
    -- SEE: https://www.reddit.com/r/neovim/comments/rvwsl3/introducing_filetypelua_and_a_call_for_help/
    -- h = function()
    --   -- Use a lazy heuristic that #including a C++ header means it's a
    --   -- C++ header
    --   if vim.fn.search('\\C^#include <[^>.]\\+>$', 'nw') == 1 then
    --     return 'cpp'
    --   end
    --   return 'c'
    -- end,
  },
})

-- local gwt = require("git-worktree")
--gwt.setup({})

-- require("telescope").load_extension("git_worktree")

-- local Hooks = require("git-worktree.hooks")
-- Hooks.register(Hooks.type.SWITCH, Hooks.builtins.update_current_buffer_on_switch)

-- require("hardtime").setup({
--     enabled = false,
--     disabled_filetypes = {},
-- })
-- require("precognition").setup({ startVisible = false })

-- vim.keymap.set("n", "<leader>hh", function()
--     require("precognition").toggle()
--     require("hardtime").toggle()
-- end, { desc = "[S]earch [H]elp" })

-- require("harpoon").setup({})

-- require("inc_rename").setup()

-- local obsidian = require("obsidian")
-- local Path = require("obsidian.path")

-- local ws = {}

-- local p = Path.new("~/repos/personal/obsidian-second-brain/main"):resolve()
-- if p:exists() then
--     table.insert(ws, { name = "main", path = "~/repos/personal/obsidian-second-brain/main" })
-- end

-- if ws[1] ~= nil then
--     -- A list of workspace names, paths, and configuration overrides.
--     -- If you use the Obsidian app, the 'path' of a workspace should generally be
--     -- your vault root (where the `.obsidian` folder is located).
--     -- When obsidian.nvim is loaded by your plugin manager, it will automatically set
--     -- the workspace to the first workspace in the list whose `path` is a parent of the
--     -- current markdown file being edited.
--     obsidian.setup({
--         workspaces = ws,
--
--         -- Optional, set the log level for obsidian.nvim. This is an integer corresponding to one of the log
--         -- levels defined by "vim.log.levels.*".
--         -- log_level = vim.log.levels.INFO,
--
--         -- daily_notes = {
--         --     -- Optional, if you keep daily notes in a separate directory.
--         --     folder = "notes/dailies",
--         --     -- Optional, if you want to change the date format for the ID of daily notes.
--         --     date_format = "%Y-%m-%d",
--         --     -- Optional, if you want to change the date format of the default alias of daily notes.
--         --     alias_format = "%B %-d, %Y",
--         --     -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
--         --     template = nil,
--         -- },
--
--         -- Optional, completion of wiki links, local markdown links, and tags using nvim-cmp.
--         completion = {
--             -- Set to false to disable completion.
--             nvim_cmp = false, -- TODO
--             -- Trigger completion at 2 chars.
--             min_chars = 2,
--         },
--
--         -- Where to put new notes. Valid options are
--         --  * "current_dir" - put new notes in same directory as the current buffer.
--         --  * "notes_subdir" - put new notes in the default notes subdirectory.
--         -- new_notes_location = "notes_subdir",
--
--         -- Optional, for templates (see below).
--         -- templates = {
--         --     subdir = "templates",
--         --     date_format = "%Y-%m-%d",
--         --     time_format = "%H:%M",
--         --     -- A map for custom variables, the key should be the variable and the value a function
--         --     substitutions = {},
--         -- },
--
--         -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
--         -- open_app_foreground = false,
--
--         -- Optional, sort search results by "path", "modified", "accessed", or "created".
--         -- The recommend value is "modified" and `true` for `sort_reversed`, which means, for example,
--         -- that `:ObsidianQuickSwitch` will show the notes sorted by latest modified time
--         sort_by = "modified",
--         sort_reversed = true,
--
--         -- Optional, determines how certain commands open notes. The valid options are:
--         -- 1. "current" (the default) - to always open in the current window
--         -- 2. "vsplit" - to open in a vertical split if there's not already a vertical split
--         -- 3. "hsplit" - to open in a horizontal split if there's not already a horizontal split
--         -- open_notes_in = "current",
--     })
-- end

-- require("overseer").setup({
--     task_list = {
--         direction = "bottom",
--         min_height = 25,
--         max_height = 25,
--         default_detail = 1,
--         bindings = {
--             ["q"] = function()
--                 vim.cmd("OverseerClose")
--             end,
--         },
--     },
-- })

-- require("polar.lazy").finish()

-- require("polar.utils.format").setup()

-- require("polar.lsp").setup()

-- require("polar.health").loaded = true
