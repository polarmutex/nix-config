local utils = require("polar.utils")
return {
  {
    "snacks.nvim",
    event = "DeferredUIEnter",
    before = function()
      LZN.trigger_load("trouble.nvim")
    end,
    keys = {
      {
        "<leader>n",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "Notification History",
      },
      {
        "<leader>un",
        function()
          Snacks.notifier.hide()
        end,
        desc = "Dismiss All Notifications",
      },
    },
    after = function()
      ---@type snacks.Config
      local opts = {
        bigfile = { enabled = true },
        indent = { enabled = true },
        ---@type snacks.picker.Config
        picker = {
          actions = require("trouble.sources.snacks").actions,
          win = {
            input = {
              keys = {
                ["<c-t>"] = {
                  "trouble_open",
                  mode = { "n", "i" },
                },
              },
            },
          },
        },
        notifier = { enabled = true },
        scroll = { enabled = false },
        statuscolumn = { enabled = true },
        words = { enabled = true },
      }
      local snacks = require("snacks")
      snacks.setup(opts)

      vim.keymap.set("n", "<leader>,", function()
        snacks.picker.buffers()
      end, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>/", function()
        snacks.picker.grep()
      end, { desc = "Grep" })
      vim.keymap.set("n", "<leader>:", function()
        snacks.picker.command_history()
      end, { desc = "Command History" })
      vim.keymap.set("n", "<leader><space>", function()
        snacks.picker.files()
      end, { desc = "Find Files" })
      -- find
      vim.keymap.set("n", "<leader>fb", function()
        snacks.picker.buffers()
      end, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>fc", function()
        snacks.picker.files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "Find Config File" })
      vim.keymap.set("n", "<leader>ff", function()
        snacks.picker.files()
      end, { desc = "Find Files" })
      vim.keymap.set("n", "<leader>fg", function()
        snacks.picker.git_files()
      end, { desc = "Find Git Files" })
      vim.keymap.set("n", "<leader>fr", function()
        snacks.picker.recent()
      end, { desc = "Recent" })
      -- git
      vim.keymap.set("n", "<leader>gc", function()
        snacks.picker.git_log()
      end, { desc = "Git Log" })
      vim.keymap.set("n", "<leader>gs", function()
        snacks.picker.git_status()
      end, { desc = "Git Status" })
      -- Grep
      vim.keymap.set("n", "<leader>sb", function()
        snacks.picker.lines()
      end, { desc = "Buffer Lines" })
      vim.keymap.set("n", "<leader>sB", function()
        snacks.picker.grep_buffers()
      end, { desc = "Grep Open Buffers" })
      vim.keymap.set("n", "<leader>sg", function()
        snacks.picker.grep()
      end, { desc = "Grep" })
      -- vim.keymap.set("n", "<leader>sw", function()
      --     snacks.picker.grep_word()
      -- end, { desc = "Visual selection or word", mode = { "n", "x" } })
      -- search
      vim.keymap.set("n", '<leader>s"', function()
        snacks.picker.registers()
      end, { desc = "Registers" })
      vim.keymap.set("n", "<leader>sa", function()
        snacks.picker.autocmds()
      end, { desc = "Autocmds" })
      vim.keymap.set("n", "<leader>sc", function()
        snacks.picker.command_history()
      end, { desc = "Command History" })
      vim.keymap.set("n", "<leader>sC", function()
        snacks.picker.commands()
      end, { desc = "Commands" })
      vim.keymap.set("n", "<leader>sd", function()
        snacks.picker.diagnostics()
      end, { desc = "Diagnostics" })
      vim.keymap.set("n", "<leader>sh", function()
        snacks.picker.help()
      end, { desc = "Help Pages" })
      vim.keymap.set("n", "<leader>sH", function()
        snacks.picker.highlights()
      end, { desc = "Highlights" })
      vim.keymap.set("n", "<leader>sj", function()
        snacks.picker.jumps()
      end, { desc = "Jumps" })
      vim.keymap.set("n", "<leader>sk", function()
        snacks.picker.keymaps()
      end, { desc = "Keymaps" })
      vim.keymap.set("n", "<leader>sl", function()
        snacks.picker.loclist()
      end, { desc = "Location List" })
      vim.keymap.set("n", "<leader>sM", function()
        snacks.picker.man()
      end, { desc = "Man Pages" })
      vim.keymap.set("n", "<leader>sm", function()
        snacks.picker.marks()
      end, { desc = "Marks" })
      vim.keymap.set("n", "<leader>sR", function()
        snacks.picker.resume()
      end, { desc = "Resume" })
      vim.keymap.set("n", "<leader>sq", function()
        snacks.picker.qflist()
      end, { desc = "Quickfix List" })
      vim.keymap.set("n", "<leader>uC", function()
        snacks.picker.colorschemes()
      end, { desc = "Colorschemes" })
      vim.keymap.set("n", "<leader>qp", function()
        snacks.picker.projects()
      end, { desc = "Projects" })
      -- LSP
      vim.keymap.set("n", "gd", function()
        snacks.picker.lsp_definitions()
      end, { desc = "Goto Definition" })
      vim.keymap.set("n", "gr", function()
        snacks.picker.lsp_references()
      end, { nowait = true, desc = "References" })
      vim.keymap.set("n", "gI", function()
        snacks.picker.lsp_implementations()
      end, { desc = "Goto Implementation" })
      vim.keymap.set("n", "gy", function()
        snacks.picker.lsp_type_definitions()
      end, { desc = "Goto T[y]pe Definition" })
      vim.keymap.set("n", "<leader>ss", function()
        snacks.picker.lsp_symbols()
      end, { desc = "LSP Symbols" })
      vim.keymap.set("n", "<leader>bd", function()
        snacks.bufdelete()
      end, { desc = "Delete Buffer" })
      vim.keymap.set("n", "<leader>bo", function()
        snacks.bufdelete.other()
      end, { desc = "Delete Other Buffers" })

      -- toggle options
      -- LazyVim.format.snacks_toggle():map("<leader>uf")
      -- LazyVim.format.snacks_toggle(true):map("<leader>uF")
      snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
      snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
      snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
      snacks.toggle.diagnostics():map("<leader>ud")
      snacks.toggle.line_number():map("<leader>ul")
      snacks.toggle
        .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" })
        :map("<leader>uc")
      snacks.toggle
        .option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" })
        :map("<leader>uA")
      snacks.toggle.treesitter():map("<leader>uT")
      snacks.toggle.dim():map("<leader>uD")
      snacks.toggle.animate():map("<leader>ua")
      snacks.toggle.indent():map("<leader>ug")
      snacks.toggle.scroll():map("<leader>uS")
      snacks.toggle.profiler():map("<leader>dpp")
      snacks.toggle.profiler_highlights():map("<leader>dph")

      if vim.lsp.inlay_hint then
        snacks.toggle.inlay_hints():map("<leader>uh")
      end

      -- lazygit
      if vim.fn.executable("lazygit") == 1 then
        vim.keymap.set("n", "<leader>gg", function()
          snacks.lazygit()
        end, { desc = "Lazygit (Root Dir)" })
        vim.keymap.set("n", "<leader>gG", function()
          snacks.lazygit()
        end, { desc = "Lazygit (cwd)" })
        vim.keymap.set("n", "<leader>gf", function()
          snacks.picker.git_log_file()
        end, { desc = "Git Current File History" })
        vim.keymap.set("n", "<leader>gl", function()
          snacks.picker.git_log({ cwd = utils.git_root() })
        end, { desc = "Git Log" })
        vim.keymap.set("n", "<leader>gL", function()
          snacks.picker.git_log()
        end, { desc = "Git Log (cwd)" })
      end

      vim.keymap.set("n", "<leader>gb", function()
        snacks.picker.git_log_line()
      end, { desc = "Git Blame Line" })
      vim.keymap.set({ "n", "x" }, "<leader>gB", function()
        snacks.gitbrowse()
      end, { desc = "Git Browse (open)" })
      vim.keymap.set({ "n", "x" }, "<leader>gY", function()
        snacks.gitbrowse({
          open = function(url)
            vim.fn.setreg("+", url)
          end,
          notify = false,
        })
      end, { desc = "Git Browse (copy)" })

      -- floating terminal
      vim.keymap.set("n", "<leader>fT", function()
        snacks.terminal()
      end, { desc = "Terminal (cwd)" })
      -- vim.keymap.set("n", "<leader>ft", function()
      --     snacks.terminal(nil, { cwd = LazyVim.root() })
      -- end, { desc = "Terminal (Root Dir)" })
      -- vim.keymap.set("n", "<c-/>", function()
      --     snacks.terminal(nil, { cwd = LazyVim.root() })
      -- end, { desc = "Terminal (Root Dir)" })
      -- vim.keymap.set("n", "<c-_>", function()
      --     snacks.terminal(nil, { cwd = LazyVim.root() })
      -- end, { desc = "which_key_ignore" })

      -- window
      snacks.toggle.zoom():map("<leader>wm"):map("<leader>uZ")
      snacks.toggle.zen():map("<leader>uz")
    end,
  },
}
