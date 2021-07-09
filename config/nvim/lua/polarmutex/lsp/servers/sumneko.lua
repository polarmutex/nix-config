local lspconfig = require("lspconfig")
local lspname = "sumneko_lua"
local install_path = vim.fn.stdpath("data") .. "/lspinstall/" .. lspname
local custom_on_attach = require('polarmutex.lsp.attach').default_custom_on_attach

local library = {}

local path = vim.split(package.path, ";")

-- this is the ONLY correct way to setup your path
table.insert(path, "lua/?.lua")
table.insert(path, "lua/?/init.lua")

local function add(lib)
  for _, p in pairs(vim.fn.expand(lib, false, true)) do
    p = vim.loop.fs_realpath(p)
    library[p] = true
  end
end

-- add runtime
add("$VIMRUNTIME")

-- add your config
add("~/.config/nvim")

-- add plugins
-- if you're not using packer, then you might need to change the paths below
add("~/.local/share/nvim/site/pack/packer/opt/*")
add("~/.local/share/nvim/site/pack/packer/start/*")

lspconfig[lspname].setup{
    cmd = { install_path .. "/sumneko-lua-language-server" },
    on_new_config = function(config, root)
        local libs = vim.tbl_deep_extend("force", {}, library)
        libs[root] = nil
        config.settings.Lua.workspace.library = libs
        return config
    end,
    settings = {
        Lua = {
            runtime = {
                -- LuaJIT in the case of Neovim
                version = "LuaJIT",
                path = path,
            },
            completion = { callSnippet = "Both" },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {
                    "vim", -- Packer
                },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = library,
                maxPreload = 2000,
                preloadFileSize = 50000
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = { enable = false }
        },
    },
    on_attach = custom_on_attach,
}
