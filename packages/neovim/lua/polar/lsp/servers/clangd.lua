local function handler(_err, uri)
    if not uri or uri == "" then
        vim.api.nvim_echo({ { "Corresponding file cannot be determined" } }, false, {})
        return
    end
    local file_name = vim.uri_to_fname(uri)
    vim.api.nvim_cmd({
        cmd = "edit",
        args = { file_name },
    }, {})
end

---@type vim.lsp.Config
return {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
    },
    filetypes = { "cpp" },
    capabilities = {
        offsetEncoding = { "utf-16" },
    },
    init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
    },
    on_init = function()
        vim.api.nvim_create_user_command("ClangdSwitchSourceHeader", function()
            vim.lsp.buf_request(0, "textDocument/switchSourceHeader", {
                uri = vim.uri_from_bufnr(0),
            }, handler)
        end, {})
    end,
    on_exit = function()
        vim.api.nvim_del_user_command("ClangdSwitchSourceHeader")
    end,
}
