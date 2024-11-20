{
  # inputs,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    zed-editor
    xdg-utils
    (pkgs.rust-bin.stable.latest.default.override {
      targets = ["x86_64-unknown-linux-gnu" "wasm32-wasip1"];
      # extensions = [ "rust-analyzer" "rust-src" "rust-std" ];
    })
    patchelf
    clang-tools_18
  ];
  home.file.".config/zed/settings.json".text = let
    jsonGenerator = lib.generators.toJSON {};
  in
    jsonGenerator {
      auto_install_extensions = {
        asciidoc = true;
        basedpyright = true;
        # beancount = true;
        lua = true;
        kanagawa_themes = true;
        justfile = true;
        nix = true;
        make = true;
        ruff = true;
        toml = true;
        tokyo_night_themes = true;
        xml = true;
      };
      auto_update = false;
      buffer_font_family = "MonoLisa";
      buffer_font_fallbacks = ["Symbols Nerd Font"];
      gutter = {
        folds = false;
      };
      inlay_hints = {
        enabled = true;
      };
      load_direnv = "shell_hook";
      journal = {
        hour_format = "hour24";
      };
      project_panel = {
        dock = "right";
        scrollbar = {
          show = "never";
        };
      };
      scrollbar = {
        show = "never";
      };
      tab_bar = {
        show = false;
      };
      tab_size = 2;
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      theme = {
        mode = "system";
        dark = "Tokyo Night";
        light = "Tokyo Night";
      };
      toolbar = {
        breadcrumbs = true;
        quick_actions = false;
      };
      ui_font_size = 16;
      vim_mode = true;
      lsp = {
        beancount-language-server = {
          binary = {
            path = "/home/polar//repos/personal/beancount-language-server/main/target/debug/beancount-language-server";
            args = ["--log"];
          };
          initialization_options = {
            journal_file = "~/repos/personal/beancount/main/main.beancount";
          };
        };
        nixd = {
          binary = {
            path = "${pkgs.nixd}/bin/nixd";
          };
        };
      };
    };
}
