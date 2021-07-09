local color_gamma = require('polarmutex.colorschemes.utils').color_gamma
local config = require('polarmutex.colorschemes.config')

local gruvbox_palette = {
    dark0_hard = "#1d2021",
    dark0 = "#282828",
    dark0_soft = "#32302f",
    dark1 = "#3c3836",
    dark2 = "#504945",
    dark3 = "#665c54",
    dark4 = "#7c6f64",
    light0_hard = "#f9f5d7",
    light0 = "#fbf1c7",
    light0_soft = "#f2e5bc",
    light1 = "#ebdbb2",
    light2 = "#d5c4a1",
    light3 = "#bdae93",
    light4 = "#a89984",
    bright_red = "#fb4934",
    bright_green = "#b8bb26",
    bright_yellow = "#fabd2f",
    bright_blue = "#83a598",
    bright_purple = "#d3869b",
    bright_aqua = "#8ec07c",
    bright_orange = "#fe8019",
    neutral_red = "#cc241d",
    neutral_green = "#98971a",
    neutral_yellow = "#d79921",
    neutral_blue = "#458588",
    neutral_purple = "#b16286",
    neutral_aqua = "#689d6a",
    neutral_orange = "#d65d0e",
    faded_red = "#9d0006",
    faded_green = "#79740e",
    faded_yellow = "#b57614",
    faded_blue = "#076678",
    faded_purple = "#8f3f71",
    faded_aqua = "#427b58",
    faded_orange = "#af3a03",
    gray = "#928374",
}

local colors = {
    bg0 = gruvbox_palette.dark0_hard,
    bg1 = gruvbox_palette.dark1,
    bg2 = gruvbox_palette.dark2,
    bg3 = gruvbox_palette.dark3,
    bg4 = gruvbox_palette.dark4,
    red = gruvbox_palette.bright_red,
    green = gruvbox_palette.bright_green,
    yellow = gruvbox_palette.bright_yellow,
    blue = gruvbox_palette.bright_blue,
    purple = gruvbox_palette.bright_purple,
    cyan = gruvbox_palette.bright_aqua,
    orange = gruvbox_palette.bright_orange,
    fg0 = gruvbox_palette.light0,
    fg1 = gruvbox_palette.light1,
    fg2 = gruvbox_palette.light2,
    fg3 = gruvbox_palette.light3,
    fg4 = gruvbox_palette.light4,
    gray = gruvbox_palette.gray,
    neutral_red = gruvbox_palette.neutral_red,
    neutral_green = gruvbox_palette.neutral_green,
    neutral_yellow = gruvbox_palette.neutral_yellow,
    neutral_blue = gruvbox_palette.neutral_blue,
    neutral_purple = gruvbox_palette.neutral_purple,
    neutral_cyan = gruvbox_palette.neutral_aqua,
    neutral_orange= gruvbox_palette.neutral_orange,
}

local function gamma_correction(colors)
    local gamma = config("gruvbox").gamma
    local colors_corrected = {}
    for k, v in pairs(colors) do colors_corrected[k] = color_gamma(v, gamma) end
    return colors_corrected
end

return gamma_correction(colors)
