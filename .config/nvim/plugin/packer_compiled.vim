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
local package_path_str = "/Users/mjw/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/mjw/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/mjw/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/mjw/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/mjw/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    print('Error running ' .. component .. ' for ' .. name)
    error(result)
  end
  return result
end

_G.packer_plugins = {
  ListToggle = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/ListToggle"
  },
  MatchTag = {
    loaded = false,
    needs_bufread = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/opt/MatchTag"
  },
  ["PHP-Indenting-for-VIm"] = {
    config = { "require('config.phpindent')" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/opt/PHP-Indenting-for-VIm"
  },
  ["bullets.vim"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/bullets.vim"
  },
  ["clever-f.vim"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/clever-f.vim"
  },
  ["current-func-info.vim"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/current-func-info.vim"
  },
  falcon = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/falcon"
  },
  ferret = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/ferret"
  },
  fzf = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/fzf"
  },
  ["fzf.vim"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/fzf.vim"
  },
  ["goyo.vim"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/goyo.vim"
  },
  ["lexima.vim"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/lexima.vim"
  },
  loupe = {
    config = { "require('config.loupe')" },
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/loupe"
  },
  nerdtree = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/nerdtree"
  },
  ["nerdtree-git-plugin"] = {
    commands = { "NERDTreeToggle", "NERDTreeFind" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/opt/nerdtree-git-plugin"
  },
  ["neuron.vim"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/neuron.vim"
  },
  ["nvim-colorizer.lua"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua"
  },
  ["nvim-compe"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/nvim-compe"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  ["php.vim"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/php.vim"
  },
  ["phpfolding.vim"] = {
    config = { "require('config.phpfolding')" },
    loaded = false,
    needs_bufread = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/opt/phpfolding.vim"
  },
  ripgrep = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/ripgrep"
  },
  ["splitjoin.vim"] = {
    loaded = false,
    needs_bufread = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/opt/splitjoin.vim"
  },
  ["targets.vim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/opt/targets.vim"
  },
  tcomment_vim = {
    config = { "require('config.comment')" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/opt/tcomment_vim"
  },
  ultisnips = {
    after_files = { "/Users/mjw/.local/share/nvim/site/pack/packer/opt/ultisnips/after/plugin/UltiSnips_after.vim" },
    loaded = false,
    needs_bufread = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/opt/ultisnips"
  },
  ["vim-abolish"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/vim-abolish"
  },
  ["vim-agriculture"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/vim-agriculture"
  },
  ["vim-devicons"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/opt/vim-devicons"
  },
  ["vim-dispatch"] = {
    commands = { "Dispatch", "Make", "Focus", "Start" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/opt/vim-dispatch"
  },
  ["vim-doge"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/vim-doge"
  },
  ["vim-easy-align"] = {
    commands = { "EasyAlign" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/opt/vim-easy-align"
  },
  ["vim-expand-region"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/vim-expand-region"
  },
  ["vim-fugitive"] = {
    commands = { "Gstatus", "Gdiff", "Glog", "Gblame", "Gvdiff", "Gread", "Gmerge" },
    loaded = false,
    needs_bufread = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/opt/vim-fugitive"
  },
  ["vim-gitgutter"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/vim-gitgutter"
  },
  ["vim-highlightedyank"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/vim-highlightedyank"
  },
  ["vim-indent-guides"] = {
    config = { "require('config.indent')" },
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/vim-indent-guides"
  },
  ["vim-localvimrc"] = {
    config = { "require('config.localvimrc')" },
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/vim-localvimrc"
  },
  ["vim-lsp-ultisnips"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/vim-lsp-ultisnips"
  },
  ["vim-markdown"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/vim-markdown"
  },
  ["vim-matchup"] = {
    after_files = { "/Users/mjw/.local/share/nvim/site/pack/packer/opt/vim-matchup/after/plugin/matchit.vim" },
    loaded = false,
    needs_bufread = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/opt/vim-matchup"
  },
  ["vim-mkdir"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/vim-mkdir"
  },
  ["vim-php"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/opt/vim-php"
  },
  ["vim-php-manual"] = {
    loaded = false,
    needs_bufread = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/opt/vim-php-manual"
  },
  ["vim-php-namespace"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/opt/vim-php-namespace"
  },
  ["vim-polyglot"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/vim-polyglot"
  },
  ["vim-projectroot"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/vim-projectroot"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/vim-repeat"
  },
  ["vim-sandwich"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/vim-sandwich"
  },
  ["vim-signature"] = {
    config = { "require('config.signature')" },
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/vim-signature"
  },
  ["vim-slime"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/vim-slime"
  },
  ["vim-startify"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/vim-startify"
  },
  ["vim-swap"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/vim-swap"
  },
  ["vim-test"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/vim-test"
  },
  ["vim-textobj-comment"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/vim-textobj-comment"
  },
  ["vim-textobj-entire"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/vim-textobj-entire"
  },
  ["vim-textobj-function"] = {
    loaded = false,
    needs_bufread = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/opt/vim-textobj-function"
  },
  ["vim-textobj-indent"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/vim-textobj-indent"
  },
  ["vim-textobj-line"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/vim-textobj-line"
  },
  ["vim-textobj-user"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/vim-textobj-user"
  },
  ["vim-tmux-navigator"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/vim-tmux-navigator"
  },
  ["vim-unimpaired"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/opt/vim-unimpaired"
  },
  ["vim-visual-star-search"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/vim-visual-star-search"
  },
  ["vim-wordmotion"] = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/vim-wordmotion"
  },
  vimux = {
    loaded = true,
    path = "/Users/mjw/.local/share/nvim/site/pack/packer/start/vimux"
  }
}

-- Setup for: vim-devicons
require('config.devicons')
vim.cmd [[packadd vim-devicons]]
-- Setup for: vim-matchup
require('config.matchup')
vim.cmd [[packadd vim-matchup]]
-- Config for: loupe
require('config.loupe')
-- Config for: vim-localvimrc
require('config.localvimrc')
-- Config for: vim-signature
require('config.signature')
-- Config for: vim-indent-guides
require('config.indent')

-- Command lazy-loads
vim.cmd [[command! -nargs=* -range -bang -complete=file Gmerge lua require("packer.load")({'vim-fugitive'}, { cmd = "Gmerge", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Start lua require("packer.load")({'vim-dispatch'}, { cmd = "Start", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Focus lua require("packer.load")({'vim-dispatch'}, { cmd = "Focus", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Gstatus lua require("packer.load")({'vim-fugitive'}, { cmd = "Gstatus", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Gdiff lua require("packer.load")({'vim-fugitive'}, { cmd = "Gdiff", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Glog lua require("packer.load")({'vim-fugitive'}, { cmd = "Glog", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Gblame lua require("packer.load")({'vim-fugitive'}, { cmd = "Gblame", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Gvdiff lua require("packer.load")({'vim-fugitive'}, { cmd = "Gvdiff", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Gread lua require("packer.load")({'vim-fugitive'}, { cmd = "Gread", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Dispatch lua require("packer.load")({'vim-dispatch'}, { cmd = "Dispatch", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Make lua require("packer.load")({'vim-dispatch'}, { cmd = "Make", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file NERDTreeToggle lua require("packer.load")({'nerdtree-git-plugin'}, { cmd = "NERDTreeToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file NERDTreeFind lua require("packer.load")({'nerdtree-git-plugin'}, { cmd = "NERDTreeFind", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file EasyAlign lua require("packer.load")({'vim-easy-align'}, { cmd = "EasyAlign", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
vim.cmd [[au FileType html ++once lua require("packer.load")({'MatchTag'}, { ft = "html" }, _G.packer_plugins)]]
vim.cmd [[au FileType php ++once lua require("packer.load")({'vim-php-manual', 'vim-textobj-function', 'PHP-Indenting-for-VIm', 'splitjoin.vim', 'vim-php-namespace', 'vim-php', 'phpfolding.vim'}, { ft = "php" }, _G.packer_plugins)]]
  -- Event lazy-loads
vim.cmd [[au VimEnter * ++once lua require("packer.load")({'tcomment_vim', 'vim-unimpaired', 'targets.vim'}, { event = "VimEnter *" }, _G.packer_plugins)]]
vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'ultisnips'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
vim.cmd("augroup END")
END

catch
  echohl ErrorMsg
  echom "Error in packer_compiled: " .. v:exception
  echom "Please check your config for correctness"
  echohl None
endtry
