local color_gamma = require('polarmutex.colorschemes.utils').color_gamma
local config = require('polarmutex.colorschemes.config')

local colors = {
    black = '#06080A',
    bg0 = '#11121D',
    bg1 = '#1A1B2A',
    bg2 = '#212234',
    bg3 = '#392B41',
    bg4 = '#4A5057',
    bg5 = '#282c34',
    bg_red = '#FE6D85',
    bg_green = '#98C379',
    bg_blue = '#9FBBF3',
    diff_red = '#773440',
    diff_green = '#587738',
    diff_blue = '#354A77',
    fg = '#A0A8CD',
    red = '#EE6D85',
    orange = '#F6955B',
    yellow = '#D7A65F',
    green = '#95C561',
    blue = '#7199EE',
    cyan = '#38A89D',
    purple = '#A485DD',
    grey = '#4A5057',
    none = 'NONE'
}

local function gamma_correction(colors)
    local gamma = config("tokyodark").gamma
    local colors_corrected = {}
    for k, v in pairs(colors) do colors_corrected[k] = color_gamma(v, gamma) end
    return colors_corrected
end

return gamma_correction(colors)
