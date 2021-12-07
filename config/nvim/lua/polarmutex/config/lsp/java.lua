local function on_attach(client, bufnr)
    --require("polarmutex.config.lsp.formatting").setup(client, bufnr)
    require("polarmutex.config.lsp.keys").setup(client, bufnr)
    require("polarmutex.config.lsp.completion").setup(client, bufnr)
    require("polarmutex.config.lsp.highlighting").setup(client)
    -- With `hotcodereplace = 'auto' the debug adapter will try to apply code changes
    -- you make during a debug session immediately.
    -- Remove the option if you do not want that.
    require("jdtls").setup_dap({ hotcodereplace = "auto" })
    require("jdtls").add_commands()
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

    local workspace_folder = home .. "/.workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
    local config = {
        flags = {
            allow_incremental_sync = true,
        },
        capabilities = capabilities,
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
                        name = "JavaSE-1.8",
                        path = "/usr/lib/jvm/java-8-openjdk-amd64/jre",
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

    local jar_patterns = {
        "~/repos/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
    }
    local bundles = {}
    for _, jar_pattern in ipairs(jar_patterns) do
        for _, bundle in ipairs(vim.split(vim.fn.glob(home .. jar_pattern), "\n")) do
            if not vim.endswith(bundle, "com.microsoft.java.test.runner.jar") then
                table.insert(bundles, bundle)
            end
        end
    end
    local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
    extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
    config.init_options = {
        bundles = bundles,
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
