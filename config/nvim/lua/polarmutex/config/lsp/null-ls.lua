local nls = require("null-ls")

local M = {}

function M.setup(on_attach)
    nls.setup({
        debounce = 150,
        save_after_format = false,
        on_attach = on_attach,
        sources = {
            nls.builtins.formatting.prettierd,
            nls.builtins.formatting.stylua.with({
                args = { "--config-path", vim.fn.stdpath("config") .. "/lua/stylua.toml", "-" },
            }),
            nls.builtins.formatting.eslint_d,
            --nls.builtins.diagnostics.shellcheck,
            nls.builtins.diagnostics.markdownlint,
            --nls.builtins.diagnostics.selene,
        },
    })
end

function M.has_formatter(ft)
    local config = require("null-ls.config").get()
    local formatters = config._generators["NULL_LS_FORMATTING"]
    for _, f in ipairs(formatters) do
        if vim.tbl_contains(f.filetypes, ft) then
            return true
        end
    end
end

return M
