local lualine = require("lualine")

-- Config
local config = {
    options = {
        -- Disable sections and component separators
        --section_separators = { "", "" },
        --component_separators = { "", "" },
        section_separators = { "", "" },
        component_separators = { "", "" },
        theme = "gruvbox",
    },
    sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        -- These will be filled later
        lualine_c = {},
        lualine_x = {},
    },
    inactive_sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_v = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
    },
}
-- +-------------------------------------------------+
-- | A | B | C                             X | Y | Z |
-- +-------------------------------------------------+
local function ins_a(component)
    table.insert(config.sections.lualine_a, component)
end
local function ins_b(component)
    table.insert(config.sections.lualine_b, component)
end
local function ins_c(component)
    table.insert(config.sections.lualine_c, component)
end
local function ins_x(component)
    table.insert(config.sections.lualine_x, component)
end
local function ins_y(component)
    table.insert(config.sections.lualine_y, component)
end
local function ins_z(component)
    table.insert(config.sections.lualine_z, component)
end

local conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
    end,
    hide_in_width = function()
        return vim.fn.winwidth(0) > 80
    end,
    check_git_workspace = function()
        local filepath = vim.fn.expand("%:p:h")
        local gitdir = vim.fn.finddir(".git", filepath .. ";")
        return gitdir and #gitdir > 0 and #gitdir < #filepath
    end,
}

-- mode
ins_a("mode")
-- git status
ins_b({
    "branch",
    condition = conditions.check_git_workspace,
})
-- filename
ins_c({
    "filename",
    condition = conditions.buffer_not_empty,
})
-- lsp status
-- fileicon
-- filetype
ins_x({
    "o:encoding", -- option component same as &encoding in viml
    upper = true, -- I'm not sure why it's upper case either ;)
    condition = conditions.hide_in_width,
})
ins_x({
    "fileformat",
    upper = true,
    icons_enabled = true,
})
ins_x("filetype")
-- lsp connection
ins_y({
    -- Lsp server name .
    function()
        local msg = "No Active Lsp"
        local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
        local clients = vim.lsp.get_active_clients()
        if next(clients) == nil then
            return msg
        end
        for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                return client.name
            end
        end
        return msg
    end,
    icon = " LSP:",
    color = { fg = "#ffffff", gui = "bold" },
})
-- diagnostics
-- line col
ins_y({ "diagnostics", sources = { "nvim_lsp" } })
--ins_y("progress")
ins_z("location")

lualine.setup(config)
