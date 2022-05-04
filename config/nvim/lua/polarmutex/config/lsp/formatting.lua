local util = require("polarmutex.util")

local M = {}

-- vim.lsp.handlers["textDocument/hover"] = function(_, method, result)
--   print(vim.inspect(result))
-- end

M.autoformat = true

function M.toggle()
    M.autoformat = not M.autoformat
    if M.autoformat then
        util.info("enabled format on save", "Formatting")
    else
        util.warn("disabled format on save", "Formatting")
    end
end

function M.format()
    if M.autoformat then
        vim.lsp.buf.format()
    end
end

function M.setup(client, buf)
    local ft = vim.api.nvim_buf_get_option(buf, "filetype")
    local nls = require("polarmutex.config.lsp.null-ls")

    local enable = false
    if nls.has_formatter(ft) then
        enable = client.name == "null-ls"
    else
        enable = not (client.name == "null-ls")
    end

    client.resolved_capabilities.document_formatting = enable
    -- format on save
    if client.resolved_capabilities.document_formatting then
        vim.cmd([[
      augroup LspFormat
        autocmd! * <buffer>
        autocmd BufWritePre <buffer> lua require("polarmutex.config.lsp.formatting").format()
      augroup END
    ]]   )
    end
end

return M
