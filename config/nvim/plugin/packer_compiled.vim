" Automatically generated packer.nvim plugin loader code

if !has('nvim-0.5')
  echohl WarningMsg
  echom "Invalid Neovim version for packer.nvim!"
  echohl None
  finish
endif

packadd packer.nvim

try

lua << END
  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time("Luarocks path setup", true)
local package_path_str = "/home/blueguardian/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/blueguardian/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/blueguardian/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/blueguardian/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/blueguardian/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time("Luarocks path setup", false)
time("try_loadstring definition", true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    print('Error running ' .. component .. ' for ' .. name)
    error(result)
  end
  return result
end

time("try_loadstring definition", false)
time("Defining packer_plugins", true)
_G.packer_plugins = {
  ["beancount.nvim"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/beancount.nvim"
  },
  ["contextprint.nvim"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/contextprint.nvim"
  },
  ["dial.nvim"] = {
    config = { "\27LJ\2\n7\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\28polarmutex.plugins.dial\frequire\0" },
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/dial.nvim"
  },
  firenvim = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/firenvim"
  },
  ["git-worktree.nvim"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/git-worktree.nvim"
  },
  ["gitlinker.nvim"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/gitlinker.nvim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n;\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0 polarmutex.plugins.gitsigns\frequire\0" },
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/gitsigns.nvim"
  },
  harpoon = {
    config = { "\27LJ\2\n:\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\31polarmutex.plugins.harpoon\frequire\0" },
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/harpoon"
  },
  ["hop.nvim"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/hop.nvim"
  },
  ["lsp-status.nvim"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/lsp-status.nvim"
  },
  ["lspcontainers.nvim"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/lspcontainers.nvim"
  },
  ["lspkind-nvim"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/lspkind-nvim"
  },
  ["lspsaga.nvim"] = {
    config = { "\27LJ\2\n:\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\31polarmutex.plugins.lspsaga\frequire\0" },
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/lspsaga.nvim"
  },
  neogit = {
    config = { "\27LJ\2\n9\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\30polarmutex.plugins.neogit\frequire\0" },
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/neogit"
  },
  ["nlua.nvim"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/nlua.nvim"
  },
  ["nvim-colorizer.lua"] = {
    config = { "\27LJ\2\n<\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0!polarmutex.plugins.colorizer\frequire\0" },
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua"
  },
  ["nvim-compe"] = {
    config = { "\27LJ\2\n=\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\"polarmutex.plugins.completion\frequire\0" },
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/nvim-compe"
  },
  ["nvim-dap"] = {
    config = { "\27LJ\2\n6\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\27polarmutex.plugins.dap\frequire\0" },
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/nvim-dap"
  },
  ["nvim-dap-python"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/nvim-dap-python"
  },
  ["nvim-dap-virtual-text"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/nvim-dap-virtual-text"
  },
  ["nvim-lightbulb"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/nvim-lightbulb"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-lua-debugger"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/nvim-lua-debugger"
  },
  ["nvim-terminal.lua"] = {
    config = { "\27LJ\2\n@\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0%polarmutex.plugins.nvim-terminal\frequire\0" },
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/nvim-terminal.lua"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\n=\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\"polarmutex.plugins.treesitter\frequire\0" },
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["octo.nvim"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/octo.nvim"
  },
  ["packer.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/opt/packer.nvim"
  },
  playground = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["startuptime.vim"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/startuptime.vim"
  },
  ["tasks.nvim"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/tasks.nvim"
  },
  ["telescope-dap.nvim"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/telescope-dap.nvim"
  },
  ["telescope-fzf-writer.nvim"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/telescope-fzf-writer.nvim"
  },
  ["telescope-fzy-native.nvim"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/telescope-fzy-native.nvim"
  },
  ["telescope-github.nvim"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/telescope-github.nvim"
  },
  ["telescope-packer.nvim"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/telescope-packer.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\nC\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0(polarmutex.plugins.telescope.config\frequire\0" },
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  undotree = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/undotree"
  },
  ["vim-abolish"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/vim-abolish"
  },
  ["vim-be-good"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/vim-be-good"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/vim-commentary"
  },
  ["vim-hardtime"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/vim-hardtime"
  },
  ["vim-illuminate"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/vim-illuminate"
  },
  ["vim-radical"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/vim-radical"
  },
  ["vim-scriptease"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/vim-scriptease"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/vim-surround"
  },
  ["vim-test"] = {
    loaded = true,
    path = "/home/blueguardian/.local/share/nvim/site/pack/packer/start/vim-test"
  }
}

time("Defining packer_plugins", false)
-- Config for: gitsigns.nvim
time("Config for gitsigns.nvim", true)
try_loadstring("\27LJ\2\n;\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0 polarmutex.plugins.gitsigns\frequire\0", "config", "gitsigns.nvim")
time("Config for gitsigns.nvim", false)
-- Config for: nvim-compe
time("Config for nvim-compe", true)
try_loadstring("\27LJ\2\n=\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\"polarmutex.plugins.completion\frequire\0", "config", "nvim-compe")
time("Config for nvim-compe", false)
-- Config for: harpoon
time("Config for harpoon", true)
try_loadstring("\27LJ\2\n:\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\31polarmutex.plugins.harpoon\frequire\0", "config", "harpoon")
time("Config for harpoon", false)
-- Config for: telescope.nvim
time("Config for telescope.nvim", true)
try_loadstring("\27LJ\2\nC\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0(polarmutex.plugins.telescope.config\frequire\0", "config", "telescope.nvim")
time("Config for telescope.nvim", false)
-- Config for: dial.nvim
time("Config for dial.nvim", true)
try_loadstring("\27LJ\2\n7\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\28polarmutex.plugins.dial\frequire\0", "config", "dial.nvim")
time("Config for dial.nvim", false)
-- Config for: nvim-dap
time("Config for nvim-dap", true)
try_loadstring("\27LJ\2\n6\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\27polarmutex.plugins.dap\frequire\0", "config", "nvim-dap")
time("Config for nvim-dap", false)
-- Config for: nvim-colorizer.lua
time("Config for nvim-colorizer.lua", true)
try_loadstring("\27LJ\2\n<\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0!polarmutex.plugins.colorizer\frequire\0", "config", "nvim-colorizer.lua")
time("Config for nvim-colorizer.lua", false)
-- Config for: neogit
time("Config for neogit", true)
try_loadstring("\27LJ\2\n9\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\30polarmutex.plugins.neogit\frequire\0", "config", "neogit")
time("Config for neogit", false)
-- Config for: lspsaga.nvim
time("Config for lspsaga.nvim", true)
try_loadstring("\27LJ\2\n:\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\31polarmutex.plugins.lspsaga\frequire\0", "config", "lspsaga.nvim")
time("Config for lspsaga.nvim", false)
-- Config for: nvim-terminal.lua
time("Config for nvim-terminal.lua", true)
try_loadstring("\27LJ\2\n@\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0%polarmutex.plugins.nvim-terminal\frequire\0", "config", "nvim-terminal.lua")
time("Config for nvim-terminal.lua", false)
-- Config for: nvim-treesitter
time("Config for nvim-treesitter", true)
try_loadstring("\27LJ\2\n=\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\"polarmutex.plugins.treesitter\frequire\0", "config", "nvim-treesitter")
time("Config for nvim-treesitter", false)
if should_profile then save_profiles() end

END

catch
  echohl ErrorMsg
  echom "Error in packer_compiled: " .. v:exception
  echom "Please check your config for correctness"
  echohl None
endtry
