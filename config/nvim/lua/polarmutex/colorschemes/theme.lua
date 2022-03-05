local util = require("polarmutex.colorschemes.utils")

local M = {}

--base00 - Default Background
--base01 - Lighter Background (Used for status bars, line number and folding marks)
--base02 - Selection Background
--base03 - Comments, Invisibles, Line Highlighting
--base04 - Dark Foreground (Used for status bars)
--base05 - Default Foreground, Caret, Delimiters, Operators
--base06 - Light Foreground (Not often used)
--base07 - Light Background (Not often used)
--base08 - Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
--base09 - Integers, Boolean, Constants, XML Attributes, Markup Link Url
--base0A - Classes, Markup Bold, Search Text Background
--base0B - Strings, Inherited Class, Markup Code, Diff Inserted
--base0C - Support, Regular Expressions, Escape Characters, Markup Quotes
--base0D - Functions, Methods, Attribute IDs, Headings
--base0E - Keywords, Storage, Selector, Markup Italic, Diff Changed
--base0F - Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>

---@param config Config
---@return Theme
function M.setup(config)
    config = config or require("polarmutex.colorschemes.tokyonight.config")

    local colors = require("polarmutex.colorschemes." .. config.theme .. ".colors")

    ---@class Theme
    local theme = {}
    theme.config = config
    theme.colors = colors.setup(config)
    local c = theme.colors

    theme.base = {
        -- Vim editor colors
        Normal = { fg = c.fg, bg = config.transparent and c.none or c.bg }, -- normal text
        Bold = { bold = true },
        Debug = { fg = c.base08 }, --    debugging statements
        Directory = { fg = c.fn or c.base0D }, -- directory names (and other special names in listings)
        Error = { fg = c.base00, bg = c.base08 }, -- (preferred) any erroneous construct
        ErrorMsg = { fg = c.diag.error }, -- error messages on the command line
        Exception = { fg = c.sp2 or c.base08 }, --  try, catch, throw
        FoldColumn = { fg = c.bg_light2 }, -- 'foldcolumn'
        Folded = { fg = c.bg_light3, bg = c.bg_light0 }, -- line used for closed folds
        IncSearch = { fg = c.bg_visual, bg = c.diag.warning }, -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
        Italic = { italic = true },
        Macro = { fg = c.base08 }, --    same as Define
        MatchParen = { bg = c.diag.warning, bold = true }, -- The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
        ModeMsg = { fg = c.diag.warning, bold = true }, -- 'showmode' message (e.g., "-- INSERT -- ")
        MoreMsg = { fg = c.diag.info, bg = c.bg }, -- |more-prompt|
        MsgArea = { fg = c.fg_dark }, -- Area for messages and cmdline
        Question = { link = "MoreMsg" }, -- |hit-enter| prompt and yes/no questions
        Search = { fg = c.fg, bg = c.bg_search }, -- Last search pattern highlighting (see 'hlsearch').  Also used for similar items that need to stand out.
        Substitute = { fg = c.fg, bg = c.git.removed }, -- |:substitute| replacement text highlighting
        SpecialKey = { link = "NonText" }, -- Unprintable characters: text displayed differently from what it really is.  But not 'listchars' whitespace. |hl-Whitespace|
        TooLong = { fg = c.base08 }, -- TODO desc
        Underlined = { underline = true }, -- (preferred) text that stands out, HTML links
        Visual = { bg = c.bg_visual }, -- Visual mode selection
        VisualNOS = { link = "Visual" }, -- Visual mode selection when vim is "Not Owning the Selection".
        WarningMsg = { fg = c.diag.warning }, -- warning messages
        WildMenu = { link = "Pmenu" }, -- current match in 'wildmenu' completion
        Title = { fg = c.fn, bold = true }, -- titles for output from ":set all", ":autocmd" etc.
        Conceal = { fg = c.bg_light3 or c.base0D, bg = c.base00 }, -- placeholder characters substituted for concealed text (see 'conceallevel')
        Cursor = { fg = c.bg or c.base00, bg = c.fg or c.base05 }, -- character under the cursor
        lCursor = { link = "Cursor" },
        CursorIM = { link = "Cursor" },
        NonText = { fg = c.bg_light2 }, -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
        LineNr = { fg = c.bg_light2 }, -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
        SignColumn = { fg = c.bg_light2, bg = config.transparent and c.none or c.base00 }, -- column where |signs| are displayed
        StatusLine = { fg = c.fg_dark, bg = c.bg_status }, -- status line of current window
        StatusLineNC = { fg = c.fg_comment, bg = c.bg_status }, -- status lines of not-current windows Note: if this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
        VertSplit = { fg = c.bg_status, bg = c.bg_status }, -- the column separating vertically split windows
        ColorColumn = { bg = c.bg_light0 or c.base01 }, -- used for the columns set with 'colorcolumn'
        CursorColumn = { bg = c.bg_light1 or c.base01 }, -- Screen-column at the cursor, when 'cursorcolumn' is set.
        CursorLine = { bg = c.bg_light1 or c.base01 }, -- Screen-line at the cursor, when 'cursorline' is set.  Low-priority if foreground (ctermfg OR guifg) is not set.
        CursorLineNr = { fg = c.diag.warning, bold = true }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
        QuickFixLine = { link = "CursorLine" }, -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
        Pmenu = { fg = c.fg, bg = c.bg_menu }, -- Popup menu: normal item.
        PmenuSel = { bg = c.bg_menu_sel }, -- Popup menu: selected item.
        TabLine = { fg = c.bg_light3, bg = c.bg_dark }, -- tab pages line, not active tab page label
        TabLineFill = { bg = c.bg }, -- tab pages line, where there are no labels
        TabLineSel = { fg = c.fg_dark, bg = c.bg_light1 }, -- tab pages line, active tab page label
        Whitespace = { fg = c.bg_light2 }, -- "nbsp", "space", "tab" and "trail" in 'listchars'

        -- Standard syntax highlighting
        Boolean = { fg = c.co }, --  a boolean constant: TRUE, false
        Character = { link = "String" }, --  a character constant: 'c', '\n'
        Comment = { fg = c.fg_comment }, -- any comment
        Conditional = { fg = c.base0E }, --  if, then, else, endif, switch, etc.
        Constant = { fg = c.co }, -- (preferred) any constant
        Define = { fg = c.base0E }, --   preprocessor #define
        Delimiter = { fg = c.base0F }, --  character that needs attention
        Float = { link = "Number" }, --    a floating point constant: 2.3e10
        Function = { fg = c.fn }, -- function name (also: methods for classes)
        Identifier = { fg = c.id }, -- (preferred) any variable name
        Include = { fg = c.base0D }, --  preprocessor #include
        Keyword = { fg = c.kw }, --  any other keyword
        Label = { fg = c.base0A }, --    case, default, etc.
        Number = { fg = c.nu }, --  a number constant: 234, 0xff
        Operator = { fg = c.op }, -- "sizeof", "+", "*", etc.
        PreProc = { fg = c.pp }, -- (preferred) generic Preprocessor
        Repeat = { fg = c.base0A }, --   for, do, while, etc.
        Special = { fg = c.sp }, -- (preferred) any special symbol
        SpecialChar = { fg = c.base0F }, --  special character in a constant
        Statement = { fg = c.sm }, -- (preferred) any statement
        StorageClass = { fg = c.base0A }, -- static, register, volatile, etc.
        String = { fg = c.st }, --   a string constant: "this is a string"
        Structure = { fg = c.base0E }, --  struct, union, enum, etc.
        Tag = { fg = c.base0A }, --    you can use CTRL-] on this
        Todo = { fg = c.fg_reverse, bg = c.diag.info, bold = true }, -- (preferred) anything that needs extra attention; mostly the keywords TODO FIXME and XXX
        Type = { fg = c.ty }, -- (preferred) int, long, char, etc.
        Typedef = { fg = c.base0A }, --  A typedef

        -- Diff highlighting
        DiffAdd = { bg = c.diff.add }, -- diff mode: Added line |diff.txt|
        DiffChange = { bg = c.diff.change }, -- diff mode: Changed line |diff.txt|
        DiffDelete = { fg = c.git.removed, bg = c.diff.delete }, -- diff mode: Deleted line |diff.txt|
        DiffText = { bg = c.diff.text }, -- diff mode: Changed text within a changed line |diff.txt|
        DiffAdded = { fg = c.base0B, bg = c.base00 }, -- TODO
        DiffFile = { fg = c.base08, bg = c.base00 }, -- TODO
        DiffNewFile = { fg = c.base0B, bg = c.base00 }, -- TODO
        DiffLine = { fg = c.base0D, bg = c.base00 }, -- TODO
        DiffRemoved = { fg = c.base08, bg = c.base00 }, -- TODO

        -- Spelling highlighting
        SpellBad = { undercurl = true, sp = c.diag.error }, -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
        SpellCap = { undercurl = true, sp = c.diag.warning }, -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
        SpellLocal = { undercurl = true, sp = c.diag.warning }, -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
        SpellRare = { undercurl = true, sp = c.diag.warning }, -- Word that is recognized by the spellchecker as one that is hardly ever used.  |spell| Combined with the highlighting used otherwise.

        DiagnosticError = { fg = c.diag.error }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
        DiagnosticWarn = { fg = c.diag.warning }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
        DiagnosticInfo = { fg = c.diag.info }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
        DiagnosticHint = { fg = c.diag.hint }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
        DiagnosticVirtualTextError = { fg = c.diag.error }, -- Used for "Error" diagnostic virtual text
        DiagnosticVirtualTextWarn = { fg = c.diag.warning }, -- Used for "Warning" diagnostic virtual text
        DiagnosticVirtualTextInfo = { fg = c.diag.info }, -- Used for "Information" diagnostic virtual text
        DiagnosticVirtualTextHint = { fg = c.diag.hint }, -- Used for "Hint" diagnostic virtual text
        DiagnosticUnderlineError = { undercurl = true, sp = c.diag.error }, -- Used to underline "Error" diagnostics
        DiagnosticUnderlineWarn = { undercurl = true, sp = c.diag.warning }, -- Used to underline "Warning" diagnostics
        DiagnosticUnderlineInfo = { undercurl = true, sp = c.diag.info }, -- Used to underline "Information" diagnostics
        DiagnosticUnderlineHint = { undercurl = true, sp = c.diag.hint }, -- Used to underline "Hint" diagnostics

        -- These groups are for the native LSP client. Some other LSP clients may
        -- use these groups, or use their own. Consult your LSP client's
        -- documentation.
        LspReferenceText = { underline = true, sp = c.base04 }, -- used for highlighting "text" references
        LspReferenceRead = { underline = true, sp = c.base04 }, -- used for highlighting "read" references
        LspReferenceWrite = { underline = true, sp = c.base04 }, -- used for highlighting "write" references
        LspDiagnosticsDefaultError = { link = "DiagnosticError" },
        LspDiagnosticsDefaultWarning = { link = "DiagnosticWarn" },
        LspDiagnosticsDefaultInformation = { link = "DiagnosticInfo" },
        LspDiagnosticsDefaultHint = { link = "DiagnosticHint" },
        LspDiagnosticsUnderlineError = { link = "DiagnosticUnderlineError" },
        LspDiagnosticsUnderlineWarning = { link = "DiagnosticUnderlineWarning" },
        LspDiagnosticsUnderlineInformation = { link = "DiagnosticUnderlineInformation" },
        LspDiagnosticsUnderlineHint = { link = "DiagnosticUnderlineHint" },

        --lCursor = { fg = c.bg, bg = c.fg }, -- the character under the cursor when |language-mapping| is used (see 'guicursor')
        --CursorIM = { fg = c.bg, bg = c.fg }, -- like Cursor, but used when in IME mode |CursorIM|
        --EndOfBuffer = { fg = c.bg }, -- filler lines (~) after the end of the buffer.  By default, this is highlighted like |hl-NonText|.
        -- TermCursor  = { }, -- cursor in a focused terminal
        -- TermCursorNC= { }, -- cursor in an unfocused terminal
        --SignColumnSB = { bg = c.bg_sidebar, fg = c.fg_gutter }, -- column where |signs| are displayed
        -- MsgSeparator= { }, -- Separator for scrolled messages, `msgsep` flag of 'display'
        --NormalNC = { fg = c.fg, bg = config.transparent and c.none or c.bg }, -- normal text in non-current windows
        --NormalSB = { fg = c.fg_sidebar, bg = c.bg_sidebar }, -- normal text in non-current windows
        --NormalFloat = { fg = c.fg, bg = c.bg_float }, -- Normal text in floating windows.
        --FloatBorder = { fg = c.border_highlight, bg = c.bg_float },
        --PmenuSbar = { bg = util.lighten(c.bg_popup, 0.95) }, -- Popup menu: scrollbar.
        --PmenuThumb = { bg = c.fg_gutter }, -- Popup menu: Thumb of the scrollbar.
    }

    if not vim.diagnostic then
        local severity_map = {
            Error = "Error",
            Warn = "Warning",
            Info = "Information",
            Hint = "Hint",
        }
        local types = { "Default", "VirtualText", "Underline" }
        for _, type in ipairs(types) do
            for snew, sold in pairs(severity_map) do
                theme.base["LspDiagnostics" .. type .. sold] = {
                    link = "Diagnostic" .. (type == "Default" and "" or type) .. snew,
                }
            end
        end
    end

    theme.plugins = {

        -- These groups are for the neovim tree-sitter highlights.
        -- As of writing, tree-sitter support is a WIP, group names may change.
        -- By default, most of these groups link to an appropriate Vim group,
        -- TSError -> Error for example, so you do not have to define these unless
        -- you explicitly want to support Treesitter's improved syntax awareness.

        --TSAnnotation = { fg = c.base0F }, -- For C++/Dart attributes, annotations that can be attached to the code to denote some kind of meta information.
        --TSAttribute = { fg = c.base0A }, -- (unstable) TODO: docs
        --TSBoolean = { fg = c.base09 }, -- For booleans.
        --TSCharacter = { fg = c.base08, italic = true }, -- For characters.
        --TSComment = { fg = c.fg_comment or c.base03 }, -- For comment blocks.
        --TSConstructor = { fg = c.base0D }, -- For constructor calls and definitions: `= { }` in Lua, and Java constructors.
        --TSConditional = { fg = c.base0E }, -- For keywords related to conditionnals.
        --TSConstant = { fg = c.base09 }, -- For constants
        --TSConstBuiltin = { fg = c.base09, italic = true }, -- For constant that are built in the language: `nil` in Lua.
        --TSConstMacro = { fg = c.base08 }, -- For constants that are defined by macros: `NULL` in C.
        --TSError = { fg = c.error }, -- For syntax/parser errors.
        --TSException = { fg = c.base08 }, -- For exception related keywords.
        --TSField = { fg = c.base05 }, -- For fields.
        --TSFloat = { fg = c.base09 }, -- For floats.
        --TSFunction = { fg = c.base0D }, -- For function (calls and definitions).
        --TSFuncBuiltin = { fg = c.base0D, italic = true }, -- For builtin functions: `table.insert` in Lua.
        --TSFuncMacro = { fg = c.base08 }, -- For macro defined fuctions (calls and definitions): each `macro_rules` in Rust.
        --TSInclude = { fg = c.base0D }, -- For includes: `#include` in C, `use` or `extern crate` in Rust, or `require` in Lua.
        --TSKeyword = { fg = c.base0E }, -- For keywords that don't fall in previous categories.
        --TSKeywordFunction = { fg = c.base0E }, -- For keywords used to define a fuction.
        --TSKeywordOperator = { fg = c.base0E }, -- TODO
        --TSLabel = { fg = c.base0A }, -- For labels: `label:` in C and `:label:` in Lua.
        --TSMethod = { fg = c.base0D }, -- For method calls and definitions.
        --TSNamespace = { fg = c.base08 }, -- For identifiers referring to modules and namespaces.
        --TSNone = { fg = c.base05 }, -- TODO: docs
        --TSNumber = { fg = c.base09 }, -- For all numbers
        --TSOperator = { fg = c.base05 }, -- For any operator: `+`, but also `->` and `*` in C.
        --TSParameter = { fg = c.base05 }, -- For parameters of a function.
        --TSParameterReference = { fg = c.base05 }, -- For references to parameters of a function.
        --TSProperty = { fg = c.base05 }, -- Same as `TSField`.
        --TSPunctDelimiter = { fg = c.base0F }, -- For delimiters ie: `.`
        --TSPunctBracket = { fg = c.base05 }, -- For brackets and parens.
        --TSPunctSpecial = { fg = c.base05 }, -- For special punctutation that does not fall in the catagories before.
        --TSRepeat = { fg = c.base0A }, -- For keywords related to loops.
        --TSString = { fg = c.base0B }, -- For strings.
        --TSStringRegex = { fg = c.base0C }, -- For regexes.
        --TSStringEscape = { fg = c.base0C }, -- For escape characters within a string.
        --TSSymbol = { fg = c.base0B }, -- For identifiers referring to symbols or atoms.
        --TSTag = { fg = c.base0A }, -- Tags like html tag names.
        --TSTagDelimiter = { fg = c.base0F }, -- Tag delimiter like `<` `>` `/`
        --TSText = { fg = c.base05 }, -- For strings considered text in a markup language.
        --TSStrong = { bold = true },
        --TSEmphasis = { fg = c.base09, italic = true }, -- For text to be represented with emphasis.
        --TSUnderline = { underline = true }, -- For text to be represented with an underline.
        --TSStrike = { strikethrough = true }, -- For strikethrough text.
        --TSTitle = { fg = c.base0D }, -- Text that is part of a title.
        --TSLiteral = { fg = c.base09 }, -- Literal text.
        --TSURI = { fg = c.base09, underline = true }, -- Any URI like a link or email.
        --TSType = { fg = c.base0A }, -- For types.
        --TSTypeBuiltin = { fg = c.base0A, italic = true }, -- For builtin types.
        --TSVariable = { fg = c.base08 }, -- Any variable name that does not have another highlight.
        --TSVariableBuiltin = { fg = c.base08, italic = true }, -- Variable names that are defined by the languages, like `this` or `self`.
        --TSDefinition = { underline = true, sp = c.base04 },
        --TSDefinitionUsage = { underline = true, sp = c.base04 },
        --TSCurrentScope = { bold = true },
        --TSNote = { fg = c.bg, bg = c.info },
        --TSWarning = { fg = c.bg, bg = c.warning },
        --TSDanger = { fg = c.bg, bg = c.error },
        --TSTextReference = { fg = c.teal },

        -- LspTrouble
        --LspTroubleText = { fg = c.fg_dark },
        --LspTroubleCount = { fg = c.magenta, bg = c.fg_gutter },
        --LspTroubleNormal = { fg = c.fg_sidebar, bg = c.bg_sidebar },

        -- diff
        diffAdded = { fg = c.git.added },
        diffRemoved = { fg = c.git.removed },
        diffDeleted = { fg = c.git.removed },
        diffChanged = { fg = c.git.changed },
        diffOldFile = { fg = c.git.removed },
        diffNewFile = { fg = c.git.added },
        --diffFile = { fg = c.blue },
        --diffLine = { fg = c.comment },
        --diffIndexLine = { fg = c.magenta },

        -- Neogit
        --NeogitBranch = { fg = c.magenta },
        --NeogitRemote = { fg = c.purple },
        --NeogitHunkHeader = { bg = c.bg_highlight, fg = c.fg },
        --NeogitHunkHeaderHighlight = { bg = c.fg_gutter, fg = c.blue },
        --NeogitDiffContextHighlight = { bg = util.darken(c.fg_gutter, 0.5), fg = c.fg_dark },
        --NeogitDiffDeleteHighlight = { fg = c.git.delete, bg = c.diff.delete },
        --NeogitDiffAddHighlight = { fg = c.git.add, bg = c.diff.add },

        -- GitSigns
        GitSignsAdd = { link = "diffAdded" }, -- diff mode: Added line |diff.txt|
        GitSignsChange = { link = "diffChanged" }, -- diff mode: Changed line |diff.txt|
        GitSignsDelete = { link = "diffDeleted" }, -- diff mode: Deleted line |diff.txt|
        GitSignsDeleteLn = { bg = c.diff.delete },

        -- Telescope
        TelescopeBorder = { link = "FloatBorder" },
        --TelescopeNormal = { fg = c.fg, bg = c.bg_float },

        -- NeoVim
        healthError = { fg = c.diag.error },
        healthSuccess = { fg = c.diag.good },
        healthWarning = { fg = c.diag.warning },

        -- Cmp
        CmpDocumentation = { fg = c.fg, bg = c.bg_popup },
        --CmpDocumentationBorder = { fg = c.fg_border, bg = "NONE" },
        --CmpItemAbbr = { fg = c.fg, bg = "NONE" },
        --CmpItemAbbrDeprecated = { fg = c.fg_comment, bg = "NONE" }, --TODO strikethrough ?
        --CmpItemAbbrMatch = { fg = c.fn, bg = "NONE" },
        CmpItemAbbrMatchFuzzy = { link = "CmpItemAbbrMatch" },
        --CmpItemKindDefault = { fg = c.dep, bg = "NONE" },
        --CmpItemMenu = { fg = c.fg_comment, bg = "NONE" },
        --CmpItemKindVariable = { fg = c.fg_dark, bg = "NONE" },
        CmpItemKindFunction = { link = "Function" },
        CmpItemKindMethod = { link = "Function" },
        CmpItemKindConstructor = { link = "TSConstructor" },
        CmpItemKindClass = { link = "Type" },
        CmpItemKindInterface = { link = "Type" },
        CmpItemKindStruct = { link = "Type" },
        CmpItemKindProperty = { link = "TSProperty" },
        CmpItemKindField = { link = "TSField" },
        CmpItemKindEnum = { link = "Identifier" },
        --CmpItemKindSnippet = { fg = c.sp, bg = "NONE" },
        CmpItemKindText = { link = "TSText" },
        CmpItemKindModule = { link = "TSInclude" },
        CmpItemKindFile = { link = "Directory" },
        CmpItemKindFolder = { link = "Directory" },
        CmpItemKindKeyword = { link = "TSKeyword" },
        CmpItemKindTypeParameter = { link = "Identifier" },
        CmpItemKindConstant = { link = "Constant" },
        CmpItemKindOperator = { link = "Operator" },
        CmpItemKindReference = { link = "TSParameterReference" },
        CmpItemKindEnumMember = { link = "TSField" },

        CmpItemKindValue = { link = "String" },
        --CmpItemKindUnit = {},
        --CmpItemKindEvent = {},
        --CmpItemKindColor = {},
    }

    theme.defer = {}

    if config.hideInactiveStatusline then
        local inactive = { style = "underline", bg = c.bg, fg = c.bg, sp = c.border }

        -- StatusLineNC
        theme.base.StatusLineNC = inactive

        -- LuaLine
        for _, section in ipairs({ "a", "b", "c" }) do
            theme.defer["lualine_" .. section .. "_inactive"] = inactive
        end
    end

    return theme
end

return M
