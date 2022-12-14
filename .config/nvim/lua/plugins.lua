vim.cmd [[packadd packer.nvim]]
return require('packer').startup(function()
  -- Packer can manage itself as an optional plugin
  use 'wbthomason/packer.nvim'

  -- Colors
  -- use '~/Documents/Work/internal/vim/colors/falcon'
  -- use 'fenetikm/falcon'
  -- use {"adisen99/apprentice.nvim", requires = {"rktjmp/lush.nvim"}}
  use "rktjmp/shipwright.nvim"
  use {'~/Documents/Work/internal/vim/colors/falcon', requires = {"rktjmp/lush.nvim"}}

  -- Running
  use {'tpope/vim-dispatch', opt = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}}

  -- Project management
  use {'embear/vim-localvimrc', config = [[require('plugins.localvimrc')]]} -- local vimrc
  use 'dbakker/vim-projectroot' -- find the project root

  -- Matching
  use 'cohama/lexima.vim' -- auto closing pairs
  use 'machakann/vim-sandwich'
  use {'gregsexton/MatchTag', ft = {'html'}} --html tag matching
  -- TODO fix this, makes vim files slow to switch between buffers, probably needs better config
  --use {'andymass/vim-matchup', setup = [[require('plugins.matchup')]]}

  -- Text manipulation
  use {'AndrewRadev/splitjoin.vim', ft = {'php'}} -- convert single/multi line code expressions

  -- Git
  use {'tpope/vim-fugitive', cmd = {'Git', 'G', 'Gstatus', 'Gdiff', 'Glog', 'Gblame', 'Gvdiff', 'Gread', 'Gmerge'}}

  -- Testing
  use {'janko-m/vim-test', config = [[require('plugins.testing')]]} --Test runner

  -- Commenting
  --use {'tomtom/tcomment_vim', event = {'VimEnter'}, config = [[require('plugins.comment')]]}
  use {'tomtom/tcomment_vim', config = [[require('plugins.comment')]]}

  -- Selection
  use {'terryma/vim-expand-region', config = [[require('plugins.expand')]]} --expand region useful for selection

  -- Spelling, thesaurus etc.
  use 'tpope/vim-abolish'

  -- Integration with other tools
  use 'benmills/vimux' -- Interact with tmux from vim

  -- Writing and focus
  use 'junegunn/goyo.vim' --distraction free writing
  -- TODO think this is in neovim? e.g. https://oroques.dev/notes/neovim-init/
  use {'machakann/vim-highlightedyank', config = [[require('plugins.Highlightedyank')]]} --highlight the last yanked item

  -- Motion
  use {'rhysd/clever-f.vim', config = [[require('plugins.clever-f')]]} --clever fFtT 
  use 'chaoren/vim-wordmotion' --Expand the definition of what a word is
  use 'christoomey/vim-tmux-navigator' --navigate betwenn tmux splits and vim together
  use {'wellle/targets.vim', event = {'VimEnter'}} --Additional target text objects
  use {'justinmk/vim-sneak', config = [[require('plugins.sneak')]]}

  -- Files
  use 'pbrisbin/vim-mkdir' --save file in directory, don't fail
  use {'kyazdani42/nvim-tree.lua', config = [[require('plugins.tree')]],
      requires = {'kyazdani42/nvim-web-devicons'}}

  -- use {'scrooloose/nerdtree', event = {'VimEnter'}, cmd = {'NERDTreeToggle', 'NERDTreeFind'}} --file tree explorer
  use {'Xuyuanp/nerdtree-git-plugin', cmd = {'NERDTreeToggle', 'NERDTreeFind'}} --nerdtree git plugin
  use {'ryanoasis/vim-devicons', setup = [[require('plugins.devicons')]]} --icons

  -- Search
  use 'BurntSushi/ripgrep' --ripgrep support, neuron and telescope want it
  use {'wincent/loupe', config = [[require('plugins.loupe')]]} --nicer search highlighting
  use 'wincent/ferret' --multi file search
  use '/usr/local/opt/fzf' --fzf
  use 'junegunn/fzf.vim' --fuzzy finder stuff
  use 'nelstrom/vim-visual-star-search' --use * in visual mode to search
  use 'jesseleite/vim-agriculture' --pass things through to rg

  use {
    'yamatsum/nvim-nonicons',
    requires = {'kyazdani42/nvim-web-devicons'}
  }

  use {
    'NTBBloodbath/galaxyline.nvim',
    branch = 'main',
      config = [[require('plugins.galaxyline')]],
      requires = {'kyazdani42/nvim-web-devicons', opt = true}
  }
  -- use 'itchyny/lightline.vim' --statusline handling

  -- Columns
  use {'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' }, config = [[require('plugins.gitsigns')]]}
  use {'kshenoy/vim-signature', config = [[require('plugins.signature')]]} --marks handling

  -- Guides
  -- use {'nathanaelkane/vim-indent-guides', cmd = {'IndentGuidesToggle'}, config = [[require('plugins.indent')]]}
  use {"lukas-reineke/indent-blankline.nvim", config = [[require('plugins.indent_blankline')]]}

  -- Formatting
  use {'junegunn/vim-easy-align', cmd = {'EasyAlign'}, config = [[require('plugins.easyalign')]]}

  -- Documentation
  use {'kkoomen/vim-doge', config = [[require('plugins.doge')]]}

  -- Repl
  use {'jpalardy/vim-slime', config = [[require('plugins.slime')]]} --send output from buffer to tmux / repl

  -- Snippets
  use {'Sirver/ultisnips', config = [[require('plugins.ultisnips')]]} -- Snippets

  -- LSP
  use 'onsails/lspkind-nvim'
  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/lsp-status.nvim'
  use {'nvim-treesitter/nvim-treesitter', config = [[require('plugins.treesitter')]]}
  use {'nvim-treesitter/playground', config = [[require('plugins.playground')]]}
  -- use {
  --     'nvim-treesitter/nvim-treesitter',
  --     requires = {
  --       'nvim-treesitter/nvim-treesitter-refactor', 'nvim-treesitter/nvim-treesitter-textobjects'
  --     },
  --     config = [[require('plugins.treesitter')]]}
  -- use 'thomasfaingnaert/vim-lsp-ultisnips' --ultisnips in LSP
  use {'ray-x/lsp_signature.nvim'}

  -- Completion
  -- use {'hrsh7th/nvim-compe', config = [[require('plugins.compe')]]}
  use {'hrsh7th/nvim-cmp', config = [[require('plugins.cmp')]]}
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-nvim-lua'
  use {'quangnguyen30192/cmp-nvim-ultisnips'}
  -- other source:
  -- hrsh7th/cmp-emoji
  -- hrsh7th/cmp-cmdline
  -- uga-rosa/cmp-dictionary

  -- Syntax
  vim.g.polyglot_disabled = {'yaml', 'markdown', 'php'}
  use 'sheerun/vim-polyglot' --syntax for a lot of types
  use 'plasticboy/vim-markdown' --markdown syntax
  use 'StanAngeloff/php.vim' --php syntax
  use {'norcalli/nvim-colorizer.lua', config = [[require('plugins.colorizer')]]}

  -- Text objects
  use 'kana/vim-textobj-user'
  use 'kana/vim-textobj-line'
  use 'kana/vim-textobj-indent'
  use 'glts/vim-textobj-comment'
  use 'kana/vim-textobj-entire'

  -- PHP stuff
  use {'2072/PHP-Indenting-for-VIm', ft = {'php'}, config = [[require('plugins.phpindent')]]} --updated indenting
  use {'arnaud-lb/vim-php-namespace', ft = {'php'}} --insert use statements automatically
  use {'sahibalejandro/vim-php', ft = {'php'}} --insert absolute FQCN
  use {'fenetikm/phpfolding.vim', ft = {'php'}, config = [[require('plugins.phpfolding')]]} --php folding
  use {'alvan/vim-php-manual', ft = {'php'}} --php manual
  use {'fenetikm/vim-textobj-function', ft = {'php'}} --function textobj with php

  -- Debugging
  use {'mfussenegger/nvim-dap', config = [[require('plugins.dap')]]} --debug adaptor protocol
  use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
  use {'theHamsta/nvim-dap-virtual-text', requires = {"mfussenegger/nvim-dap"} }

  -- Uncategorised
  -- use {'nathom/filetype.nvim', config = [[require('plugins.filetype')]]} --replace default filetype with a faster version
  use {'dkarter/bullets.vim', config = [[require('plugins.bullets')]]} --smart bullet support
  use {'tpope/vim-unimpaired', event = {'VimEnter'}} --Various dual pair commands
  use 'tpope/vim-repeat' --Repeat plugin commands
  use 'Valloric/ListToggle' --Toggle quickfix and location lists
  -- use 'mhinz/vim-startify' -- Start up screen
  use 'tyru/current-func-info.vim' --get the current function info
  use 'machakann/vim-swap' --swap params around
  use 'rcarriga/nvim-notify'

  -- TODO replace with nvim version
  -- use 'fiatjaf/neuron.vim' --zettel management
  -- use {'oberblastmeister/neuron.nvim', config = [[require('plugins.neuron')]], branch = 'unstable'}
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} },
    config = [[require('plugins.telescope')]]
  }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  use {'glepnir/dashboard-nvim', config = [[require('plugins.dash')]]}

  -- Not enabled for now, see if we miss it in a month's time
  --use 'majutsushi/tagbar'
  --use 'skywind3000/vim-preview' --preview window commands
  --use 'Shougo/echodoc.vim' --show completion signatures
  --use 'tpope/vim-projectionist' --navigation and alternates
  --use 'mattn/emmet-vim' --expansion of html/css to full tags
  --use {'adoy/vim-php-refactoring-toolbox', ft = {'php'} } "php refactoring

  -- Others TODO
  -- peekaboo
  -- fzf-lsp
  -- telescope
  -- dial: https://github.com/monaqa/dial.nvim, https://github.com/yutkat/dotfiles/blob/master/.config/nvim/lua/rc/pluginconfig/dial.lua
  -- lspsaga
  -- nvim-autopairs: https://github.com/windwp/nvim-autopairs
  -- https://github.com/rhysd/vim-lsp-ale to get lsp and ale going
  -- which key nvim: https://github.com/folke/which-key.nvim
  -- https://github.com/ray-x/lsp_signature.nvim
  -- https://github.com/lukas-reineke/indent-blankline.nvim
  -- https://github.com/gelguy/wilder.nvim better wild menu, neovim
  -- https://github.com/vhyrro/neorg
  -- https://github.com/rcarriga/nvim-dap-ui
  -- https://github.com/rcarriga/vim-ultest
  -- https://github.com/puremourning/vimspector
  -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
  -- some from https://neovimcraft.com/
  -- https://github.com/phaazon/hop.nvim
  -- stuff from https://github.com/CosmicNvim/CosmicNvim
  -- https://github.com/goolord/alpha-nvim to replace dashboard
  -- https://github.com/jose-elias-alvarez/null-ls.nvim
  -- https://github.com/folke/trouble.nvim
  -- https://www.lunarvim.org/plugins/02-default-plugins.html and maybe some from extra
  -- https://github.com/Pocco81/TrueZen.nvim
  --
  -- plugin lists to look through:
  -- - https://github.com/yutkat/dotfiles/blob/master/.config/nvim/lua/rc/pluginlist.lua
  --
  -- dotfiles:
  -- - https://github.com/bluz71/dotfiles/blob/master/vim/lua/lsp-config.lua

end)
