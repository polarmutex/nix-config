-- from
-- https://github.com/nvim-lua/lsp_extensions.nvim/blob/master/lua/lsp_extensions/workspace/diagnostic.lua
-- Get the counts from your curreent workspace:
-- local ws_errors = require('lsp_extensions.workspace.diagnostic').get_count(0, 'Error')
-- local ws_hints = require('lsp_extensions.workspace.diagnostic').get_count(0, 'Hint')
-- Set the qflist for the current workspace
-- For more information, see `:help vim.lsp.diagnostic.set_loc_list()`, since this has some of the same configuration.
-- require('lsp_extensions.workspace.diagnostic').set_qf_list()
vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(require("polarmutex.lsp.extensions.workspace_diagnostics").handler, {
        underline = true,
        virtual_text = {prefix = "»", spacing = 4},
        signs = {priority = 20},
        update_in_insert = true,
    })
vim.fn.sign_define("LspDiagnosticsSignError",
                   {text = "", texthl = "LspDiagnosticsDefaultError"})
vim.fn.sign_define("LspDiagnosticsSignWarning",
                   {text = "", texthl = "LspDiagnosticsDefaultWarning"})
vim.fn.sign_define("LspDiagnosticsSignInformation",
                   {text = "", texthl = "LspDiagnosticsDefaultInformation"})
vim.fn.sign_define("LspDiagnosticsSignHint",
                   {text = "", texthl = "LspDiagnosticsDefaultHint"})
vim.cmd([[autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()]])
vim.cmd([[autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()]])

vim.lsp.handlers["textDocument/hover"] = require("lspsaga.hover").handler

local ns_rename = vim.api.nvim_create_namespace("polarmutex_rename")

local saga_config = require("lspsaga").config_values
saga_config.rename_prompt_prefix = ">"

function MyLspRename()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_clear_namespace(bufnr, ns_rename, 0, -1)

    local current_word = vim.fn.expand("<cword>")

    local has_saga, saga = pcall(require, "lspsaga.rename")
    if has_saga then
        local line, col = vim.fn.line("."), vim.fn.col(".")
        local contents = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1]

        local has_found_highlights, start, finish = false, 0, -1
        while not has_found_highlights do
            start, finish = contents:find(current_word, start + 1, true)

            if not start or not finish then break end

            if start <= col and finish >= col then
                has_found_highlights = true
            end
        end

        if has_found_highlights then
            vim.api.nvim_buf_add_highlight(bufnr, ns_rename, "Visual", line - 1,
                                           start - 1, finish)
            vim.cmd(string.format(
                        "autocmd BufEnter <buffer=%s> ++once :call nvim_buf_clear_namespace(%s, %s, 0, -1)",
                        bufnr, bufnr, ns_rename))
        end

        saga.rename()

        -- Just make escape quit the window as well.
        vim.api.nvim_buf_set_keymap(0, "n", "<esc>",
                                    "<cmd>lua require(\"lspsaga.rename\").close_rename_win()<CR>",
                                    {noremap = true, silent = true})

        return
    end

    local plenary_window = require("plenary.window.float").percentage_range_window(0.5,
                                                                                   0.2)
    vim.api.nvim_buf_set_option(plenary_window.bufnr, "buftype", "prompt")
    vim.fn.prompt_setprompt(plenary_window.bufnr,
                            string.format("Rename \"%s\" to > ", current_word))
    vim.fn.prompt_setcallback(plenary_window.bufnr, function(text)
        vim.api.nvim_win_close(plenary_window.win_id, true)

        if text ~= "" then
            vim.schedule(function()
                vim.api.nvim_buf_delete(plenary_window.bufnr, {force = true})
                vim.lsp.buf.rename(text)
            end)
        else
            print("Nothing to rename!")
        end
    end)

    vim.cmd([[startinsert]])
end
