vim.diagnostic.config({
    underline = true,
    virtual_text = {
        severity = nil,
        source = "if_many",
        format = nil,
    },
    signs = true,

    -- options for floating windows:
    float = {
        show_header = true,
    },

    -- general purpose
    severity_sort = true,
    update_in_insert = false,
})
