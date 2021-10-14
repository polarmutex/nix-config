local p = require("polarmutex.colorschemes.gruvbox.palette")
local cfg = require("polarmutex.colorschemes.config")
local u = require("polarmutex.colorschemes.utils")

local M = {}
local hl = { langs = {}, plugins = {} }

local highlight = vim.api.nvim_set_hl
local set_hl_ns = vim.api.nvim__set_hl_ns or vim.api.nvim_set_hl_ns
local create_namespace = vim.api.nvim_create_namespace

local function load_highlights(ns, highlights)
    for group_name, group_settings in pairs(highlights) do
        highlight(ns, group_name, group_settings)
    end
end

-- global settings
local settings = {
    bg = "dark",
    contrast_dark = "hard",
    contrart_light = "medium",
    bold = true,
    italic = true,
    undercurl = true,
    underline = true,
    inverse = true,
    improved_strings = false,
    improved_warnings = false,
    invert = false,
    invert_signs = false,
    invert_selection = true,
    invert_tabline = false,
    italicize_comments = true,
    italicize_strings = false,
}

local styles = {
    italic = "italic",
    inverse = "inverse",
    bold = "bold",
    undercurl = "undercurl",
    underline = "underline",
}

hl.predef = {
    Red = { fg = p.red },
    RedBold = { fg = p.red, bold = true },
    RedItalic = { fg = p.red, italic = cfg("gruvbox").italic },
    Green = { fg = p.green },
    GreenBold = { fg = p.green, bold = true },
    GreenItalic = { fg = p.green, italic = cfg("gruvbox").italic },
    Yellow = { fg = p.yellow },
    YellowBold = { fg = p.yellow, bold = true },
    Blue = { fg = p.blue },
    BlueBold = { fg = p.blue, bold = true },
    BlueItalic = { fg = p.blue, italic = cfg("gruvbox").italic },
    Purple = { fg = p.purple },
    PurpleBold = { fg = p.purple, bold = true },
    Cyan = { fg = p.cyan },
    CyanBold = { fg = p.cyan, bold = true },
    Orange = { fg = p.orange },
    OrangeBold = { fg = p.orange, bold = true },
    OrangeItalic = { fg = p.orange, italic = cfg("gruvbox").italic },
}

hl.common = {
    Normal = { fg = p.fg1, bg = cfg("gruvbox").bg and p.none or p.bg0 },
    NormalFloat = { fg = p.fg1, bg = cfg("gruvbox").bg and p.none or p.bg0 },
    NormalNC = { fg = p.fg1, bg = cfg("gruvbox").bg and p.none or p.bg0 },
    Terminal = { fg = p.fg, bg = cfg("gruvbox").bg and p.none or p.bg0 },
    EndOfBuffer = { fg = p.bg2, bg = cfg("gruvbox").bg and p.none or p.bg0 },
    FoldColumn = { fg = p.grey, bg = cfg("gruvbox").bg and p.none or p.bg1 },
    Folded = { fg = p.grey, bg = cfg("gruvbox").bg and p.none or p.bg1 },
    SignColumn = { fg = p.fg, bg = cfg("gruvbox").bg and p.none or p.bg0 },
    ToolbarLine = { fg = p.fg },
    Cursor = { reverse = true },
    vCursor = { reverse = true },
    iCursor = { reverse = true },
    lCursor = { reverse = true },
    CursorIM = { reverse = true },
    CursorColumn = { bg = p.bg1 },
    CursorLine = { bg = p.bg1 },
    CursorLineNr = { fg = p.yellow },
    ColorColumn = { bg = p.bg1 },
    ColorLine = { bg = p.bg1 },
    LineNr = { fg = p.bg4 },
    Conceal = hl.predef.Blue,
    DiffAdd = { fg = p.green, bg = p.bg0 },
    DiffChange = { fg = p.cyan, bg = p.bg0 },
    DiffDelete = { fg = p.red, bg = p.bg0 },
    DiffText = { fg = p.yellow, bg = p.bg0 },
    Directory = { fg = p.red, bold = true },
    ErrorMsg = { fg = p.red, bold = true, underline = true },
    WarningMsg = { fg = p.yellow, bold = true },
    MoreMsg = hl.predef.YellowBold,
    ModeMsg = hl.predef.YellowBold,
    IncSearch = { fg = p.orange, bg = p.bg0, reverse = true },
    Search = { fg = p.yellow, bg = p.bg0, reverse = true },
    MatchParen = { fg = p.none, bg = p.bg4 },
    NonText = { fg = p.bg2 },
    Whitespace = { fg = p.bg4 },
    SpecialKey = { fg = p.fg4 },
    Pmenu = { fg = p.fg1, bg = p.bg2 },
    PmenuSbar = { fg = p.none, bg = p.bg2 },
    PmenuSel = { fg = p.bg2, bg = p.blue, bold = true },
    WildMenu = { fg = p.bg0, bg = p.blue },
    PmenuThumb = { fg = p.none, bg = p.grey },
    Question = hl.predef.OrangeBold,
    SpellBad = { fg = p.red, underline = true, sp = p.red },
    SpellCap = { fg = p.yellow, underline = true, sp = p.yellow },
    SpellLocal = { fg = p.blue, underline = true, sp = p.blue },
    SpellRare = { fg = p.purple, underline = true, sp = p.purple },
    StatusLine = { fg = p.fg, bg = p.bg2 },
    StatusLineTerm = { fg = p.fg, bg = p.bg2 },
    StatusLineNC = { fg = p.grey, bg = p.bg1 },
    StatusLineTermNC = { fg = p.grey, bg = p.bg1 },
    TabLine = { fg = p.bg4, bg = p.bg1 },
    TabLineFill = { fg = p.bg4, bg = p.bg1 },
    TabLineSel = { fg = p.green, bg = p.bg1 },
    VertSplit = { fg = p.bg3 },
    Visual = { bg = p.bg3 },
    VisualNOS = { fg = p.none, bg = p.bg3, underline = true },
    QuickFixLine = { bg = p.bg0, fg = p.yellow, underline = true },
    Debug = hl.predef.Red,
    debugPC = { fg = p.bg0, bg = p.green },
    debugBreakpoint = { fg = p.bg0, bg = p.red },
    ToolbarButton = { fg = p.bg0, bg = p.bg_blue },
}

