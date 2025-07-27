{
  lib,
  pkgs,
  ...
}:
with lib; {
  # Install Zed editor system-wide
  environment.systemPackages = with pkgs; [
    unstable.zed-editor
    xdg-utils

    # Rust development tools
    rustup
    rust-analyzer
    cargo
    clippy
    rustfmt
    patchelf
    clang-tools_18
    gcc
  ];

  # Configure nix-maid for Zed configuration management
  users.users.polar = {
    maid = {
      # nix-maid configuration
      packages = [
      ];
      # file.xdg_config."zed/settings.json".text = builtins.toJSON {
      #   auto_install_extensions = {
      #     # asciidoc = true;
      #     basedpyright = true;
      #     lua = true;
      #     kanagawa_themes = true;
      #     justfile = true;
      #     nix = true;
      #     make = true;
      #     ruff = true;
      #     toml = true;
      #     tokyo_night_themes = true;
      #     xml = true;
      #     rust = true;
      #   };
      #   auto_update = false;
      #   buffer_font_family = "MonoLisa";
      #   buffer_font_fallbacks = ["Symbols Nerd Font"];
      #   gutter.folds = false;
      #   inlay_hints.enabled = true;
      #   load_direnv = "shell_hook";
      #   journal.hour_format = "hour24";
      #   project_panel = {
      #     dock = "right";
      #     scrollbar.show = "never";
      #   };
      #   scrollbar.show = "never";
      #   tab_bar.show = false;
      #   tab_size = 2;
      #   telemetry = {
      #     diagnostics = false;
      #     metrics = false;
      #   };
      #   theme = {
      #     mode = "system";
      #     dark = "Tokyo Night";
      #     light = "Tokyo Night";
      #   };
      #   toolbar = {
      #     breadcrumbs = true;
      #     quick_actions = false;
      #   };
      #   ui_font_size = 16;
      #   vim_mode = true;
      #   lsp = {
      #     nixd = {
      #       binary.path = "${pkgs.nixd}/bin/nixd";
      #     };
      #     rust-analyzer = {
      #       binary.path = "${pkgs.rust-analyzer}/bin/rust-analyzer";
      #     };
      #   };
      # };
      # file.xdg_config."zed/keymap.json".text = builtins.toJSON [
      #   {
      #     context = "Editor && vim_mode == normal";
      #     bindings = {
      #       "space f" = "file_finder::Toggle";
      #       "space g" = "project_search::ToggleFocus";
      #       "space t" = "terminal_panel::ToggleFocus";
      #       "space e" = "project_panel::ToggleFocus";
      #     };
      #   }
      # ];
    };
  };

  # Ensure rust toolchain is available for extension development
  # environment.variables = mkIf cfg.enableRustDevelopment {
  #   RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  # };

  # Enable necessary system services for development
  # programs.nix-ld.enable = mkIf cfg.enableRustDevelopment true;
}
