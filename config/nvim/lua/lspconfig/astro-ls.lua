local configs = require("lspconfig/configs")
local util = require("lspconfig/util")

configs.astro_ls = {
    default_config = {
        cmd = { vim.fn.expand("~/repos/astro-language-tools/node_modules/.bin/astro-ls"), "--stdio" },
        filetypes = {
            "astro",
        },
        root_dir = util.root_pattern("package.json", "tsconfig.json", ".git"),
    },
    docs = {
        description = [[
https://github.com/withastro/astro-language-tools
```
]],
    },
}