hl.syntax = {
    Type = hl.predef.Yellow,
    Structure = hl.predef.Cyan,
    StorageClass = hl.predef.Orange,
    Identifier = hl.predef.Blue,
    Constant = hl.predef.Purple,
    PreProc = hl.predef.Cyan,
    PreCondit = hl.predef.Cyan,
    Include = hl.predef.Cyan,
    Keyword = hl.predef.Red,
    Define = hl.predef.Cyan,
    Typedef = hl.predef.Yellow,
    Exception = hl.predef.Red,
    Conditional = hl.predef.Red,
    Repeat = hl.predef.Red,
    Statement = hl.predef.Red,
    Macro = hl.predef.Cyan,
    Error = hl.predef.Red,
    Label = hl.predef.Red,
    Special = hl.predef.Purple,
    SpecialChar = hl.predef.Red,
    Boolean = hl.predef.Purple,
    String = hl.predef.Yellow,
    Character = hl.predef.Yellow,
    Number = hl.predef.Purple,
    Float = hl.predef.Purple,
    Function = hl.predef.GreenBold,
    Operator = { fg = p.fg1 },
    Title = hl.predef.Yellow,
    Tag = hl.predef.AquaBold,
    Delimiter = { fg = p.fg0 },
    Comment = { fg = p.grey, italic = cfg("gruvbox").italic_comment },
    SpecialComment = { fg = p.bg4, italic = cfg("gruvbox").italic_comment },
    Todo = { fg = p.blue, italic = cfg("gruvbox").italic_comment },
}

hl.plugins.lsp = {
    LspCxxHlGroupEnumConstant = hl.predef.Orange,
    LspCxxHlGroupMemberVariable = hl.predef.Orange,
    LspCxxHlGroupNamespace = hl.predef.Blue,
    LspCxxHlSkippedRegion = hl.predef.Grey,
    LspCxxHlSkippedRegionBeginEnd = hl.predef.Red,
    LspDiagnosticsDefaultError = { fg = u.color_gamma(p.red, 0.5) },
    LspDiagnosticsDefaultHint = { fg = u.color_gamma(p.purple, 0.5) },
    LspDiagnosticsDefaultInformation = { fg = u.color_gamma(p.blue, 0.5) },
    LspDiagnosticsDefaultWarning = { fg = u.color_gamma(p.yellow, 0.5) },
    LspDiagnosticsUnderlineError = { underline = true, sp = u.color_gamma(p.red, 0.5) },
    LspDiagnosticsUnderlineHint = { underline = true, sp = u.color_gamma(p.purple, 0.5) },
    LspDiagnosticsUnderlineInformation = { underline = true, sp = u.color_gamma(p.blue, 0.5) },
    LspDiagnosticsUnderlineWarning = { underline = true, sp = u.color_gamma(p.yellow, 0.5) },
}

