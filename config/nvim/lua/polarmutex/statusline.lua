-- local theme = require("polarmutex.colorschemes.gruvbox")
local has_lsp_status, lsp_status = pcall(require, "lsp-status")
local has_path, Path = pcall(require, "plenary.path")
local M = {}

local active_sep = "rounded"

M.separators = {
    arrow = { "", "" },
    normal = { "", "" },
    rounded = { "", "" },
    blanck = { "", "" },
}

M.icons = {
    locked = "🔒",
    unsaved = "",
    warning = "",
    error = "",
    branch = " ",
}

M.colors = {
    active = "%#StatusLine#",
    inactive = "%#StatusLineNC#",
    git = "%#StatusLineGit#",
    green = "%#StatusLineGreen#",
    yellow = "%#StatusLineYellow#",
    red = "%#StatusLineRed#",
    filetype = "%#StatusLineFileType#",
    line_col = "%#StatusLineLineCol#",
    line_col_inv = "%#StatusLineLineColInv#",
}

M.trunc_width = setmetatable({ git_status = 90, filename = 140 }, {
    __index = function()
        return 80
    end,
})

M.is_truncated = function(_, width)
    local current_width = vim.api.nvim_win_get_width(0)
    return current_width < width
end

M.modes = {
    ["n"] = { "N", "Normal", "%#StatusLineModeNormal#", "%#StatusLineModeNormalInv#" },
    ["no"] = { "N·P", "N·Pending", "%#StatusLineModeNormal#", "%#StatusLineModeNormalInv#" },

    ["v"] = { "V", "Visual", "%#StatusLineModeVisual#", "%#StatusLineModeVisualInv#" },
    ["V"] = { "V", "V·Line", "%#StatusLineModeVisual#", "%#StatusLineModeVisualInv#" },
    [""] = { "V", "V·Block", "%#StatusLineModeVisual#", "%#StatusLineModeVisualInv#" },

    ["s"] = { "S", "Select", "%#StatusLineModeSelect#", "%#StatusLineModeSelectInv#" },
    ["S"] = { "S", "S·Line", "%#StatusLineModeSelect#", "%#StatusLineModeSelectInv#" },
    [""] = { "S", "S·Block", "%#StatusLineModeSelect#", "%#StatusLineModeSelectInv#" },

    ["i"] = { "I", "Insert", "%#StatusLineModeInsert#", "%#StatusLineModeInsertInv#" },
    ["ic"] = { "I", "Insert", "%#StatusLineModeInsert#", "%#StatusLineModeInsertInv#" },

    ["R"] = { "R", "Replace", "%#StatusLineModeReplace#", "%#StatusLineModeReplaceInv#" },
    ["Rv"] = { "V", "V·Replace", "%#StatusLineModeReplace#", "%#StatusLineModeReplaceInv#" },

    ["c"] = { "C", "Command", "%#StatusLineModeCommand#", "%#StatusLineModeCommandInv#" },
    ["cv"] = { "C", "Vim·Ex", "%#StatusLineModeCommand#", "%#StatusLineModeCommandInv#" },
    ["ce"] = { "C", "Ex", "%#StatusLineModeCommand#", "%#StatusLineModeCommandInv#" },

    ["r"] = { "E", "Prompt", "%#StatusLineModePrompt#", "%#StatusLineModePromptInv#" },
    ["rm"] = { "M", "More", "%#StatusLineModePrompt#", "%#StatusLineModePromptInv#" },
    ["r?"] = { "C", "Confirm", "%#StatusLineModePrompt#", "%#StatusLinePromptNormalInv#" },

    ["!"] = { "S", "SHELL", "%#StatusLineModeTerminal#", "%#StatusLineModeTerminalInv#" },

    ["t"] = { "T", "TERMINAL", "%#StatusLineModeTerminal#", "%#StatusLineModeTerminalInv#" },

    __index = function()
        return { "U", "Unknown", "%#StatusLineModeUnknown#", "%#StatusLineModeUnknownInv#" } -- handle edge cases
    end,
}

M.current_mode = function(self)
    local current_mode = vim.api.nvim_get_mode().mode
    if self:is_truncated(self.trunc_width.mode) then
        return "1" -- string.format(" %s ", self.modes[current_mode][1]):upper()
    end
    return self.modes[current_mode][3]
        .. string.format(" %s ", self.modes[current_mode][2]):upper()
        .. self.modes[current_mode][4]
        .. self.separators[active_sep][1]
        .. self.colors.active
end

M.git_status = function(self)
    local colors = self.colors

    -- use fallback because it doesn't set this variable on the initial `BufEnter`
    local signs = vim.b.gitsigns_status_dict or { head = "", added = 0, changed = 0, removed = 0 }
    local is_head_empty = signs.head ~= ""

    local signs_head = colors.git .. string.format(" %s", signs.head or "") .. colors.active
    local signs_added = colors.green .. string.format("+%s", signs.added or "") .. colors.active
    local signs_changed = colors.yellow .. string.format("~%s", signs.changed or "") .. colors.active
    local signs_removed = colors.red .. string.format("-%s", signs.removed or "") .. colors.active

    if self:is_truncated(self.trunc_width.git_status) then
        return is_head_empty and " " .. signs_head .. " " or ""
    end

    return is_head_empty
            and string.format(" %s %s %s | %s ", signs_added, signs_changed, signs_removed, signs_head)
        or ""
