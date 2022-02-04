local util = require("polarmutex.colorschemes.utils")

local M = {}

---@param config Config
---@return ColorScheme
function M.setup(config)
    config = config or require("polarmutex.colorschemes.kanagawa.config")

    -- Color Palette
    ---@class ColorScheme
    local colors = {}

    colors = {
        -- Bg Shades
        sumiInk0 = "#16161D",
        sumiInk1b = "#181820",
        sumiInk1 = "#1F1F28",
        sumiInk2 = "#2A2A37",
        sumiInk3 = "#363646",
        sumiInk4 = "#54546D",

        -- Popup and Floats
        waveBlue1 = "#223249",
        waveBlue2 = "#2D4F67",

        -- Diff and Git
        winterGreen = "#2B3328",
        winterYellow = "#49443C",
        winterRed = "#43242B",
        winterBlue = "#252535",
        autumnGreen = "#76946A",
        autumnRed = "#C34043",
        autumnYellow = "#DCA561",

        -- Diag
        samuraiRed = "#E82424",
        roninYellow = "#FF9E3B",
        waveAqua1 = "#6A9589",
        dragonBlue = "#658594",

        -- Fg and Comments
        oldWhite = "#C8C093",
        fujiWhite = "#DCD7BA",
        fujiGray = "#727169",
        springViolet1 = "#938AA9",

        oniViolet = "#957FB8",
        crystalBlue = "#7E9CD8",
        springViolet2 = "#9CABCA",
        springBlue = "#7FB4CA",
        lightBlue = "#A3D4D5", -- unused yet
        waveAqua2 = "#7AA89F", -- improve lightness: desaturated greenish Aqua

        -- waveAqua2  = "#68AD99",
        -- waveAqua4  = "#7AA880",
        -- waveAqua5  = "#6CAF95",
        -- waveAqua3  = "#68AD99",

        springGreen = "#98BB6C",
        boatYellow1 = "#938056",
        boatYellow2 = "#C0A36E",
        carpYellow = "#E6C384",

        sakuraPink = "#D27E99",
        waveRed = "#E46876",
        peachRed = "#FF5D62",
        surimiOrange = "#FFA066",
        katanaGray = "#717C7C",
    }

    colors.base00 = colors.sumiInk1
    colors.base01 = colors.autumnRed
    colors.base02 = colors.autumnGreen
    colors.base03 = colors.boatYellow2
    colors.base04 = colors.crystalBlue
    colors.base05 = colors.oniViolet
    colors.base06 = colors.waveAqua1
    colors.base07 = colors.oldWhite
    colors.base08 = colors.fujiGray
    colors.base09 = colors.samuraiRed
    colors.base0A = colors.springGreen
    colors.base0B = colors.carpYellow
    colors.base0C = colors.springBlue
    colors.base0D = colors.springViolet1
    colors.base0E = colors.waveAqua2
    colors.base0F = colors.fujiWhite

    colors.error = colors.samuraiRed
    colors.warning = colors.roninYellow
    colors.info = colors.waveAqua1
    colors.hint = colors.dragonBlue

    return colors
end

return M
