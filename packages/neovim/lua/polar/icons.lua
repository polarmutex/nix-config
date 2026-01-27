local M = {}

M.caret = {
    caret_down = "",
    caret_left = "",
    caret_right = "",
}

M.dap = {
    Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
    Breakpoint = " ",
    BreakpointCondition = " ",
    BreakpointRejected = { " ", "DiagnosticError" },
    LogPoint = ".>",
}

M.diagnostics = {
    Error = "󰅜 ",
    Warn = " ",
    Hint = " ",
    Info = " ",
}
M.git = {
    added = " ",
    modified = " ",
    removed = " ",
    branch = " ",
}

M.kinds = {
    Array = " ",
    Boolean = " ",
    Class = " ",
    Color = " ",
    Constant = " ",
    Constructor = " ",
    Copilot = " ",
    Enum = " ",
    EnumMember = " ",
    Event = " ",
    Field = " ",
    File = " ",
    Folder = " ",
    Function = " ",
    Interface = " ",
    Key = " ",
    Keyword = " ",
    Method = " ",
    Module = " ",
    Namespace = " ",
    Null = " ",
    Number = " ",
    Object = " ",
    Operator = " ",
    Package = " ",
    Property = " ",
    Reference = " ",
    Snippet = " ",
    String = " ",
    Struct = " ",
    Text = " ",
    TypeParameter = " ",
    Unit = " ",
    Value = " ",
    Variable = " ",
}

M.misc = {
    check = " ",
    folder = "󰉋 ",
    search = " ",
    tree = " ",
}

M.separators = {
    bar = "│",
    bar2 = "￨", -- Halfwidth Forms Light Vertical (U+FFE8)
    bar_left = "▏", -- U+258F
    bar_right = "▕", -- U+2595
    chevron_left = "",
    chevron_right = "",
    triangle_left = "",
    triangle_right = "",
}

return M
