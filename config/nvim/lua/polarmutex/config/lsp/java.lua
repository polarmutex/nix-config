local function on_attach(client, bufnr)
    require("polarmutex.config.lsp.formatting").setup(client, bufnr)
    require("polarmutex.config.lsp.keys").setup(client, bufnr)
    require("polarmutex.config.lsp.completion").setup(client, bufnr)
    require("polarmutex.config.lsp.highlighting").setup(client)
end

local M = {}

function M.setup()
    local root_markers = { "gradlew", "pom.xml" }
    local root_dir = require("jdtls.setup").find_root(root_markers)
    local home = os.getenv("HOME")

    local capabilities = {
        workspace = {
            configuration = true,
        },
        textDocument = {
            completion = {
                completionItem = {
                    snippetSupport = true,
                },
            },
        },
    }

    local workspace_folder = home .. "/.workspace" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
    local config = {
        flags = {
            allow_incremental_sync = true,
        },
        capabilities = capabilities,
        on_attach = on_attach,
    }

    config.settings = {
        java = {
            signatureHelp = { enabled = true },
            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                },
            },
            configuration = {
                runtimes = {
                    {
                        name = "JavaSE-8",
                        path = "/usr/lib/jvm/java-8-openjdk-amd64/",
                    },
                },
            },
        },
    }
    config.cmd = { "jdt-ls", "-data", workspace_folder }
    config.on_attach = on_attach
    config.on_init = function(client, _)
        client.notify("workspace/didChangeConfiguration", { settings = config.settings })
    end

    local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
    extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
    config.init_options = {
        -- bundles = bundles;
        extendedClientCapabilities = extendedClientCapabilities,
    }

    -- Server
    require("jdtls").start_or_attach(config)
end

vim.api.nvim_exec(
    [[
    augroup jdtls
    autocmd!
    autocmd FileType java lua require('polarmutex.config.lsp.java').setup()
augroup END
]],
    false
)

return M
