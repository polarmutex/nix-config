local config = require("lspconfig").rust_analyzer.document_config
require("lspconfig/configs").rust_analyzer = nil -- important, immediately unset the loaded config again
config.default_config.cmd[1] = "./rust-analyzer"

return vim.tbl_extend("error", config, {
    -- adjusted from https://github.com/mattn/vim-lsp-settings/blob/master/installer/install-rust-analyzer.sh
    install_script = [[
        os=$(uname -s | tr "[:upper:]" "[:lower:]")
        case $os in
        linux)
        platform="linux"
        ;;
        darwin)
        platform="mac"
        ;;
        esac
        curl -L -o "rust-analyzer-$platform" "https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-$platform"
        mv rust-analyzer-$platform rust-analyzer
        chmod +x rust-analyzer
    ]],
})
