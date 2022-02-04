---@class Config
local config

-- shim vim for kitty and other generators
vim = vim or { g = {}, o = {} }

config = {
    style = "storm",
    dayBrightness = 0.3,
    transparent = false,
    commentStyle = "italic", --"NONE"
    keywordStyle = "italic", --"NONE",
    functionStyle = "italic", -- "NONE",
    variableStyle = "italic", -- "NONE",
    hideInactiveStatusline = false,
    terminalColors = true,
    sidebars = {},
    colors = {},
    dev = false,
    darkFloat = true,
    darkSidebar = true,
    transparentSidebar = false,
    transform_colors = false,
    lualineBold = false,
}

if config.style == "day" then
    vim.o.background = "light"
end

return config
