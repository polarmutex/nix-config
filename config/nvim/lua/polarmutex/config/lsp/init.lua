local util = require("polarmutex.util")
local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")
local lspstatus = require("lsp-status")

require("polarmutex.config.lsp.diagnostics")
require("polarmutex.config.lsp.kind").setup()

local function on_attach(client, bufnr)
    require("polarmutex.config.lsp.formatting").setup(client, bufnr)
    require("polarmutex.config.lsp.keys").setup(client, bufnr)
    require("polarmutex.config.lsp.completion").setup(client, bufnr)
    require("polarmutex.config.lsp.highlighting").setup(client)

    -- TypeScript specific stuff
    if client.name == "typescript" or client.name == "tsserver" then
        require("polarmutex.config.lsp.ts-utils").setup(client)
    end
end

if not configs.astro_ls then
    configs.astro_ls = {
        default_config = {
            cmd = { vim.fn.expand("~/repos/astro-language-tools/node_modules/.bin/astro-ls"), "--stdio" },
            filetypes = {
                "astro",
            },
            root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git"),
        },
        docs = {
            description = [[
https://github.com/withastro/astro-language-tools
```
]],
        },
    }
end

local servers = {
    --pyright = {
    --    settingss = {
    --        python = {
    --            analysis = {
    --                autoSearchPaths = true,
    --                diagnosticMode = "openFilesOnly",
    --                --diagnosticMode = "workspace",
    --                --typeCheckingMode = "strict",
    --            },
    --        },
    --    },
    --},
    pylsp = {},
    bashls = {},
    dockerls = {},
    tsserver = {},
    rnix = {},
    jsonls = { cmd = { "vscode-json-languageserver", "--stdio" } },
    html = { cmd = { "html-languageserver", "--stdio" } },
    clangd = {},
    -- gopls = {},
    sumneko_lua = require("lua-dev").setup({
        -- library = { plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" } },
        lspconfig = { cmd = { "lua-language-server" } },
    }),
    --efm = require("polarmutex.config.lsp.efm").config,
    vimls = {},
    beancount = {
        cmd = {
            --"beancount-language-server",
            "/home/polar/repos/personal/beancount-language-server/master/target/debug/beancount-language-server",
        },
        init_options = {
            journal_file = "/home/polar/repos/personal/beancount/journal.beancount",
        },
    },
    rust_analyzer = {},
    svelte = {},
    astro_ls = {},
    --jdtls = {},
}
require("polarmutex.config.lsp.java")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("keep", capabilities, lspstatus.capabilities)
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local options = {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
        debounce_text_changes = 150,
    },
}

require("polarmutex.config.lsp.null-ls").setup(options)

for server, config in pairs(servers) do
    lspconfig[server].setup(vim.tbl_deep_extend("force", {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {
            debounce_text_changes = 150,
        },
    }, config))
    local cfg = lspconfig[server]
    if not (cfg and cfg.cmd and vim.fn.executable(cfg.cmd[1]) == 1) then
        --util.error(server .. ": cmd not found: " .. vim.inspect(cfg.cmd))
    end
end
