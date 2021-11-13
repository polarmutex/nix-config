local nls = require("null-ls")
local lspconfig = require("lspconfig")

local M = {}

function M.setup(options)
    nls.config({
        debounce = 150,
        save_after_format = false,
        sources = {
            nls.builtins.formatting.prettierd,
            nls.builtins.formatting.stylua.with({
                args = { "--config-path", vim.fn.stdpath("config") .. "/lua/stylua.toml", "-" },
            }),
            nls.builtins.formatting.eslint_d,
            --nls.builtins.diagnostics.shellcheck,
            nls.builtins.diagnostics.markdownlint,
            --nls.builtins.diagnostics.selene,
            nls.builtins.formatting.black,
            nls.builtins.formatting.isort,
            nls.builtins.diagnostics.flake8,
        },
    })
    lspconfig["null-ls"].setup(options)
end

function M.has_formatter(ft)
    local config = require("null-ls.config").get()
    local sources = config.sources
    for _, f in ipairs(sources) do
        if vim.tbl_contains(f.method, "NULL_LS_FORMATTING") then
            if vim.tbl_contains(f.filetypes, ft) then
                return true
            end
        end
    end
end

return M
