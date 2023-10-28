-- Notes:
-- had to run `Lazy build ...` to get fzf native working
return {
  -- Colours
  'rktjmp/lush.nvim',
  { 'rktjmp/shipwright.nvim', cmd = 'Shipwright' },
  {
    dir = '~/Documents/Work/internal/vim/colors/falcon',
    lazy = false,
    priority = 1000,
    dependencies = {'rktjmp/lush.nvim'},
    config = function()
      vim.g.falcon_settings = {
        italic_comments = false,
        transparent_bg = false,
        inactive_bg = true,
        lsp_underline = 'errrr',
        variation = 'modern',
      }
      package.loaded['falcon'] = nil
      require('lush')(require('falcon').setup())
    end
  },

  -- Project management
  {
    'dbakker/vim-projectroot'
  },
  {
    'embear/vim-localvimrc',
    config = function()
      vim.g.localvimrc_ask = 0
      vim.g.localvimrc_sandbox = 0
      vim.g.localvimrc_name = {'.lvimrc'}
    end
  },

  -- Matching
  {
    'cohama/lexima.vim', event = 'VeryLazy' },-- auto closing pairs
  { 'machakann/vim-sandwich', event = 'VimEnter'}, --surround handling
  {
    'gregsexton/MatchTag',
    ft = {'html'}, --html tag matching
  },
  {'andymass/vim-matchup', event = 'VimEnter'},

  -- Git
  {
    'tpope/vim-fugitive',
    keys = {
      {'<leader>gs', '<cmd>Git<cr>', silent = true, noremap = true},
      {'<leader>gr', '<cmd>Gread<cr>', noremap = true},
      {'<leader>gl', '<cmd>Git log<cr>', noremap = true},
      {'<leader>gb', '<cmd>Git blame<cr>', noremap = true},
      {'<leader>gd', '<cmd>Gvdiffsplit!<cr>', noremap = true},
    }
  },

  -- Testing
  {
    'janko-m/vim-test',
    keys = {
      {'<leader>oo', '<cmd>TestLast<cr>', silent = true, noremap = true},
      {'<leader>on', '<cmd>TestNearest<cr>', silent = true, noremap = true},
      {'<leader>of', '<cmd>TestFile<cr>', silent = true, noremap = true},
    }
  },

  -- Spelling
  {'tpope/vim-abolish'},

  -- TMUX
  { 'benmills/vimux', event = 'VeryLazy'},

  -- Distraction
  {'junegunn/goyo.vim', event = 'VeryLazy'},

  -- Motion
  {
    'rhysd/clever-f.vim',
    config = function ()
      vim.g.clever_f_across_no_line = 1
      vim.g.clever_f_timeout_ms = 3000
    end,
    event = 'VimEnter',
  },
  { 'chaoren/vim-wordmotion', event = 'VeryLazy'},--Expand the definition of what a word is
  { 'christoomey/vim-tmux-navigator', event = 'VeryLazy'},--navigate betwenn tmux splits and vim together
  { 'wellle/targets.vim', event = 'VimEnter'},--Additional target text objects

  -- Search
  {'BurntSushi/ripgrep', event = 'VeryLazy'}, --ripgrep support, neuron and telescope want it
  {'wincent/loupe', event = 'VeryLazy'}, --nicer search highlighting
  {'wincent/ferret', event = 'VeryLazy'}, --multi file search
  {dir = '/usr/local/opt/fzf', event = 'VeryLazy'}, --fzf
  {'junegunn/fzf.vim', event = 'VeryLazy'}, --fuzzy finder stuff
  {'nelstrom/vim-visual-star-search', event = 'VeryLazy'}, --use * in visual mode to search
  {'jesseleite/vim-agriculture', event = 'VeryLazy'}, --pass things through to rg

  -- Statusline, see lualine.lua file

  -- Sign column, see signs.lua file

  -- Guides, see indent_blankline.lua file

  -- Formatting
  {
    'junegunn/vim-easy-align',
    cmd = {'EasyAlign'},
    config = function ()
      vim.g.easy_align_bypass_fold = 1
      vim.g.easy_align_ignore_groups = {}
    end
  },

  -- Repl
  {
    'jpalardy/vim-slime',
    event = 'VeryLazy',
    config = function ()
      vim.g.slime_target = 'tmux'
      vim.g.slime_default_config = {
            socket_name = 'default',
            target_pane = '{right}'
      }
    end
  }, --send output from buffer to tmux / repl

  -- Snippets
  {
    'Sirver/ultisnips',
    event = 'VeryLazy',
    config = function ()
      vim.g.UltiSnipsSnippetsDir = "~/.config/nvim/UltiSnips"
      vim.g.UltiSnipsEditSplit = "vertical"
      vim.g.UltiSnipsExpandTrigger = "<c-j>"
      vim.g.UltiSnipsJumpForwardTrigger = "<c-j>"
      vim.g.UltiSnipsJumpBackwardTrigger = "<c-k>"
    end
  },

  -- LSP see file lsp.lua

  -- Treesitter see file treesitter.lua

  -- cmp see file cmp.lua

  -- Syntax
  {
    'plasticboy/vim-markdown',
    ft = {'markdown'}
  },
  {
    'norcalli/nvim-colorizer.lua',
    opts = { 'css', 'html' },
    ft = { 'css', 'html' },
  },

  -- Text objects
  {'kana/vim-textobj-user', event = 'VeryLazy'},
  {'kana/vim-textobj-line', dependencies = {'kana/vim-textobj-user'}, event = 'VeryLazy'},
  {'kana/vim-textobj-indent', dependencies = {'kana/vim-textobj-user'}, event = 'VeryLazy'},
  {'glts/vim-textobj-comment', dependencies = {'kana/vim-textobj-user'}, event = 'VeryLazy'},
  {'kana/vim-textobj-entire', dependencies = {'kana/vim-textobj-user'}, event = 'VeryLazy'},

  -- Languages
  -- PHP
  {
    'fenetikm/phpfolding.vim',
    ft = {'php'},
    config = function ()
      vim.g.PHPFoldingCollapsedSymbol = '+'
      vim.g.PHPFoldingRepeatSymbol = ''
      vim.g.PHPFoldingShowPercentage = 0
      vim.g.phpDocIncludedPostfix = ''
      vim.g.DisableAutoPHPFolding = 1
    end
  },
  {'alvan/vim-php-manual', ft = {'php'}}, --php manual

  -- Java
  {'mfussenegger/nvim-jdtls', ft = {'java'}},

  -- Debugging see debugging.lua

  -- Other
  -- TODO shift this to the bottom
  {
    'dkarter/bullets.vim',
    ft = {'markdown','text'},
    config = function ()
      vim.g.bullets_enabled_file_type = {markdown, text}
      vim.g.bullets_enable_in_empty_buffers = 0
      vim.g.bullets_pad_right = 0
      vim.g.bullets_checkbox_markers = ' .oOX'
    end
  },
  {'tpope/vim-unimpaired', event = 'VimEnter'}, --Various dual pair commands
  {'tpope/vim-repeat', event = 'VimEnter'}, --Repeat plugin commands
  {'Valloric/ListToggle', event = 'VimEnter'}, --Toggle quickfix and location lists

  -- Telescope see telescope.lua

  -- Alpha see alpha.lua
}
