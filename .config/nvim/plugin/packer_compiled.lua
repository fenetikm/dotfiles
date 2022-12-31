-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

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
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/michael/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/michael/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/michael/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/michael/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/michael/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["Comment.nvim"] = {
    config = { "require('plugins.comment')" },
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/Comment.nvim",
    url = "https://github.com/numToStr/Comment.nvim"
  },
  ListToggle = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/ListToggle",
    url = "https://github.com/Valloric/ListToggle"
  },
  MatchTag = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/opt/MatchTag",
    url = "https://github.com/gregsexton/MatchTag"
  },
  ["bullets.vim"] = {
    config = { "require('plugins.bullets')" },
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/bullets.vim",
    url = "https://github.com/dkarter/bullets.vim"
  },
  ["clever-f.vim"] = {
    config = { "require('plugins.clever-f')" },
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/clever-f.vim",
    url = "https://github.com/rhysd/clever-f.vim"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lua"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/cmp-nvim-lua",
    url = "https://github.com/hrsh7th/cmp-nvim-lua"
  },
  ["cmp-nvim-ultisnips"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/cmp-nvim-ultisnips",
    url = "https://github.com/quangnguyen30192/cmp-nvim-ultisnips"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  ["current-func-info.vim"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/current-func-info.vim",
    url = "https://github.com/tyru/current-func-info.vim"
  },
  ["dashboard-nvim"] = {
    config = { "require('plugins.dash')" },
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/dashboard-nvim",
    url = "https://github.com/glepnir/dashboard-nvim"
  },
  falcon = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/falcon",
    url = "/Users/michael/Documents/Work/internal/vim/colors/falcon"
  },
  ferret = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/ferret",
    url = "https://github.com/wincent/ferret"
  },
  fzf = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/fzf",
    url = "/usr/local/opt/fzf"
  },
  ["fzf.vim"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/fzf.vim",
    url = "https://github.com/junegunn/fzf.vim"
  },
  ["galaxyline.nvim"] = {
    config = { "require('plugins.galaxyline')" },
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/galaxyline.nvim",
    url = "https://github.com/NTBBloodbath/galaxyline.nvim"
  },
  ["gitsigns.nvim"] = {
    config = { "require('plugins.gitsigns')" },
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  ["goyo.vim"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/goyo.vim",
    url = "https://github.com/junegunn/goyo.vim"
  },
  ["indent-blankline.nvim"] = {
    config = { "require('plugins.indent_blankline')" },
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim",
    url = "https://github.com/lukas-reineke/indent-blankline.nvim"
  },
  ["lexima.vim"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/lexima.vim",
    url = "https://github.com/cohama/lexima.vim"
  },
  loupe = {
    config = { "require('plugins.loupe')" },
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/loupe",
    url = "https://github.com/wincent/loupe"
  },
  ["lsp-status.nvim"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/lsp-status.nvim",
    url = "https://github.com/nvim-lua/lsp-status.nvim"
  },
  ["lsp_signature.nvim"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/lsp_signature.nvim",
    url = "https://github.com/ray-x/lsp_signature.nvim"
  },
  ["lspkind-nvim"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/lspkind-nvim",
    url = "https://github.com/onsails/lspkind-nvim"
  },
  ["lush.nvim"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/lush.nvim",
    url = "https://github.com/rktjmp/lush.nvim"
  },
  ["nerdtree-git-plugin"] = {
    commands = { "NERDTreeToggle", "NERDTreeFind" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/opt/nerdtree-git-plugin",
    url = "https://github.com/Xuyuanp/nerdtree-git-plugin"
  },
  ["nvim-cmp"] = {
    config = { "require('plugins.cmp')" },
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-colorizer.lua"] = {
    config = { "require('plugins.colorizer')" },
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua",
    url = "https://github.com/norcalli/nvim-colorizer.lua"
  },
  ["nvim-dap"] = {
    config = { "require('plugins.dap')" },
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/nvim-dap",
    url = "https://github.com/mfussenegger/nvim-dap"
  },
  ["nvim-dap-ui"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/nvim-dap-ui",
    url = "https://github.com/rcarriga/nvim-dap-ui"
  },
  ["nvim-dap-virtual-text"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/nvim-dap-virtual-text",
    url = "https://github.com/theHamsta/nvim-dap-virtual-text"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-nonicons"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/nvim-nonicons",
    url = "https://github.com/yamatsum/nvim-nonicons"
  },
  ["nvim-notify"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/nvim-notify",
    url = "https://github.com/rcarriga/nvim-notify"
  },
  ["nvim-tree.lua"] = {
    config = { "require('plugins.tree')" },
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/nvim-tree.lua",
    url = "https://github.com/kyazdani42/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    config = { "require('plugins.treesitter')" },
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-context"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/nvim-treesitter-context",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-context"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["php.vim"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/php.vim",
    url = "https://github.com/StanAngeloff/php.vim"
  },
  ["phpfolding.vim"] = {
    config = { "require('plugins.phpfolding')" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/opt/phpfolding.vim",
    url = "https://github.com/fenetikm/phpfolding.vim"
  },
  playground = {
    config = { "require('plugins.playground')" },
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/playground",
    url = "https://github.com/nvim-treesitter/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/popup.nvim",
    url = "https://github.com/nvim-lua/popup.nvim"
  },
  ripgrep = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/ripgrep",
    url = "https://github.com/BurntSushi/ripgrep"
  },
  ["shipwright.nvim"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/shipwright.nvim",
    url = "https://github.com/rktjmp/shipwright.nvim"
  },
  ["splitjoin.vim"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/opt/splitjoin.vim",
    url = "https://github.com/AndrewRadev/splitjoin.vim"
  },
  ["targets.vim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/opt/targets.vim",
    url = "https://github.com/wellle/targets.vim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope.nvim"] = {
    config = { "require('plugins.telescope')" },
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ultisnips = {
    config = { "require('plugins.ultisnips')" },
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/ultisnips",
    url = "https://github.com/Sirver/ultisnips"
  },
  ["vim-abolish"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/vim-abolish",
    url = "https://github.com/tpope/vim-abolish"
  },
  ["vim-agriculture"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/vim-agriculture",
    url = "https://github.com/jesseleite/vim-agriculture"
  },
  ["vim-devicons"] = {
    loaded = true,
    needs_bufread = false,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/opt/vim-devicons",
    url = "https://github.com/ryanoasis/vim-devicons"
  },
  ["vim-dispatch"] = {
    commands = { "Dispatch", "Make", "Focus", "Start" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/opt/vim-dispatch",
    url = "https://github.com/tpope/vim-dispatch"
  },
  ["vim-doge"] = {
    config = { "require('plugins.doge')" },
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/vim-doge",
    url = "https://github.com/kkoomen/vim-doge"
  },
  ["vim-easy-align"] = {
    commands = { "EasyAlign" },
    config = { "require('plugins.easyalign')" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/opt/vim-easy-align",
    url = "https://github.com/junegunn/vim-easy-align"
  },
  ["vim-expand-region"] = {
    config = { "require('plugins.expand')" },
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/vim-expand-region",
    url = "https://github.com/terryma/vim-expand-region"
  },
  ["vim-fugitive"] = {
    commands = { "Git", "G", "Gstatus", "Gdiff", "Glog", "Gblame", "Gvdiff", "Gread", "Gmerge" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/opt/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-localvimrc"] = {
    config = { "require('plugins.localvimrc')" },
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/vim-localvimrc",
    url = "https://github.com/embear/vim-localvimrc"
  },
  ["vim-markdown"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/vim-markdown",
    url = "https://github.com/plasticboy/vim-markdown"
  },
  ["vim-mkdir"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/vim-mkdir",
    url = "https://github.com/pbrisbin/vim-mkdir"
  },
  ["vim-php-manual"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/opt/vim-php-manual",
    url = "https://github.com/alvan/vim-php-manual"
  },
  ["vim-polyglot"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/vim-polyglot",
    url = "https://github.com/sheerun/vim-polyglot"
  },
  ["vim-projectroot"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/vim-projectroot",
    url = "https://github.com/dbakker/vim-projectroot"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/vim-repeat",
    url = "https://github.com/tpope/vim-repeat"
  },
  ["vim-sandwich"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/vim-sandwich",
    url = "https://github.com/machakann/vim-sandwich"
  },
  ["vim-signature"] = {
    config = { "require('plugins.signature')" },
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/vim-signature",
    url = "https://github.com/kshenoy/vim-signature"
  },
  ["vim-slime"] = {
    config = { "require('plugins.slime')" },
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/vim-slime",
    url = "https://github.com/jpalardy/vim-slime"
  },
  ["vim-sneak"] = {
    config = { "require('plugins.sneak')" },
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/vim-sneak",
    url = "https://github.com/justinmk/vim-sneak"
  },
  ["vim-swap"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/vim-swap",
    url = "https://github.com/machakann/vim-swap"
  },
  ["vim-test"] = {
    config = { "require('plugins.testing')" },
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/vim-test",
    url = "https://github.com/janko-m/vim-test"
  },
  ["vim-textobj-comment"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/vim-textobj-comment",
    url = "https://github.com/glts/vim-textobj-comment"
  },
  ["vim-textobj-entire"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/vim-textobj-entire",
    url = "https://github.com/kana/vim-textobj-entire"
  },
  ["vim-textobj-indent"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/vim-textobj-indent",
    url = "https://github.com/kana/vim-textobj-indent"
  },
  ["vim-textobj-line"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/vim-textobj-line",
    url = "https://github.com/kana/vim-textobj-line"
  },
  ["vim-textobj-user"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/vim-textobj-user",
    url = "https://github.com/kana/vim-textobj-user"
  },
  ["vim-tmux-navigator"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/vim-tmux-navigator",
    url = "https://github.com/christoomey/vim-tmux-navigator"
  },
  ["vim-unimpaired"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/opt/vim-unimpaired",
    url = "https://github.com/tpope/vim-unimpaired"
  },
  ["vim-visual-star-search"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/vim-visual-star-search",
    url = "https://github.com/nelstrom/vim-visual-star-search"
  },
  ["vim-wordmotion"] = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/vim-wordmotion",
    url = "https://github.com/chaoren/vim-wordmotion"
  },
  vimux = {
    loaded = true,
    path = "/Users/michael/.local/share/nvim/site/pack/packer/start/vimux",
    url = "https://github.com/benmills/vimux"
  }
}

time([[Defining packer_plugins]], false)
-- Setup for: vim-devicons
time([[Setup for vim-devicons]], true)
require('plugins.devicons')
time([[Setup for vim-devicons]], false)
time([[packadd for vim-devicons]], true)
vim.cmd [[packadd vim-devicons]]
time([[packadd for vim-devicons]], false)
-- Config for: vim-test
time([[Config for vim-test]], true)
require('plugins.testing')
time([[Config for vim-test]], false)
-- Config for: vim-localvimrc
time([[Config for vim-localvimrc]], true)
require('plugins.localvimrc')
time([[Config for vim-localvimrc]], false)
-- Config for: Comment.nvim
time([[Config for Comment.nvim]], true)
require('plugins.comment')
time([[Config for Comment.nvim]], false)
-- Config for: playground
time([[Config for playground]], true)
require('plugins.playground')
time([[Config for playground]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
require('plugins.cmp')
time([[Config for nvim-cmp]], false)
-- Config for: dashboard-nvim
time([[Config for dashboard-nvim]], true)
require('plugins.dash')
time([[Config for dashboard-nvim]], false)
-- Config for: nvim-colorizer.lua
time([[Config for nvim-colorizer.lua]], true)
require('plugins.colorizer')
time([[Config for nvim-colorizer.lua]], false)
-- Config for: nvim-dap
time([[Config for nvim-dap]], true)
require('plugins.dap')
time([[Config for nvim-dap]], false)
-- Config for: vim-sneak
time([[Config for vim-sneak]], true)
require('plugins.sneak')
time([[Config for vim-sneak]], false)
-- Config for: bullets.vim
time([[Config for bullets.vim]], true)
require('plugins.bullets')
time([[Config for bullets.vim]], false)
-- Config for: galaxyline.nvim
time([[Config for galaxyline.nvim]], true)
require('plugins.galaxyline')
time([[Config for galaxyline.nvim]], false)
-- Config for: clever-f.vim
time([[Config for clever-f.vim]], true)
require('plugins.clever-f')
time([[Config for clever-f.vim]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
require('plugins.gitsigns')
time([[Config for gitsigns.nvim]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
require('plugins.telescope')
time([[Config for telescope.nvim]], false)
-- Config for: vim-slime
time([[Config for vim-slime]], true)
require('plugins.slime')
time([[Config for vim-slime]], false)
-- Config for: ultisnips
time([[Config for ultisnips]], true)
require('plugins.ultisnips')
time([[Config for ultisnips]], false)
-- Config for: indent-blankline.nvim
time([[Config for indent-blankline.nvim]], true)
require('plugins.indent_blankline')
time([[Config for indent-blankline.nvim]], false)
-- Config for: vim-doge
time([[Config for vim-doge]], true)
require('plugins.doge')
time([[Config for vim-doge]], false)
-- Config for: vim-signature
time([[Config for vim-signature]], true)
require('plugins.signature')
time([[Config for vim-signature]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
require('plugins.treesitter')
time([[Config for nvim-treesitter]], false)
-- Config for: loupe
time([[Config for loupe]], true)
require('plugins.loupe')
time([[Config for loupe]], false)
-- Config for: nvim-tree.lua
time([[Config for nvim-tree.lua]], true)
require('plugins.tree')
time([[Config for nvim-tree.lua]], false)
-- Config for: vim-expand-region
time([[Config for vim-expand-region]], true)
require('plugins.expand')
time([[Config for vim-expand-region]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.api.nvim_create_user_command, 'Gstatus', function(cmdargs)
          require('packer.load')({'vim-fugitive'}, { cmd = 'Gstatus', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'vim-fugitive'}, { cmd = 'Gstatus' }, _G.packer_plugins)
          return vim.fn.getcompletion('Gstatus ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'Gdiff', function(cmdargs)
          require('packer.load')({'vim-fugitive'}, { cmd = 'Gdiff', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'vim-fugitive'}, { cmd = 'Gdiff' }, _G.packer_plugins)
          return vim.fn.getcompletion('Gdiff ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'Glog', function(cmdargs)
          require('packer.load')({'vim-fugitive'}, { cmd = 'Glog', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'vim-fugitive'}, { cmd = 'Glog' }, _G.packer_plugins)
          return vim.fn.getcompletion('Glog ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'Git', function(cmdargs)
          require('packer.load')({'vim-fugitive'}, { cmd = 'Git', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'vim-fugitive'}, { cmd = 'Git' }, _G.packer_plugins)
          return vim.fn.getcompletion('Git ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'G', function(cmdargs)
          require('packer.load')({'vim-fugitive'}, { cmd = 'G', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'vim-fugitive'}, { cmd = 'G' }, _G.packer_plugins)
          return vim.fn.getcompletion('G ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'Make', function(cmdargs)
          require('packer.load')({'vim-dispatch'}, { cmd = 'Make', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'vim-dispatch'}, { cmd = 'Make' }, _G.packer_plugins)
          return vim.fn.getcompletion('Make ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'Focus', function(cmdargs)
          require('packer.load')({'vim-dispatch'}, { cmd = 'Focus', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'vim-dispatch'}, { cmd = 'Focus' }, _G.packer_plugins)
          return vim.fn.getcompletion('Focus ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'Start', function(cmdargs)
          require('packer.load')({'vim-dispatch'}, { cmd = 'Start', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'vim-dispatch'}, { cmd = 'Start' }, _G.packer_plugins)
          return vim.fn.getcompletion('Start ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'Gblame', function(cmdargs)
          require('packer.load')({'vim-fugitive'}, { cmd = 'Gblame', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'vim-fugitive'}, { cmd = 'Gblame' }, _G.packer_plugins)
          return vim.fn.getcompletion('Gblame ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'Gvdiff', function(cmdargs)
          require('packer.load')({'vim-fugitive'}, { cmd = 'Gvdiff', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'vim-fugitive'}, { cmd = 'Gvdiff' }, _G.packer_plugins)
          return vim.fn.getcompletion('Gvdiff ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'Gread', function(cmdargs)
          require('packer.load')({'vim-fugitive'}, { cmd = 'Gread', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'vim-fugitive'}, { cmd = 'Gread' }, _G.packer_plugins)
          return vim.fn.getcompletion('Gread ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'Gmerge', function(cmdargs)
          require('packer.load')({'vim-fugitive'}, { cmd = 'Gmerge', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'vim-fugitive'}, { cmd = 'Gmerge' }, _G.packer_plugins)
          return vim.fn.getcompletion('Gmerge ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'EasyAlign', function(cmdargs)
          require('packer.load')({'vim-easy-align'}, { cmd = 'EasyAlign', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'vim-easy-align'}, { cmd = 'EasyAlign' }, _G.packer_plugins)
          return vim.fn.getcompletion('EasyAlign ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'NERDTreeFind', function(cmdargs)
          require('packer.load')({'nerdtree-git-plugin'}, { cmd = 'NERDTreeFind', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'nerdtree-git-plugin'}, { cmd = 'NERDTreeFind' }, _G.packer_plugins)
          return vim.fn.getcompletion('NERDTreeFind ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'NERDTreeToggle', function(cmdargs)
          require('packer.load')({'nerdtree-git-plugin'}, { cmd = 'NERDTreeToggle', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'nerdtree-git-plugin'}, { cmd = 'NERDTreeToggle' }, _G.packer_plugins)
          return vim.fn.getcompletion('NERDTreeToggle ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'Dispatch', function(cmdargs)
          require('packer.load')({'vim-dispatch'}, { cmd = 'Dispatch', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'vim-dispatch'}, { cmd = 'Dispatch' }, _G.packer_plugins)
          return vim.fn.getcompletion('Dispatch ', 'cmdline')
      end})
time([[Defining lazy-load commands]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType html ++once lua require("packer.load")({'MatchTag'}, { ft = "html" }, _G.packer_plugins)]]
vim.cmd [[au FileType php ++once lua require("packer.load")({'splitjoin.vim', 'phpfolding.vim', 'vim-php-manual'}, { ft = "php" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au VimEnter * ++once lua require("packer.load")({'vim-unimpaired', 'targets.vim'}, { event = "VimEnter *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