end

M.filename = function(self)
    --TODO find current path
    local file = vim.fn.expand("%:f")
    if self:is_truncated(self.trunc_width.filename) then
        return Path:new(file):shorten()
    end
    return file
end

M.filetype = function()
    local filetype = vim.bo.filetype

    if filetype == "" then
        return ""
    end
    return " " .. filetype:lower() .. " "
end

M.fileicon = function()
    local file_name, file_ext = vim.fn.expand("%:t"), vim.fn.expand("%:e")
    local icon = require("nvim-web-devicons").get_icon(file_name, file_ext, { default = true })
    local filetype = vim.bo.filetype

    if filetype == "" then
        return ""
    end
    return " " .. icon .. " "
end

M.lsp_status_message = function()
    local clients = vim.lsp.buf_get_clients(0)
    local connected = not vim.tbl_isempty(clients)
    if connected then
        local all_messages = lsp_status.messages()
        for _, msg in ipairs(all_messages) do
            if msg.name then
                local contents
                if msg.progress then
                    contents = msg.title
                    if msg.message then
                        contents = contents .. " " .. msg.message
                    end

                    if msg.percentage then
                        contents = contents .. " (" .. msg.percentage .. ")"
                    end
                elseif msg.status then
                    contents = msg.content
                else
                    contents = msg.content
                end

                return " " .. contents .. " "
            end
        end
        return ""
    else
        return ""
    end
end

M.lsp_connection = function(self)
    local colors = self.colors
    local clients = vim.lsp.buf_get_clients(0)
    local connected = not vim.tbl_isempty(clients)
    if connected then
        local status = " " .. colors.green .. "" .. colors.active .. " ( "
        for _, client in ipairs(clients) do
            status = status .. client.name .. " "
        end
        status = status .. ") "
        return status
    else
        return ""
    end
end

M.diagnostics = function(self)
    local colors = self.colors
    local icons = self.icons

    local num_warnings = vim.lsp.diagnostic.get_count(0, "Warning")
    local num_work_warnings = require("polarmutex.lsp.extensions.workspace_diagnostics").get_count(0, "Warning")
    local num_errors = vim.lsp.diagnostic.get_count(0, "Error")
    local num_work_errors = require("polarmutex.lsp.extensions.workspace_diagnostics").get_count(0, "Error")

    local warn_msg = ""
    if num_warnings ~= 0 or num_work_warnings ~= 0 then
        local workspace_msg = (num_work_warnings > 0 and num_work_warnings ~= num_warnings)
                and string.format("(%s)", num_work_warnings)
            or ""
        warn_msg = string.format(" %s %s%s", icons.warning, num_warnings, workspace_msg)
    end

    local error_msg = ""
    if num_errors ~= 0 or num_work_errors ~= 0 then
        local workspace_msg = (num_work_errors > 0 and num_work_errors ~= num_errors)
                and string.format("(%s)", num_work_errors)
            or ""
        error_msg = string.format("%s %s%s ", icons.error, num_errors, workspace_msg)
    end

    return colors.yellow .. warn_msg .. colors.red .. error_msg .. colors.active
end

M.line_col = function(self)
    local colors = self.colors
    local separators = self.separators

    local current_line = vim.fn.line(".")
    local current_col = vim.fn.col(".")
    local total_line = vim.fn.line("$")

    local percentage
    if current_line == 1 then
        percentage = "Top"
    elseif current_line == vim.fn.line("$") then
        percentage = "Bot"
    else
        local result, _ = math.modf((current_line / total_line) * 100)
        percentage = string.format("%s%s", result, "%%")
    end

    local line_col_str = string.format("%3d:%2d %s ", current_line, current_col, percentage)
    return colors.line_col_inv .. separators[active_sep][2] .. colors.line_col .. line_col_str
end

M.set_active = function(self)
    return table.concat({
        self:current_mode(),
        self:git_status(),
        self:filename(),
        -- file status
        "%=",
        self.lsp_status_message(),
        "%=",
        self:fileicon(),
        self:filetype(),
        self:lsp_connection(),
        self:diagnostics(),
        self:line_col(),
    })
end

M.set_inactive = function(self)
    return self.colors.inactive .. "%= %F %="
end

M.set_explorer = function(self)
    local title = self.colors.mode .. "   "
    local title_alt = self.colors.mode_alt .. self.separators[active_sep][2]

    return table.concat({ self.colors.active, title, title_alt })
end

Statusline = setmetatable(M, {
    __call = function(statusline, mode)
        if mode == "active" then
            return statusline:set_active()
        end
        if mode == "inactive" then
            return statusline:set_inactive()
        end
        if mode == "explorer" then
            return statusline:set_explorer()
        end
    end,
})

-- set statusline
-- TODO: replace this once we can define autocmd using lua
vim.api.nvim_exec(
    [[
    augroup Statusline
    au!
    au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline('active')
    au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline('inactive')
    au WinEnter,BufEnter,FileType NvimTree setlocal statusline=%!v:lua.Statusline('explorer')
    augroup END
]],
    false
)