hl.plugins.treesitter = {
    TSNone = {},
    TSError = hl.syntax.Error,
    TSTitle = hl.syntax.Title,
    TSLiteral = hl.syntax.String,
    TSURI = hl.syntax.Underlined,
    TSVariable = hl.syntax.Variable,
    TSPunctDelimiter = hl.syntax.Delimiter,
    TSPunctBracket = hl.syntax.Delimiter,
    TSPunctSpecial = hl.syntax.Delimiter,
    TSConstant = hl.syntax.Constant,
    TSConstBuiltin = hl.syntax.Special,
    TSConstMacro = hl.syntax.Define,
    TSString = hl.syntax.String,
    TSStringRegex = hl.syntax.String,
    TSStringEscape = hl.syntax.SpecialChar,
    TSCharacter = hl.syntax.Character,
    TSNumber = hl.syntax.Number,
    TSBoolean = hl.syntax.Boolean,
    TSFloat = hl.syntax.Float,
    TSFunction = hl.syntax.Function,
    TSFuncBuiltin = hl.syntax.Special,
    TSFuncMacro = hl.syntax.Macro,
    TSParameter = hl.syntax.Identifier,
    TSParameterReference = hl.syntax.Identifier,
    TSMethod = hl.syntax.Function,
    TSField = hl.syntax.Identifier,
    TSProperty = hl.syntax.Identifier,
    TSConstructor = hl.syntax.Special,
    TSAnnotation = hl.syntax.PreProc,
    TSAttribute = hl.syntax.PreProc,
    TSNamespace = hl.syntax.Include,
    TSConditional = hl.syntax.Conditional,
    TSRepeat = hl.syntax.Repeat,
    TSLabel = hl.syntax.Label,
    TSOperator = hl.syntax.Operator,
    TSKeyword = hl.syntax.Keyword,
    TSKeywordFunction = hl.syntax.Keyword,
    TSKeywordOperator = hl.syntax.Operator,
    TSException = hl.syntax.Exception,
    TSType = hl.syntax.Type,
    TSTypeBuiltin = hl.syntax.Type,
    TSInclude = hl.syntax.Include,
    TSVariableBuiltin = hl.syntax.Special,
    TSText = {},
    TSStrong = { bold = true },
    TSEmphasis = { italic = cfg("gruvbox").italic },
    TSUnderline = { underline = true },
}

hl.plugins.telescope = {
    TelescopeSelection = hl.predef.YellowBold,
    TelescopeSlectionCaret = hl.predef.Red,
    TelescopeMultiSelection = hl.predef.Gray,
    TelescopeNormal = hl.predef.Fg,
    TelescopeBorder = hl.predef.Fg,
    TelescopePromptBorder = hl.predef.Fg,
    TelescopeResultsBorder = hl.predef.Fg,
    TelescopePreviewBorder = hl.predef.Fg,
    TelescopeMatching = hl.predef.Blue,
    TelescopePromptPrefix = hl.predef.Red,
    TelescopePrompt = hl.predef.Fg,
}

hl.plugins.alphanvim = {
    AlphaHeader = hl.predef.Blue,
    StartifyBracket = hl.predef.Green,
    StartifyNumber = hl.predef.Purple,
    StartifyPath = hl.predef.Fg,
}

hl.plugins.statusline = {
    StatuslineGreen = { bg = hl.common.StatusLine.bg, fg = p.green },
    StatuslineYellow = { bg = hl.common.StatusLine.bg, fg = p.yellow },
    StatuslineRed = { bg = hl.common.StatusLine.bg, fg = p.red },
    StatuslineGit = { bg = hl.common.StatusLine.bg, fg = p.green },

    StatusLineLineCol = { bg = p.blue, fg = hl.common.StatusLine.bg },
    StatusLineLineColInv = { fg = p.blue, bg = hl.common.StatusLine.bg },

    StatusLineModeNormal = { fg = hl.common.StatusLine.bg, bg = p.fg1, bold = true },
    StatusLineModeNormalInv = { fg = hl.common.StatusLine.bg, bg = p.fg1, bold = true, reverse = true },
    StatusLineModeVisual = { fg = hl.common.StatusLine.bg, bg = p.orange, bold = true },
    StatusLineModeVisualInv = { fg = hl.common.StatusLine.bg, bg = p.orange, bold = true, reverse = true },
    StatusLineModeSelect = { fg = hl.common.StatusLine.bg, bg = p.orange, bold = true },
    StatusLineModeSelectInv = { fg = hl.common.StatusLine.bg, bg = p.fg1, bold = true, reverse = true },
    StatusLineModeInsert = { fg = hl.common.StatusLine.bg, bg = p.blue, bold = true },
    StatusLineModeInsertInv = { fg = hl.common.StatusLine.bg, bg = p.blue, bold = true, reverse = true },
    StatusLineModeReplace = { fg = hl.common.StatusLine.bg, bg = p.red, bold = true },
    StatusLineModeReplaceInv = { fg = hl.common.StatusLine.bg, bg = p.red, bold = true, reverse = true },
    StatusLineModeCommand = { fg = hl.common.StatusLine.bg, bg = p.green, bold = true },
    StatusLineModeCommandInv = { fg = hl.common.StatusLine.bg, bg = p.green, bold = true, reverse = true },
    StatusLineModePrompt = { fg = hl.common.StatusLine.bg, bg = p.fg1, bold = true },
    StatusLineModePromptInv = { fg = hl.common.StatusLine.bg, bg = p.fg1, bold = true, reverse = true },
    StatusLineModeTerminal = { fg = hl.common.StatusLine.bg, bg = p.yellow, bold = true },
    StatusLineModeTerminalInv = { fg = hl.common.StatusLine.bg, bg = p.yellow, bold = true, reverse = true },
    StatusLineModeUnknown = { fg = hl.common.StatusLine.bg, bg = p.red, bold = true },
    StatusLineModeUnknownInv = { fg = hl.common.StatusLine.bg, bg = p.red, bold = true, reverse = true },
}

