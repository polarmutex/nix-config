local M = {}

---@alias lsp.Client.filter {id?: number, bufnr?: number, name?: string, method?: string, filter?:fun(client: lsp.Client):boolean}

---@param opts? lsp.Client.filter
function M.get_clients(opts)
    local ret ---@type vim.lsp.Client[]
    if vim.lsp.get_clients then
        ret = vim.lsp.get_clients(opts)
    else
        ---@diagnostic disable-next-line: deprecated
        ret = vim.lsp.get_active_clients(opts)
        if opts and opts.method then
            ---@param client vim.lsp.Client
            ret = vim.tbl_filter(function(client)
                return client.supports_method(opts.method, { bufnr = opts.bufnr })
            end, ret)
        end
    end
    return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

---@param opts? LazyFormatter| {filter?: (string|lsp.Client.filter)}
function M.formatter(opts)
    opts = opts or {}
    local filter = opts.filter or {}
    filter = type(filter) == "string" and { name = filter } or filter
    ---@cast filter lsp.Client.filter
    ---@type LazyFormatter
    local ret = {
        name = "LSP",
        primary = true,
        priority = 1,
        format = function(buf)
            M.format(require("polar.utils").merge({}, filter, { bufnr = buf }))
        end,
        sources = function(buf)
            local clients = M.get_clients(require("polar.utils").merge({}, filter, { bufnr = buf }))
            ---@param client vim.lsp.Client
            local ret = vim.tbl_filter(function(client)
                return client.supports_method("textDocument/formatting")
                    or client.supports_method("textDocument/rangeFormatting")
            end, clients)
            ---@param client vim.lsp.Client
            return vim.tbl_map(function(client)
                return client.name
            end, ret)
        end,
    }
    return require("polar.utils").merge(ret, opts) --[[@as LazyFormatter]]
end

---@param opts? lsp.Client.format
function M.format(opts)
    opts = vim.tbl_deep_extend(
        "force",
        {},
        opts or {}
        -- LazyVim.opts("nvim-lspconfig").format or {},
        -- LazyVim.opts("conform.nvim").format or {}
    )
    local ok, conform = pcall(require, "conform")
    -- use conform for formatting with LSP when available,
    -- since it has better format diffing
    if ok then
        opts.formatters = {}
        conform.format(opts)
    else
        vim.lsp.buf.format(opts)
    end
end

return M
