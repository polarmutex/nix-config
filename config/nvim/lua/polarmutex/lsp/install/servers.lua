local servers = {
    ["bashls"] = require("polarmutex.lsp.install.servers.bashls"),
    ["cmake"] = require("polarmutex.lsp.install.servers.cmake"),
    ["dockerls"] = require("polarmutex.lsp.install.servers.dockerls"),
    ["efm"] = require("polarmutex.lsp.install.servers.efm"),
    ["gopls"] = require("polarmutex.lsp.install.servers.gopls"),
    ["sumneko"] = require("polarmutex.lsp.install.servers.sumneko"),
    ["pyright"] = require("polarmutex.lsp.install.servers.pyright"),
    ["rust_analyzer"] = require("polarmutex.lsp.install.servers.rust_analyzer"),
    ["svelte"] = require("polarmutex.lsp.install.servers.svelte"),
    ["tailwindcss"] = require("polarmutex.lsp.install.servers.tailwindcss"),
    ["typescript"] = require("polarmutex.lsp.install.servers.typescript"),
    ["vimls"] = require("polarmutex.lsp.install.servers.vimls"),
}

return servers
