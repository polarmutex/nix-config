local root_files = {
    "flake.nix",
    ".git",
}

---@type vim.lsp.Config
return {
    cmd = { "nixd" },
    filetypes = { "nix" },
    single_file_support = true,
    root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
    capabilities = require("polar.lsp").make_client_capabilities(),
    settings = {
        nixd = {
            formatting = {
                command = { "alejandra", "-qq" },
            },
        },
        -- flake = {
        --     autoArchive = true,
        --     autoEvalInputs = true,
        -- },
    },
}
