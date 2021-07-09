local function get(colorscheme, setting, default)
    local key = colorscheme .. "_" .. setting
    if vim.g[key] == nil then return default end
    return vim.g[key]
end

local config = function(colorscheme)
    return {
        bg = get(colorscheme, "transparent_background", false),
        italic = get(colorscheme, "enable_italic", true),
        italic_comment = get(colorscheme, "enable_italic_comment", true),
        gamma = get(colorscheme, "color_gamma", "1.0")
    }
end

return config
