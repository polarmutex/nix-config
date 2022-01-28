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

    colors.bg_dark = colors.sumiInk0
    colors.bg = colors.sumiInk0
    colors.comment = colors.oldWhite
    colors.fg_gutter = colors.oldWhite

    util.bg = colors.bg
    util.day_brightness = config.dayBrightness

    colors.diff = {
        add = colors.winterGreen,
        delete = colors.winterRed,
        change = colors.winterBlue,
        text = colors.winterYellow,
    }

    colors.git = {
        add = colors.autumnGreen,
        change = colors.autumnYellow,
        delete = colors.autumnRed,
    }

    colors.gitSigns = {
        add = colors.autumnGreen,
        change = colors.autumnYellow,
        delete = colors.autumnRed,
    }

    --colors.git.ignore = colors.dark3
    colors.black = util.darken(colors.sumiInk0, 0.8, "#000000")
    colors.border_highlight = colors.waveBlue1
    colors.border = colors.black

    -- Popups and statusline always get a dark background
    colors.bg_popup = colors.bg_dark
    colors.bg_statusline = colors.bg_dark

    -- Sidebar and Floats are configurable
    colors.bg_sidebar = (config.transparentSidebar and colors.none)
        or config.darkSidebar and colors.bg_dark
        or colors.bg
    colors.bg_float = config.darkFloat and colors.bg_dark or colors.bg

    --colors.bg_visual = util.darken(colors.waveBlue1, 0.7)
    colors.bg_search = colors.dragonBlue
    colors.fg_sidebar = colors.fujiGray

    colors.error = colors.samuraiRed
    colors.warning = colors.roninYellow
    colors.info = colors.dragonBlue
    colors.hint = colors.waveAqua1

    util.color_overrides(colors, config)

    return colors
end

return M
