-- Notes:
-- had to run `Lazy build ...` to get fzf native working
-- updated to latest nerdfonts symbols
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
    lazy = false,
  },

  -- Matching
  {
    'echasnovski/mini.pairs', -- brackets, parens
    event = 'VeryLazy',
    version = false,
    opts = {},
  },
  {
    'echasnovski/mini.surround', -- surrounding pairs
    event = 'VeryLazy',
    version = false,
    opts = {},
  },
  {
    'gregsexton/MatchTag',
    ft = {'html'}, --html tag matching
  },
  {'andymass/vim-matchup', event = 'VimEnter'},

  -- Git - see git.lua

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

  -- Tmux
  { 'benmills/vimux', event = 'VeryLazy'},

  -- Distraction
  {'junegunn/goyo.vim', event = 'VeryLazy'},

  -- Motion
  { 'chaoren/vim-wordmotion', event = 'VeryLazy'},--Expand the definition of what a word is
  { 'christoomey/vim-tmux-navigator', event = 'VeryLazy'},--navigate betwenn tmux splits and vim together

  -- Search
  {'BurntSushi/ripgrep', event = 'VeryLazy'}, --ripgrep support, neuron and telescope want it
  {'wincent/loupe', event = 'VeryLazy'}, --nicer search highlighting
  -- {'wincent/ferret', event = 'VeryLazy'}, --multi file search
  {dir = '/usr/local/opt/fzf', event = 'VeryLazy'}, --fzf
  {'junegunn/fzf.vim', event = 'VeryLazy'}, --fuzzy finder stuff
  {'nelstrom/vim-visual-star-search', event = 'VeryLazy'}, --use * in visual mode to search
  -- {'jesseleite/vim-agriculture', event = 'VeryLazy'}, --pass things through to rg
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {
      highlight = {
        backdrop = false
      }
    },
    keys = {
      { "<leader>j", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "<leader>J", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  -- Replace
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    opts = {
      open_cmd = "noswapfile vnew",
      color_devicons = false,
      replace_engine={
        ['sed']={
          cmd = "gsed",
          args = nil,
          options = {
            ['ignore-case'] = {
              value= "--ignore-case",
              icon="[I]",
              desc="ignore case"
            },
          }
        },
      },
    },
    keys = {
      { '<leader>R', function() require('spectre').open() end, desc = 'Replace in files' },
    },
  },
  {
    'monaqa/dial.nvim',
    keys = {
      {'+', '<Plug>(dial-increment)', desc = 'Increment value'},
      {'-', '<Plug>(dial-decrement)', desc = 'Decrement value'},
    },
    config = function()
      local augend = require('dial.augend')
      require('dial.config').augends:register_group{
        default = {
          augend.integer.alias.decimal_int,
          augend.date.alias['%Y-%m-%d'],
          augend.misc.alias.markdown_header,
          augend.constant.alias.bool,
          augend.constant.new{
            elements = {'False', 'True'},
            word = true,
            cyclic = true,
          },
          augend.paren.alias.quote,
        }
      }
    end,
  },

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

  -- see luasnip.lua for snippets

  -- LSP see file lsp.lua

  -- Treesitter see file treesitter.lua

  -- cmp see file cmp.lua

  -- Syntax
  {
    'preservim/vim-markdown',
    ft = {'markdown'},
    config = function()
      vim.g.vim_markdown_frontmatter = 1
      vim.g.vim_markdown_strikethrough = 1 --strikethrough support, with two tildes ~~
      vim.g.vim_markdown_no_extensions_in_markdown = 1 --.md not required in links
      vim.g.vim_markdown_auto_insert_bullets = 0 --disable new line bullets
      vim.g.vim_markdown_new_list_item_indent = 0 --disable the indenting
      vim.g.vim_markdown_autowrite = 1 --save file when following a link
      vim.g.vim_markdown_folding_style_pythonic = 1
    end
  },
  {
    'norcalli/nvim-colorizer.lua',
    opts = { 'css', 'html' },
    ft = { 'css', 'html' },
    cmd = {'ColorizerAttachToBuffer', 'ColorizerToggle'}
  },

  -- Text objects
  {
    "echasnovski/mini.ai",
    version = false,
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        mappings = {
          inside_last = '',
          around_last = '',
        },
        n_lines = 100,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
          e = function() --entire file
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line('$'),
              col = math.max(vim.fn.getline('$'):len(), 1)
            }
            return { from = from, to = to }
          end,
          l = function() --current line, have to disable around/inside last which clashes
            local current_line = vim.fn.line('.')
            local from = {
              line = current_line,
              col = 1,
            }
            local to = {
              line = current_line,
              col = math.max(vim.fn.getline('.'):len(), 1)
            }
            return { from = from, to = to, vis_mode = 'V' }
          end,
        },
      }
    end,
  },
  {
    'chrisgrieser/nvim-various-textobjs',
    event = 'VeryLazy',
    keys = {
      {'ii', '<cmd>lua require("various-textobjs").indentation("inner", "inner")<cr>', mode = {"x", "o"}, silent = true},
      {'ai', '<cmd>lua require("various-textobjs").indentation("outer", "inner")<cr>', mode = {"x", "o"}, silent = true},
    }
  },

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

  -- Telescope see telescope.lua

  -- Alpha see alpha.lua

  -- Other
  {
    'dkarter/bullets.vim',
    ft = {'markdown','text'},
    init = function ()
      vim.g.bullets_enabled_file_types = {'markdown', 'text'}
      vim.g.bullets_enable_in_empty_buffers = 0
      vim.g.bullets_pad_right = 0
      vim.g.bullets_checkbox_markers = ' .oOX'
      vim.g.bullets_set_mappings = 0
      vim.g.bullets_custom_mappings = {
        { 'imap', '<cr>', '<Plug>(bullets-newline)' },
        { 'nmap', '<cr>', '<Plug>(bullets-toggle-checkbox)' }
      }
    end
  },
  {'tpope/vim-unimpaired', event = 'VimEnter'}, --Various dual pair commands
  {'tpope/vim-repeat', event = 'VimEnter'}, --Repeat plugin commands
  {'Valloric/ListToggle', event = 'InsertEnter'}, --Toggle quickfix and location lists
  { -- REST client
    'rest-nvim/rest.nvim',
    keys = {
      { '<localleader>r', '<Plug>RestNvim', desc = 'Run reset request' }
    },
    dependencies = { { "nvim-lua/plenary.nvim" } },
    config = function()
      require("rest-nvim").setup({
        result_split_in_place = true,
      })
    end,
  },

  -- Writing
  {
    'folke/zen-mode.nvim',
    dependencies = {
      {
        'folke/twilight.nvim',
        opts = {
          context = 12,
          dimming = {
            alpha = 0.5
          }
        }
      }
    },
    keys = {
      {'<leader>z', function() require('zen-mode').toggle() end},
    },
    opts = {
      window = {
        width = 90,
        options = {
          relativenumber = false,
          number = false
        }
      },
      plugins = {
        tmux = { enabled = true },
        kitty = {
          enabled = true,
          font = "+4",
        },
      },
      on_open = function()
        require('gitsigns').toggle_signs(false)
      end,
      on_close = function()
        require('gitsigns').toggle_signs(true)
      end,
    }
  },
}

