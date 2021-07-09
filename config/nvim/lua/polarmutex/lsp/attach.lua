local wk = require("which-key")

local M = {}

M.default_custom_on_attach = function(client, bufnr, user_opts)
    local opts = user_opts or {auto_format = false, lsp_highlights = false}
    local auto_format = opts.auto_format or false
    local lsp_highlights = opts.lsp_highlights or false

    local mapping_opts = {noremap = true, silent = true, buffer = bufnr}
    local keymap = {
        c = {
            name = "+code",
            r = {"<cmd>lua require('lspsaga.rename').rename()<CR>", "Rename"},
            a = {
                "<cmd>lua require('lspsaga.codeaction').code_action()<CR>",
                "Code Action"
            },
            d = {
                "<cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>",
                "Line Diagnostics"
            },
            l = {
                name = "+lsp",
                i = {"<cmd>LspInfo<cr>", "Lsp Info"},
                a = {"<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", "Add Folder"},
                r = {
                    "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
                    "Remove Folder"
                },
                l = {
                    "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
                    "List Folders"
                }
            }
        },
        x = {
            s = {
                "<cmd>Telescope lsp_document_diagnostics<cr>",
                "Search Document Diagnostics"
            },
            w = {
                "<cmd>Telescope lsp_workspace_diagnostics<cr>", "Workspace Diagnostics"
            }
        }
    }

    local keymap_visual = {c = {name = "+code"}}

    local keymap_goto = {
        name = "+goto",
        r = {"<cmd>Telescope lsp_references<cr>", "References"},
        R = {"<cmd>LspTrouble lsp_references<cr>", "Trouble References"},
        D = {
            "<cmd>lua require'lspsaga.provider'.preview_definition()<CR>",
            "Peek Definition"
        },
        d = {"<Cmd>lua vim.lsp.buf.definition()<CR>", "Goto Definition"},
        s = {
            "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>",
            "Signature Help"
        },
        I = {"<cmd>lua vim.lsp.buf.implementation()<CR>", "Goto Implementation"},
        -- I = { "<Cmd>lua vim.lsp.buf.declaration()<CR>", "Goto Declaration" },
        t = {"<cmd>lua vim.lsp.buf.type_definition()<CR>", "Goto Type Definition"}
    }

    if lsp_highlights and client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec([[
        augroup lsp_document_highlight
            autocmd!
            autocmd CursorHold,CursorHoldI  <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
        ]], false)
    end

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
        keymap.c.f = {"<cmd>lua vim.lsp.buf.formatting()<CR>", "Format Document"}
    elseif client.resolved_capabilities.document_range_formatting then
        keymap_visual.c.f = {
            "<cmd>lua vim.lsp.buf.range_formatting()<CR>", "Format Range"
        }
    end

    wk.register(keymap, {buffer = bufnr, prefix = "<leader>"})
    wk.register(keymap_visual, {buffer = bufnr, prefix = "<leader>", mode = "v"})
    wk.register(keymap_goto, {buffer = bufnr, prefix = "g"})

    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_formatting then
        if client.name ~= "tsserver" then
            vim.cmd(
                [[ autocmd BufWritePre * :lua vim.lsp.buf.formatting_sync(nil, 250) ]])
        end
    end

    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec([[
            augroup lsp_document_highlight
            autocmd! * <buffer>
            autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
        ]], false)
    end
end

return M
