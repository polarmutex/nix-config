local dap = require("dap")

dap.set_log_level("TRACE")

dap.defaults.fallback.external_terminal = { command = "st", args = { "-e" } }

-- load vscode launch configs
require("dap.ext.vscode").load_launchjs()

-- Python Debugging
require("dap-python").setup("python")

-- Nodejs debugging
-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#javascript
dap.adapters.node2 = {
    type = "executable",
    command = "node",
    args = { os.getenv("HOME") .. "/repos/vscode-node-debug2/out/src/nodeDebug.js" },
    -- console = "externalTerminal",
}
dap.configurations.typescript = {
    {
        type = "node2",
        request = "attach",
        -- program = '${file}',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        skipFiles = { "<node_internals>/**/*.js" },
        protocol = "inspector",
        -- console = 'integratedTerminal',
        console = "integratedConsole",
        -- console = 'externalTerminal',
        -- outputCapture = "std",
        -- externalConsole = true,
    },
}
