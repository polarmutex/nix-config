local nls = require("null-ls")
local lspconfig = require("lspconfig")

local M = {}

function M.setup(options)
    nls.setup({
        debounce = 150,
        save_after_format = false,
        sources = {
            nls.builtins.formatting.prettierd,
            --.with({
            --    filetypes = {
            --        "astro",
            --        "javascript",
            --        "javascriptreact",
            --        "typescript",
            --        "typescriptreact",
            --        "css",
            --        "scss",
            --        "html",
            --        "json",
            --        "yaml",
            --        "markdown",
            --    },
            --}),
            nls.builtins.formatting.stylua.with({
                args = { "--config-path", vim.fn.stdpath("config") .. "/lua/stylua.toml", "-" },
            }),
            nls.builtins.formatting.eslint_d,
            --nls.builtins.diagnostics.shellcheck,
            nls.builtins.diagnostics.markdownlint,
            --nls.builtins.diagnostics.selene,
            --nls.builtins.formatting.black,
            --nls.builtins.formatting.isort,
            --nls.builtins.diagnostics.flake8,
            nls.builtins.diagnostics.mypy,
        },
        on_attach = options.on_attach,
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".nvim.settings.json", ".git"),
    })
end

function M.has_formatter(ft)
    local sources = require("null-ls.sources")
    local available = sources.get_available(ft, "NULL_LS_FORMATTING")
    return #available > 0
end

return M
