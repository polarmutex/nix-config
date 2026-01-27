local yaml_lsp_cmd = "yaml-language-server"

-- Check if lua-language-server is available
if vim.fn.executable(yaml_lsp_cmd) ~= 1 then
    return
end

vim.lsp.start({
    name = "yaml-ls",
    cmd = { yaml_lsp_cmd, "--stdio" },
    root_dir = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1]),
    filetypes = { "yaml", "yaml.docker-compose" },
    capabilities = require("polar.lsp").make_client_capabilities(),
    settings = {
        yaml = {
            schemas = require("schemastore").yaml.schemas(),
        },
    },
})

-- vim.wo[0].spell = false
