return {
  {
    "nvim-lint",
    event = "DeferredUIEnter",
    after = function()
      local opts = {
        -- Event to trigger linters
        events = { "BufWritePost", "BufReadPost", "InsertLeave" },
        linters_by_ft = {
          -- Use the "*" filetype to run linters on all filetypes.
          -- ['*'] = { 'global linter' },
          -- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
          -- ['_'] = { 'fallback linter' },
          -- ["*"] = { "typos" },
          cmake = { "cmakelint" },
          cpp = { "clangtidy", "cppcheck", "cpplint" },
          dockerfile = { "hadolint" },
          lua = { "luacheck" },
          markdown = { "markdownlint" },
          nix = { "deadnix", "statix" },
          python = { "ruff" },
        },
        -- LazyVim extension to easily override linter options
        -- or add custom linters.
        ---@type table<string, table>
        linters = {},
      }

      local M = {}

      local lint = require("lint")

      lint.linters.deadnix = {
        cmd = "deadnix",
        name = "deadnix",
        stdin = false, -- or false if it doesn't support content input via stdin. In that case the filename is automatically added to the arguments.
        append_fname = true, -- Automatically append the file name to `args` if `stdin = false` (default: true)
        args = { "--output-format=json" }, -- list of arguments. Can contain functions with zero arguments that will be evaluated once the linter is used.
        stream = nil, -- ('stdout' | 'stderr' | 'both') configure the stream to which the linter outputs the linting result.
        ignore_exitcode = false, -- set this to true if the linter exits with a code != 0 and that's considered normal.
        env = nil, -- custom environment table to use with the external process. Note that this replaces the *entire* environment, it is not additive.
        parser = function(output, _)
          local items = {}

          if output == "" then
            return items
          end

          local decoded = vim.json.decode(output) or {}

          for _, diag in ipairs(decoded.results) do
            table.insert(items, {
              source = "deadnix",
              lnum = diag.line - 1,
              col = diag.column - 1,
              end_lnum = diag.line - 1,
              end_col = diag.endColumn,
              message = diag.message,
              severity = vim.diagnostic.severity.WARN,
            })
          end
          return items
        end,
      }

      lint.linters_by_ft = opts.linters_by_ft

      function M.debounce(ms, fn)
        local timer = vim.uv.new_timer()
        return function(...)
          local argv = { ... }
          timer:start(ms, 0, function()
            timer:stop()
            vim.schedule_wrap(fn)(unpack(argv))
          end)
        end
      end

      function M.lint()
        -- Use nvim-lint's logic first:
        -- * checks if linters exist for the full filetype first
        -- * otherwise will split filetype by "." and add all those linters
        -- * this differs from conform.nvim which only uses the first filetype that has a formatter
        local names = lint._resolve_linter_by_ft(vim.bo.filetype)

        -- Create a copy of the names table to avoid modifying the original.
        names = vim.list_extend({}, names)

        -- Add fallback linters.
        if #names == 0 then
          vim.list_extend(names, lint.linters_by_ft["_"] or {})
        end

        -- Add global linters.
        vim.list_extend(names, lint.linters_by_ft["*"] or {})

        -- Filter out linters that don't exist or don't match the condition.
        local ctx = { filename = vim.api.nvim_buf_get_name(0) }
        ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
        names = vim.tbl_filter(function(name)
          local linter = lint.linters[name]
          -- TODO if not linter then
          --     -- LazyVim.warn("Linter not found: " .. name, { title = "nvim-lint" })
          -- end
          return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
        end, names)

        -- Run linters.
        if #names > 0 then
          lint.try_lint(names)
        end
      end

      vim.api.nvim_create_autocmd(opts.events, {
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = M.debounce(100, M.lint),
      })
    end,
  },
}
