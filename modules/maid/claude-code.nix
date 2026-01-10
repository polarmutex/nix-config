{
  pkgs,
  config,
  lib,
  ...
}:
{

  # ============================================================================
  # FILE MANAGEMENT - Configuration Files
  # ============================================================================
  file = {
    # Global Claude Code configuration with MCP servers
    home.".claude.json" = {
      text = builtins.toJSON {
        # Foundation Layer MCP Servers
        mcpServers = {
          # GitHub MCP - Version control and repo management
          github = {
            command = "github-mcp-server";
            args = ["stdio"];
            env = {
              GITHUB_TOKEN = "$(cat /run/secrets/gh-mcp)";
            };
          };

          # Filesystem MCP - Safe file access with path restrictions
          # filesystem = {
          #   command = "uvx";
          #   args = [ "mcp-filesystem" "/home/{{user}}/projects" "/home/{{user}}/src" ];
          # };

          # Sequential Thinking MCP - Breaking down complex problems
          # sequential-thinking = {
          #   command = "uvx";
          #   args = [ "sequential-thinking-mcp" ];
          # };

          # Core Development Layer MCP Servers

          # Git MCP - Lower-level git operations
          # git = {
          #   command = "uvx";
          #   args = [ "git-mcp" ];
          # };

          # Context7 MCP - Live documentation and code examples
          # This is critical: prevents hallucinations with current API docs
          context7 = {
            command = "context7-mcp";
            # args = [  ];
          };

          # LSP MCP - Language Server Protocol integration
          # lsp = {
          #   command = "stdio";
          #   args = [ "${pkgs.rust-analyzer}/bin/rust-analyzer" ];
          # };
        };

        # Global preferences
        settings = {
          theme = "dark";
          editor = "nvim";
          notifications = true;
        };
      };
    };
  };
}