hl.plugins.whichkey = {
    WhichKey = hl.predef.Red,
    WhichKeyDesc = hl.predef.Blue,
    WhichKeyGroup = hl.predef.Orange,
    WhichKeySeperator = hl.predef.Green,
}

hl.plugins.sighify = {
    SignifySignAdd = { bg = hl.common.SignColumn.bg, fg = p.green },
    SignifySignChang = { bg = hl.common.SignColumn.bg, fg = p.yellow },
    SignifySignDelete = { bg = hl.common.SignColumn.bg, fg = p.red },
}

hl.plugins.gitsigns = {
    GitSignsAdd = hl.predef.Green,
    GitSignsAddLn = hl.predef.Green,
    GitSignsAddNr = hl.predef.Green,
    GitSignsChange = hl.predef.Yellow,
    GitSignsChangeLn = hl.predef.Yellow,
    GitSignsChangeNr = hl.predef.Yellow,
    GitSignsDelete = hl.predef.Red,
    GitSignsDeleteLn = hl.predef.Red,
    GitSignsDeleteNr = hl.predef.Red,
}

hl.plugins.neogit = {
    NeogitNotificationInfo = hl.predef.Green,
    NeogitNotificationWarning = hl.predef.Yellow,
    NeogitNotificationError = hl.predef.Red,
    NeogitDiffAddHighlight = hl.common.DiffAdd,
    NeogitDiffDeleteHighlight = hl.common.DiffDelete,
    NeogitDiffContextHighlight = hl.common.DiffText,
    NeogitHunkHeader = hl.predef.Green,
    NeogitHunkHeaderHighlight = hl.predef.Green,
}

hl.langs.markdown = {
    markdownBlockquote = hl.predef.Grey,
    markdownBold = { fg = p.none, bold = true },
    markdownBoldDelimiter = hl.predef.Grey,
    markdownCode = hl.predef.Yellow,
    markdownCodeBlock = hl.predef.Yellow,
    markdownCodeDelimiter = hl.predef.Green,
    markdownH1 = { fg = p.red, bold = true },
    markdownH2 = { fg = p.red, bold = true },
    markdownH3 = { fg = p.red, bold = true },
    markdownH4 = { fg = p.red, bold = true },
    markdownH5 = { fg = p.red, bold = true },
    markdownH6 = { fg = p.red, bold = true },
    markdownHeadingDelimiter = hl.predef.Grey,
    markdownHeadingRule = hl.predef.Grey,
    markdownId = hl.predef.Yellow,
    markdownIdDeclaration = hl.predef.Red,
    markdownItalic = { fg = p.none, italic = true },
    markdownItalicDelimiter = { fg = p.grey, italic = true },
    markdownLinkDelimiter = hl.predef.Grey,
    markdownLinkText = hl.predef.Red,
    markdownLinkTextDelimiter = hl.predef.Grey,
    markdownListMarker = hl.predef.Red,
    markdownOrderedListMarker = hl.predef.Red,
    markdownRule = hl.predef.Purple,
    markdownUrl = { fg = p.blue, underline = true },
    markdownUrlDelimiter = hl.predef.Grey,
    markdownUrlTitleDelimiter = hl.predef.Green,
}

function M.setup()
    local ns = create_namespace("tokyodark")
    load_highlights(ns, hl.predef)
    load_highlights(ns, hl.common)
    load_highlights(ns, hl.syntax)
    for _, group in pairs(hl.langs) do
        load_highlights(ns, group)
    end
    for _, group in pairs(hl.plugins) do
        load_highlights(ns, group)
    end
    set_hl_ns(ns)
end

return M
