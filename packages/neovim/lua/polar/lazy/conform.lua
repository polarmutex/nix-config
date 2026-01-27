return {
  {
    "conform.nvim",
    event = "BufWritePre",
    after = function()
      ---@type conform.setupOpts
      local opts = {
        notify_on_error = true,

        formatters_by_ft = {
          cpp = { "clang-format" },
          lua = { "stylua" },
          markdown = { "prettierd" },
          nix = { "alejandra" },
          python = { "ruff_format" },
        },

        default_format_opts = {
          -- timeout_ms = 3000,
          -- async = false, -- not recommended to change
          -- quiet = false, -- not recommended to change
          lsp_format = "fallback", -- not recommended to change
        },

        -- The options you set here will be merged with the builtin formatters.
        -- You can also define any custom formatters here.
        ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
        formatters = {
          stylua = {
            prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
          },
        },

        format_on_save = function(bufnr)
          -- Disable with a global or buffer-local variable
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
          return { timeout_ms = 500, lsp_format = "fallback" }
        end,
      }
      require("conform").setup(opts)

      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          -- FormatDisable! will disable formatting just for this buffer
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, {
        desc = "Disable autoformat-on-save",
        bang = true,
      })

      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = "Re-enable autoformat-on-save",
      })

      vim.api.nvim_create_user_command("Fmt", function(args)
        local range = nil

        if args.count ~= -1 then
          local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]

          range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
          }
        end

        require("conform").format({ range = range, async = true })
      end, { range = true })

      -- Fine, I'm not supposed to make custom commands that are lowercase
      -- I'll just abbreviate it. Happy?
      -- Called when auto-format is disabled for a language or folder,
      -- but we want to format it anyways
      vim.cmd.cabbrev("fmt", "Fmt")

      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}
