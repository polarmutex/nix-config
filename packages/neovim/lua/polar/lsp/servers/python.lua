---@type vim.lsp.Config
return {
    cmd = { "basedpyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_dir = vim.fs.dirname(vim.fs.find({ ".git", "setup.py", "setup.cfg", "pyproject.toml" }, { upward = true })[1]),
    single_file_support = true,
    settings = {
        basedpyright = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
            },
        },
    },
    reuse_client = function(client, conf)
        return client.config.root_dir == conf.root_dir
    end,
}

-- pylsp
-- local config = {
--     name = "pylsp",
--     --name = "pyright",
--     cmd = { python_lsp_cmd },
--     filetypes = { "python" },
--     root_dir = vim.fs.dirname(vim.fs.find({ ".git", "setup.py", "setup.cfg", "pyproject.toml" }, { upward = true })[1]),
--     capabilities = require("polar.lsp").make_client_capabilities(),
--     -- pylsp
--     settings = {
--         pylsp = {
--             plugins = {
--                 black = { enabled = true },
--                 ruff = { enabled = true, extendSelect = { "I" } },
--                 pydocstyle = { enabled = true },
--             },
--         },
--     },
-- }
