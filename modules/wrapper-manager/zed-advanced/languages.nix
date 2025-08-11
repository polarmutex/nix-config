# Language-specific configurations for Zed Advanced
{ lib, pkgs, ... }:

with lib;

{
  # Create language configurations based on available packages
  createLanguageConfigs = { beancountLsp ? null, journalFile ? null }: {
    
    # Rust configuration
    "Rust" = {
      formatter = { language_server = { name = "rust-analyzer"; }; };
      format_on_save = "language_server";
      language_servers = ["rust-analyzer"];
      inlay_hints = {
        enabled = true;
        show_type_hints = true;
        show_parameter_hints = true;
        show_other_hints = true;
      };
      tab_size = 4;
      preferred_line_length = 100;
    };
    
    # Python configuration
    "Python" = {
      format_on_save = { language_server = { name = "ruff"; }; };
      formatter = { language_server = { name = "ruff"; }; };
      language_servers = ["pyright" "ruff"];
      tab_size = 4;
      preferred_line_length = 88;
      inlay_hints = {
        enabled = true;
        show_type_hints = true;
        show_parameter_hints = false;
      };
    };
    
    # Java configuration
    "Java" = {
      formatter = { language_server = { name = "jdtls"; }; };
      format_on_save = "language_server";
      language_servers = ["jdtls"];
      tab_size = 4;
      preferred_line_length = 120;
      inlay_hints = {
        enabled = true;
        show_type_hints = true;
        show_parameter_hints = false;
      };
    };
    
    # C++ configuration
    "C++" = {
      formatter = { language_server = { name = "clangd"; }; };
      format_on_save = "language_server";
      language_servers = ["clangd"];
      preferred_line_length = 100;
      tab_size = 2;
      inlay_hints = {
        enabled = true;
        show_type_hints = true;
        show_parameter_hints = true;
      };
    };
    
    # C configuration
    "C" = {
      formatter = { language_server = { name = "clangd"; }; };
      format_on_save = "language_server";
      language_servers = ["clangd"];
      preferred_line_length = 100;
      tab_size = 2;
    };
    
    # Nix configuration
    "Nix" = {
      formatter = { language_server = { name = "nixd"; }; };
      format_on_save = "language_server";
      language_servers = ["nixd"];
      tab_size = 2;
      preferred_line_length = 100;
    };
    
    # JavaScript/TypeScript configuration
    "JavaScript" = {
      formatter = { language_server = { name = "prettier"; }; };
      format_on_save = "language_server";
      language_servers = ["typescript-language-server"];
      tab_size = 2;
      preferred_line_length = 100;
    };
    
    "TypeScript" = {
      formatter = { language_server = { name = "prettier"; }; };
      format_on_save = "language_server";
      language_servers = ["typescript-language-server"];
      tab_size = 2;
      preferred_line_length = 100;
      inlay_hints = {
        enabled = true;
        show_type_hints = true;
        show_parameter_hints = false;
        show_other_hints = true;
      };
    };
    
    # TOML configuration
    "TOML" = {
      tab_size = 2;
      preferred_line_length = 100;
    };
    
    # YAML configuration  
    "YAML" = {
      tab_size = 2;
      preferred_line_length = 100;
    };
    
    # JSON configuration
    "JSON" = {
      tab_size = 2;
      preferred_line_length = 100;
    };
    
    # Markdown configuration
    "Markdown" = {
      soft_wrap = "preferred_line_length";
      preferred_line_length = 80;
      tab_size = 2;
    };
    
    # Beancount configuration (conditional)
  } // (lib.optionalAttrs (beancountLsp != null) {
    "Beancount" = {
      format_on_save = "language_server";
      language_servers = ["beancount-language-server"];
      tab_size = 2;
      preferred_line_length = 120;
      soft_wrap = "preferred_line_length";
    };
  });
  
  # Create LSP configurations
  createLspConfigs = { beancountLsp ? null, journalFile ? null }: {
    
    # Rust LSP
    "rust-analyzer" = {
      initialization_options = {
        diagnostics = {
          experimental = { enable = true; };
          disabled = ["unresolved-proc-macro"];
        };
        checkOnSave = {
          command = "clippy";
          allTargets = false;
        };
        cargo = {
          features = "all";
          loadOutDirsFromCheck = true;
        };
        procMacro = {
          enable = true;
          ignored = {
            async-trait = ["async_trait"];
            napi-derive = ["napi"];
            async-recursion = ["async_recursion"];
          };
        };
        lens = {
          enable = true;
          implementations = { enable = true; };
          references = { enable = true; };
          run = { enable = true; };
          debug = { enable = true; };
        };
        imports = {
          granularity = {
            group = "module";
            enforce = true;
          };
          prefix = "by_self";
        };
        completion = {
          addCallArgumentSnippets = true;
          addCallParenthesis = true;
          postfix = { enable = true; };
          autoimport = { enable = true; };
        };
      };
    };
    
    # Python LSPs
    "pyright" = {
      initialization_options = {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "strict";
              autoImportCompletions = true;
              autoSearchPaths = true;
              diagnosticMode = "workspace";
              useLibraryCodeForTypes = true;
            };
          };
        };
      };
    };
    
    "ruff" = {
      initialization_options = {
        settings = {
          lineLength = 88;
          lint = {
            select = ["E" "F" "W" "C" "N" "D" "UP" "S" "B" "A" "C4" "ICN" "PIE" "PT" "RET" "SIM" "TCH" "ARG" "PTH" "ERA" "PL" "TRY" "FLY" "PERF"];
            ignore = ["D100" "D101" "D102" "D103" "D104" "D105"];
            unfixable = ["F401" "F841"];
          };
          format = {
            quote-style = "double";
            indent-style = "space";
            line-ending = "auto";
          };
        };
      };
    };
    
    # Java LSP
    "jdtls" = {
      initialization_options = {
        workspace = "/tmp/jdtls-workspace";
        settings = {
          java = {
            format = {
              enabled = true;
              settings = {
                url = "./.vscode/java-formatter.xml";
              };
            };
            saveActions = {
              organizeImports = true;
            };
            compile = {
              nullAnalysis = {
                mode = "automatic";
              };
            };
            completion = {
              importOrder = [
                "java"
                "javax"
                "org" 
                "com"
              ];
            };
          };
        };
      };
    };
    
    # C/C++ LSP
    "clangd" = {
      initialization_options = {
        clangdFileStatus = true;
        usePlaceholders = true;
        completeUnimported = true;
        semanticHighlighting = true;
        fallbackFlags = [
          "-std=c++20"
          "-Wall"
          "-Wextra"
          "-Wno-unused-parameter"
        ];
      };
    };
    
    # Nix LSPs
    "nixd" = {
      initialization_options = {
        nixpkgs = {
          expr = "import <nixpkgs> { }";
        };
        formatting = {
          command = ["nixpkgs-fmt"];
        };
        options = {
          nixos = {
            expr = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.\"$(hostname)\".options";
          };
          home_manager = {
            expr = "(builtins.getFlake \"/etc/nixos\").homeConfigurations.\"$(whoami)@$(hostname)\".options";
          };
        };
      };
    };
    
    "nil" = {
      initialization_options = {
        formatting = {
          command = ["nixpkgs-fmt"];
        };
        nix = {
          flake = {
            autoArchive = true;
          };
        };
      };
    };
    
    # TypeScript LSP
    "typescript-language-server" = {
      initialization_options = {
        preferences = {
          inlayHints = {
            includeInlayEnumMemberValueHints = true;
            includeInlayFunctionLikeReturnTypeHints = true;
            includeInlayFunctionParameterTypeHints = true;
            includeInlayParameterNameHints = "all";
            includeInlayParameterNameHintsWhenArgumentMatchesName = true;
            includeInlayPropertyDeclarationTypeHints = true;
            includeInlayVariableTypeHints = true;
          };
        };
      };
    };
    
  } // (lib.optionalAttrs (beancountLsp != null && journalFile != null) {
    # Beancount LSP (conditional)
    "beancount-language-server" = {
      binary = {
        path = "beancount-language-server";  # Will be in PATH via wrapper
        arguments = ["--log"];
      };
      initialization_options = {
        journal_file = "\${ZED_BEANCOUNT_JOURNAL}";  # From env var
        bean_check = {
          method = "python-embedded";
        };
        completion = {
          enable = true;
          accounts = true;
          payees = true;
          narrations = true;
        };
        diagnostics = {
          enable = true;
          show_warnings = true;
        };
        hover = {
          enable = true;
          show_account_balance = true;
        };
      };
    };
  });
  
  # File type associations
  fileTypes = {
    "Dockerfile" = ["Dockerfile" "Dockerfile.*"];
    "JSON" = ["json" "jsonc" "*.code-snippets"];
    "YAML" = ["docker-compose.yaml" "docker-compose*.yaml" "*.yml" "*.yaml"];
    "Nix" = ["nix"];
    "Rust" = ["rs"];
    "TOML" = ["Cargo.toml" "Cargo.lock" "*.toml"];
    "Python" = ["py" "pyw" "pyi"];
    "Requirements" = ["requirements.txt" "requirements-*.txt"];
    "Poetry" = ["pyproject.toml"];
    "Java" = ["java" "jav"];
    "Gradle" = ["gradle" "gradle.kts"];
    "C++" = ["cpp" "cc" "cxx" "c++" "hpp" "hh" "hxx" "h++"];
    "C" = ["c" "h"];
    "CMake" = ["CMakeLists.txt" "*.cmake"];
    "Beancount" = ["beancount" "bean"];
    "JavaScript" = ["js" "jsx" "mjs"];
    "TypeScript" = ["ts" "tsx"];
  };
  
  # Default task configurations
  defaultTasks = {
    # Rust tasks
    "rust-check" = {
      command = "cargo";
      args = ["check"];
      working_directory = "./";
      hide = false;
    };
    
    "rust-build" = {
      command = "cargo";
      args = ["build"];
      working_directory = "./";
      hide = false;
    };
    
    "rust-test" = {
      command = "cargo";
      args = ["test"];
      working_directory = "./";
      hide = false;
    };
    
    "rust-clippy" = {
      command = "cargo";
      args = ["clippy" "--" "-D" "warnings"];
      working_directory = "./";
      hide = false;
    };
    
    # Python tasks
    "python-format" = {
      command = "ruff";
      args = ["format" "."];
      working_directory = "./";
      hide = false;
    };
    
    "python-lint" = {
      command = "ruff";
      args = ["check" "."];
      working_directory = "./";
      hide = false;
    };
    
    "python-test" = {
      command = "python";
      args = ["-m" "pytest"];
      working_directory = "./";
      hide = false;
    };
    
    # Java tasks
    "java-build" = {
      command = "mvn";
      args = ["compile"];
      working_directory = "./";
      hide = false;
    };
    
    "java-test" = {
      command = "mvn";
      args = ["test"];
      working_directory = "./";
      hide = false;
    };
    
    # C++ tasks
    "cpp-build" = {
      command = "make";
      args = [];
      working_directory = "./";
      hide = false;
    };
    
    "cpp-clean" = {
      command = "make";
      args = ["clean"];
      working_directory = "./";
      hide = false;
    };
    
    # Nix tasks
    "nix-build" = {
      command = "nix";
      args = ["build"];
      working_directory = "./";
      hide = false;
    };
    
    "nix-fmt" = {
      command = "nixpkgs-fmt";
      args = ["."];
      working_directory = "./";
      hide = false;
    };
    
    # Docker tasks
    "docker-build" = {
      command = "docker";
      args = ["build" "-t" "\${ZED_FILENAME}" "."];
      working_directory = "./";
      hide = false;
    };
    
    "docker-compose-up" = {
      command = "docker-compose";
      args = ["up" "-d"];
      working_directory = "./";
      hide = false;
    };
    
    # Git tasks
    "git-status" = {
      command = "git";
      args = ["status" "--porcelain" "-b"];
      working_directory = "./";
      hide = false;
    };
    
    "git-diff" = {
      command = "git";
      args = ["diff"];
      working_directory = "./";
      hide = false;
    };
    
    # Project info task
    "project-info" = {
      command = "sh";
      args = ["-c" "echo \"📁 $(basename $PWD) | 🌿 $(git branch --show-current 2>/dev/null || echo 'no-git') | 📊 $(find . -name '*.rs' -o -name '*.py' -o -name '*.java' -o -name '*.cpp' | wc -l) files\""];
      working_directory = "./";
      hide = false;
    };
  };
}