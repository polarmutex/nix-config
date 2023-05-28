_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.helix;
in {
  config = lib.mkIf cfg.enable {
    programs.helix.languages = {
      language = [
        {
          name = "cpp";
          auto-format = true;
          file-types = ["cpp" "cc" "cxx" "hpp"];
          formatter.command = "${pkgs.clang-tools}/bin/clang-format";
          language-server.command = "${pkgs.clang-tools}/bin/clangd";
        }

        {
          name = "nix";
          auto-format = true;
          file-types = ["nix"];
          language-server.command = "${pkgs.nil}/bin/nil";
          formatter.command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
          roots = ["flake.nix"];
        }

        {
          name = "rust";
          auto-format = true;
          language-server.command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
          formatter.command = "${pkgs.rustfmt}/bin/rustfmt";
        }
      ];

      settings = {
        theme = "kanagawa";

        keys = {
          normal = {
            "{" = "goto_prev_paragraph";
            "}" = "goto_next_paragraph";

            space = {
              space = "file_picker";
              w = ":w";
              q = ":q";
              "C-d" = ["half_page_down" "align_view_center"];
              "C-u" = ["half_page_up" "align_view_center"];
              "C-q" = ":bc";

              u = {
                f = ":format";
                w = ":set whitespace.render all";
                W = ":set whitespace.render none";
              };
            };
          };

          select."%" = "match_brackets";
        };

        editor = {
          color-modes = true;
          cursorline = false;
          idle-timeout = 1;
          line-number = "absolute";
          scrolloff = 5;
          bufferline = "multiple";
          true-color = true;
          lsp.display-messages = true;
          indent-guides.render = false;
          gutters = ["diagnostics" "spacer" "diff"];

          statusline = {
            separator = "|";
            left = [];
            center = [];
            right = ["file-name" "position" "mode"];

            mode = {
              normal = "N";
              insert = "I";
              select = "S";
            };
          };

          whitespace.characters = {
            space = "·";
            nbsp = "⍽";
            tab = "→";
            newline = "⤶";
          };

          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "block";
          };
        };
      };
    };
  };
}
