vim.cmd [[packadd packer.nvim]]
return require('packer').startup(function()
  -- Packer can manage itself as an optional plugin
  use 'wbthomason/packer.nvim'

  -- Colors
  use '~/Documents/Work/internal/vim/colors/falcon'

  -- Running
  use {'tpope/vim-dispatch', opt = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}}

  -- Project management
  use {'embear/vim-localvimrc', config = [[require('config.localvimrc')]]} -- local vimrc
  use 'dbakker/vim-projectroot' -- find the project root

  -- Matching
  use 'cohama/lexima.vim' -- auto closing pairs
  use 'machakann/vim-sandwich'
  use {'gregsexton/MatchTag', ft = {'html'}} --html tag matching
  -- TODO fix this, makes vim files slow to switch between buffers, probably needs better config
  --use {'andymass/vim-matchup', setup = [[require('config.matchup')]]}

  -- Text manipulation
  use {'AndrewRadev/splitjoin.vim', ft = {'php'}} -- convert single/multi line code expressions

  -- Git
  use {'tpope/vim-fugitive', cmd = {'Gstatus', 'Gdiff', 'Glog', 'Gblame', 'Gvdiff', 'Gread', 'Gmerge'}}

  -- Testing
  use {'janko-m/vim-test', cmd = {'TestLast', 'TestFile', 'TestNearest', 'TestSuite'}, config = [[require('config.testing')]]} --Test runner

  -- Commenting
  use {'tomtom/tcomment_vim', event = {'VimEnter'}, config = [[require('config.comment')]]}

  -- Selection
  use {'terryma/vim-expand-region', config = [[require('config.expand')]]} --expand region useful for selection

  -- Spelling, thesaurus etc.
  use 'tpope/vim-abolish'

  -- Integration with other tools
  use 'benmills/vimux' -- Interact with tmux from vim

  -- Writing and focus
  use 'junegunn/goyo.vim' --distraction free writing
  -- TODO think this is in neovim? e.g. https://oroques.dev/notes/neovim-init/
  use {'machakann/vim-highlightedyank', config = [[require('config.Highlightedyank')]]} --highlight the last yanked item

  -- Motion
  use {'rhysd/clever-f.vim', config = [[require('config.clever-f')]]} --clever fFtT 
  use 'chaoren/vim-wordmotion' --Expand the definition of what a word is
  use 'christoomey/vim-tmux-navigator' --navigate betwenn tmux splits and vim together
  use {'wellle/targets.vim', event = {'VimEnter'}} --Additional target text objects

  -- Files
  use 'pbrisbin/vim-mkdir' --save file in directory, don't fail
  -- TODO replace with nvim tree
  use 'scrooloose/nerdtree' --file tree explorer
  use {'Xuyuanp/nerdtree-git-plugin', cmd = {'NERDTreeToggle', 'NERDTreeFind'}} --nerdtree git plugin
  use {'ryanoasis/vim-devicons', setup = [[require('config.devicons')]]} --icons

  -- Search
  use 'BurntSushi/ripgrep' --ripgrep support, neuron wants it
  use {'wincent/loupe', config = [[require('config.loupe')]]} --nicer search highlighting
  use 'wincent/ferret' --multi file search
  use '/usr/local/opt/fzf' --fzf
  use 'junegunn/fzf.vim' --fuzzy finder stuff
  use 'nelstrom/vim-visual-star-search' --use * in visual mode to search
  use 'jesseleite/vim-agriculture' --pass things through to rg

  -- Statusline TODO replace with galaxyline
  use {
    'glepnir/galaxyline.nvim',
    branch = 'main',
      config = [[require('config.galaxyline')]],
      requires = {'kyazdani42/nvim-web-devicons', opt = true}
  }
  -- use 'itchyny/lightline.vim' --statusline handling

  -- Columns
  use {'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' }, config = [[require('config.gitsigns')]]}
  use {'kshenoy/vim-signature', config = [[require('config.signature')]]} --marks handling

  -- Guides
  use {'nathanaelkane/vim-indent-guides', cmd = {'IndentGuidesToggle'}, config = [[require('config.indent')]]}

  -- Formatting
  use {'junegunn/vim-easy-align', cmd = {'EasyAlign'}, config = [[require('config.easyalign')]]}

  -- Documentation
  use {'kkoomen/vim-doge', config = [[require('config.doge')]]}

  -- Repl
  use {'jpalardy/vim-slime', config = [[require('config.slime')]]} --send output from buffer to tmux / repl

  -- Snippets
  use {'Sirver/ultisnips', config = [[require('config.ultisnips')]]} -- Snippets

  -- LSP
  use 'onsails/lspkind-nvim'
  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/lsp-status.nvim'
  -- use {
  --     'nvim-treesitter/nvim-treesitter',
  --     requires = {
  --       'nvim-treesitter/nvim-treesitter-refactor', 'nvim-treesitter/nvim-treesitter-textobjects'
  --     },
  --     config = [[require('config.treesitter')]]}
  -- use 'thomasfaingnaert/vim-lsp-ultisnips' --ultisnips in LSP

  -- Completion
  use {'hrsh7th/nvim-compe', config = [[require('config.compe')]]}

  -- Syntax
  vim.g.polyglot_disabled = {'yaml', 'markdown', 'php'}
  use 'sheerun/vim-polyglot' --syntax for a lot of types
  use 'plasticboy/vim-markdown' --markdown syntax
  use 'StanAngeloff/php.vim' --php syntax
  use {
    'norcalli/nvim-colorizer.lua',
    ft = {'css', 'javascript', 'vim', 'html', 'yaml'},
    config = [[require('colorizer').setup {'css', 'javascript', 'vim', 'html', 'yaml'}]]
  }

  -- Text objects
  use 'kana/vim-textobj-user'
  use 'kana/vim-textobj-line'
  use 'kana/vim-textobj-indent'
  use 'glts/vim-textobj-comment'
  use 'kana/vim-textobj-entire'

  -- PHP stuff
  use {'2072/PHP-Indenting-for-VIm', ft = {'php'}, config = [[require('config.phpindent')]]} --updated indenting
  use {'arnaud-lb/vim-php-namespace', ft = {'php'}} --insert use statements automatically
  use {'sahibalejandro/vim-php', ft = {'php'}} --insert absolute FQCN
  use {'fenetikm/phpfolding.vim', ft = {'php'}, config = [[require('config.phpfolding')]]} --php folding
  use {'alvan/vim-php-manual', ft = {'php'}} --php manual
  use {'fenetikm/vim-textobj-function', ft = {'php'}} --function textobj with php

  -- Uncategorised
  use {'dkarter/bullets.vim', config = [[require('config.bullets')]]} --smart bullet support
  use {'tpope/vim-unimpaired', event = {'VimEnter'}} --Various dual pair commands
  use 'tpope/vim-repeat' --Repeat plugin commands
  use 'Valloric/ListToggle' --Toggle quickfix and location lists
  use 'mhinz/vim-startify' -- Start up screen
  use 'tyru/current-func-info.vim' --get the current function info
  use 'machakann/vim-swap' --swap params around

  -- TODO replace with nvim version
  use 'fiatjaf/neuron.vim' --zettel management

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
  -- dial
  -- lspsaga

end)