--[[
  -- From old list
  -- https://github.com/gelguy/wilder.nvim better wild menu, neovim
  -- https://github.com/vhyrro/neorg
  -- https://github.com/rcarriga/vim-ultest
  -- https://github.com/folke/todo-comments.nvim
  -- some from https://neovimcraft.com/
  -- https://github.com/phaazon/hop.nvim
  -- stuff from https://github.com/CosmicNvim/CosmicNvim
  -- https://github.com/jose-elias-alvarez/null-ls.nvim
  -- https://www.lunarvim.org/plugins/02-default-plugins.html and maybe some from extra
  -- https://github.com/Pocco81/TrueZen.nvim
  -- https://github.com/nvim-pack/nvim-spectre
  -- https://github.com/f-person/git-blame.nvim
  -- https://github.com/lewis6991/impatient.nvim
  -- https://github.com/ggandor/leap.nvim
  -- https://github.com/s1n7ax/nvim-search-and-replace
  -- https://github.com/L3MON4D3/LuaSnip
  -- https://github.com/chentoast/marks.nvim replacement for vim-signature, neovim
  -- https://github.com/zbirenbaum/copilot.lua
  -- https://github.com/zbirenbaum/copilot-cmp
  -- https://github.com/folke/neodev.nvim for development
  -- https://github.com/utilyre/barbecue.nvim
  -- https://github.com/johmsalas/text-case.nvim
  -- https://github.com/anuvyklack/hydra.nvim
  -- laytan/cloak.nvim - useful when streaming and you want to hide what is in a file if accidentally viewing it
  -- https://github.com/stevearc/oil.nvim edit buffer to make directory changes
  -- https://github.com/kevinhwang91/nvim-ufo
  -- https://github.com/johmsalas/text-case.nvim
  --
  -- plugin lists to look through:
  -- - https://github.com/yutkat/dotfiles/blob/master/.config/nvim/lua/rc/pluginlist.lua
  --
  -- dotfiles:
  -- - https://github.com/bluz71/dotfiles/blob/master/vim/lua/lsp-config.lua
--]]
