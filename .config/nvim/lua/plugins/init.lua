-- Notes:
-- had to run `Lazy build ...` to get fzf native working
-- updated to latest nerdfonts symbols
return {
  -- Colours
  'rktjmp/lush.nvim',
  { 'rktjmp/shipwright.nvim',          cmd = 'Shipwright' },
  {
    dir = '~/Documents/Work/internal/vim/colors/falcon',
    lazy = false,
    priority = 1000,
    dependencies = { 'rktjmp/lush.nvim' },
    config = function()
      vim.g.falcon_settings = {
        italic_comments = false,
        transparent_bg = true,
        inactive_bg = false,
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
    ft = { 'html' }, --html tag matching
  },
  {
    'andymass/vim-matchup',
    event = { "BufReadPre", "BufNewFile" }
  },

  -- Git - see git.lua

  -- Testing
  {
    'janko-m/vim-test',
    cmd = {
      'TestLast',
      'TestNearest',
      'TestFile',
    },
    keys = {
      { '<leader>oo', '<cmd>TestLast<cr>',    silent = true, noremap = true },
      { '<leader>on', '<cmd>TestNearest<cr>', silent = true, noremap = true },
      { '<leader>of', '<cmd>TestFile<cr>',    silent = true, noremap = true },
    }
  },

  -- Spelling
  { 'tpope/vim-abolish' },

  -- Tmux integration
  { 'benmills/vimux',                  event = 'VeryLazy' },

  -- Focus mode
  { 'junegunn/goyo.vim',               event = 'VeryLazy' },

  -- Motion
  { 'chaoren/vim-wordmotion',          event = 'VeryLazy' }, --Expand the definition of what a word is
  { 'christoomey/vim-tmux-navigator',  event = 'VeryLazy' }, --navigate betwenn tmux splits and vim together

  -- Search
  { 'BurntSushi/ripgrep',              event = 'VeryLazy' },
  -- {'wincent/loupe', event = 'VeryLazy'}, --nicer search highlighting
  -- {'wincent/ferret', event = 'VeryLazy'}, --multi file search
  --
  { 'nelstrom/vim-visual-star-search', event = 'VeryLazy' }, --use * in visual mode to search
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
      { "<leader>j", mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "<leader>J", mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",         mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",         mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>",     mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },

  -- Replace
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    opts = {
      open_cmd = "noswapfile vnew",
      color_devicons = false,
      replace_engine = {
        ['sed'] = {
          cmd = "gsed",
          args = nil,
          options = {
            ['ignore-case'] = {
              value = "--ignore-case",
              icon = "[I]",
              desc = "ignore case"
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
      { '+', '<Plug>(dial-increment)', desc = 'Increment value' },
      { '-', '<Plug>(dial-decrement)', desc = 'Decrement value' },
    },
    config = function()
      local augend = require('dial.augend')
      require('dial.config').augends:register_group {
        default = {
          augend.integer.alias.decimal_int,
          augend.date.alias['%Y-%m-%d'],
          augend.misc.alias.markdown_header,
          augend.constant.alias.bool,
          augend.constant.new {
            elements = { 'False', 'True' },
            word = true,
            cyclic = true,
          },
        }
      }
    end,
  },
  {
    'echasnovski/mini.splitjoin',
    version = '*',
    config = function()
      require('mini.splitjoin').setup()
    end
  },

  -- Statusline, see lualine.lua file

  -- Sign column, see signs.lua file

  -- Guides, see indent_blankline.lua file

  -- Formatting
  {
    'junegunn/vim-easy-align',
    cmd = { 'EasyAlign' },
    config = function()
      vim.g.easy_align_bypass_fold = 1
      vim.g.easy_align_ignore_groups = {}
    end
  },

  -- Markdown
  {
    "OXY2DEV/markview.nvim",
    ft = { 'markdown', 'md' },
    config = {
      preview = {
        enable = false
      }
    }
  },

  -- Repl
  {
    'jpalardy/vim-slime',
    event = 'VeryLazy',
    config = function()
      vim.g.slime_target = 'tmux'
      vim.g.slime_default_config = {
        socket_name = 'default',
        target_pane = '{right}'
      }
    end
  }, --send output from buffer to tmux / repl

  -- see luasnip.lua for snippets

  -- LSP see file lsp.lua
  -- configs are here: https://github.com/neovim/nvim-lspconfig/tree/master/lsp

  -- External pacakage manager
  {
    "mason-org/mason.nvim",
    event = 'VeryLazy',
    opts = {}
  },

  -- Treesitter see file treesitter.lua

  -- cmp see file cmp.lua

  -- Syntax
  {
    'preservim/vim-markdown',
    ft = { 'markdown' },
    config = function()
      vim.g.vim_markdown_frontmatter = 1
      vim.g.vim_markdown_strikethrough = 1             --strikethrough support, with two tildes ~~
      vim.g.vim_markdown_no_extensions_in_markdown = 1 --.md not required in links
      vim.g.vim_markdown_auto_insert_bullets = 0       --disable new line bullets
      vim.g.vim_markdown_new_list_item_indent = 0      --disable the indenting
      vim.g.vim_markdown_autowrite = 1                 --save file when following a link
      vim.g.vim_markdown_folding_style_pythonic = 1
    end
  },
  {
    'norcalli/nvim-colorizer.lua',
    opts = { 'css', 'html' },
    ft = { 'css', 'html' },
    cmd = { 'ColorizerAttachToBuffer', 'ColorizerToggle' }
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
      { 'ii', '<cmd>lua require("various-textobjs").indentation("inner", "inner")<cr>', mode = { "x", "o" }, silent = true },
      { 'ai', '<cmd>lua require("various-textobjs").indentation("outer", "inner")<cr>', mode = { "x", "o" }, silent = true },
    }
  },

  -- Folding
  {
    'kevinhwang91/nvim-ufo',
    enabled = false,
    event = 'VeryLazy',
    enabled = false,
    dependencies = {
      'kevinhwang91/promise-async',
    },
    config = function()
      local handler = function(virtText, lnum, endLnum, width, truncate, ctx)
        local newVirtText = {}
        local foldedLines = endLnum - lnum
        local suffix = ("{%d}"):format(foldedLines)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        local fullText = ""

        for _, chunk in ipairs(virtText) do
          -- chunks are made of the text and the highlight
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          -- print('chunk text')
          -- print(chunkText)
          -- print(chunkWidth)
          -- print(targetWidth)
          -- print(width)
          -- not sure what the point of this is
          -- it looks to be truncating the "chunk"
          -- but that doesn't always work
          -- if the text goes right to the end truncating the chunk doesn't help
          if targetWidth > curWidth + chunkWidth then
            -- just print at the end, as is
            -- table.insert(newVirtText, chunk)
            -- print('if')
          else
            -- print('else')
            -- chunkText = truncate(chunkText, targetWidth - curWidth)
            -- chunkText = truncate(chunkText, 20)
            local hlGroup = chunk[2]
            -- table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
          fullText = fullText .. chunkText
        end
        local fill = '╴'
        local rAlignAppndx = math.max(math.min(vim.api.nvim_win_get_width(0), width - 1) - curWidth - sufWidth - 1, 0)
        -- print('ralign')
        -- print(rAlignAppndx)
        rAlignAppndx = 20
        suffix = ' ' .. (fill):rep(rAlignAppndx) .. suffix
        -- local thing = (' '):rep(40)
        -- table.insert(newVirtText, { thing, "MoreMsg" })
        -- table.insert(newVirtText, { suffix, "MoreMsg" })
        -- table.insert(newVirtText, { 'hello', 'MoreMsg' })
        table.insert(newVirtText, { fullText, 'MoreMsg' })
        return newVirtText
      end

      require('ufo').setup({
        fold_virt_text_handler = handler,
        -- to see exactly what is in the virtual text, example:
        --[[
        -- virtText:  { { "function ", "UfoFoldedFg" }, { "long_function_name
", 1007 }, { "(", 1010 }, { "arg_one", "@lsp.type.parameter.lua" }, { ",", 101
4 }, { " ", "UfoFoldedFg" }, { "arg_two", "@lsp.type.parameter.lua" }, { ",",
1014 }, { " ", "UfoFoldedFg" }, { "arg_three", "@lsp.type.parameter.lua" }, {
",", 1014 }, { " ", "UfoFoldedFg" }, { "arg_fasdfg", "@lsp.type.parameter.lua"
 }, { ",", 1014 }, { " ", "UfoFoldedFg" }, { "a", "@lsp.type.parameter.lua" },
 { ")", 1010 } }
        -- ]]
        -- fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate, ctx)
        --   for i = lnum, endLnum do
        --     print('lnum: ', i, ', virtText: ', vim.inspect(ctx.get_fold_virt_text(i)))
        --   end
        --   return virtText
        -- end,
        enable_get_fold_virt_text = true,
      })
    end
  },

  -- a simple fold status column
  {
    'luukvbaal/statuscol.nvim',
    event = 'VeryLazy',
    config = function()
      local builtin = require('statuscol.builtin')
      require('statuscol').setup({
        -- relculright = true,
        segments = {
          { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
          { text = { '%s' },             click = 'v:lua.ScSa' },
          {
            text = { builtin.lnumfunc, ' ' },
            condition = { true, builtin.not_empty },
            click = 'v:lua.ScLa',
          },
        }
      })
    end,
  },

  -- Languages
  -- PHP
  {
    'fenetikm/phpfolding.vim',
    ft = { 'php' },
    config = function()
      vim.g.PHPFoldingCollapsedSymbol = '+'
      vim.g.PHPFoldingRepeatSymbol = ''
      vim.g.PHPFoldingShowPercentage = 0
      vim.g.phpDocIncludedPostfix = ''
      vim.g.DisableAutoPHPFolding = 1
    end
  },
  { 'alvan/vim-php-manual',    ft = { 'php' } }, --php manual

  -- Java
  { 'mfussenegger/nvim-jdtls', ft = { 'java' } },

  -- Debugging see debugging.lua

  -- Telescope see telescope.lua

  -- Folding
  -- {
  --   'bbjornstad/pretty-fold.nvim',
  --   event = 'VeryLazy',
  --   config = function()
  --     print('enable pretty folds')
  --     require('pretty-fold').setup()
  --   end
  -- },

  -- Code documentor
  -- had to run :call doge#install() to get this going
  {
    "kkoomen/vim-doge",
    event = 'VeryLazy',
    keys = {
      { '<leader>dd', '<plug>(doge-generate)' }
    },
    init = function()
      vim.g.doge_enable_mappings = 0
      vim.g.doge_mapping_comment_jump_forward = '<c-j>'
      vim.g.doge_mapping_comment_jump_backward = '<c-n>'
    end
  },

  -- Alpha see alpha.lua

  -- AI see ai.lua

  -- Other
  {
    'dkarter/bullets.vim',
    ft = { 'markdown', 'text' },
    init = function()
      vim.g.bullets_enabled_file_types = { 'markdown', 'text' }
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
  { 'tpope/vim-unimpaired', event = 'VimEnter' }, --Various dual pair commands
  { 'tpope/vim-repeat',     event = 'VimEnter' }, --Repeat plugin commands
  { 'Valloric/ListToggle',  event = 'VeryLazy' }, --Toggle quickfix and location lists
  {
    'Wansmer/sibling-swap.nvim',                  -- swap nodes e.g. params/args, conditions etc.
    event = 'VeryLazy',
    keys = {
      { '<C-.>', function() require('sibling-swap').swap_with_right() end, desc = "Swap with right node" },
      { '<C-,>', function() require('sibling-swap').swap_with_left() end,  desc = "Swap with left node" },
    },
    config = function()
      require('sibling-swap').setup({
        use_default_keymaps = false,
      })
    end
  },

  -- {
  --   event = 'VeryLazy',
  --   "vhyrro/luarocks.nvim",
  --   config = true,
  --   opts = {
  --     rocks = {  "lua-curl", "nvim-nio", "mimetypes", "xml2lua" }, -- Specify LuaRocks packages to install
  --   },
  -- },
  { -- REST client, should just work with latest version of lazy
    'rest-nvim/rest.nvim',
    ft = 'http',
    keys = {
      { '<localleader>r', '<cmd>Rest run<cr>', desc = 'Run reset request' }
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        table.insert(opts.ensure_installed, "http")
      end,
    },
    config = function()
      vim.g.rest_nvim = {
        request = {
          skip_ssl_verification = true
        }
      }
    end
  },

  -- Writing
  {
    'folke/zen-mode.nvim',
    dependencies = {
      {
        'folke/twilight.nvim',
        opts = {
          context = 15,
          dimming = {
            alpha = 0.5
          }
        }
      }
    },
    keys = {
      { '<leader>z', function() require('zen-mode').toggle() end },
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
        kitty = { -- sometimes fails after sleeping because wrong port
          enabled = true,
          font = "+4",
        },
      },
      on_open = function()
        require('gitsigns').toggle_signs(false)
        if vim.fn.exists(':IBLDisable') then
          vim.cmd('IBLDisable')
        end
      end,
      on_close = function()
        require('gitsigns').toggle_signs(true)
        if vim.fn.exists(':IBLEnable') then
          vim.cmd('IBLEnable')
        end
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
  -- https://github.com/f-person/git-blame.nvim
  -- https://github.com/lewis6991/impatient.nvim
  -- https://github.com/ggandor/leap.nvim
  -- https://github.com/s1n7ax/nvim-search-and-replace
  -- https://github.com/chentoast/marks.nvim replacement for vim-signature, neovim
  -- https://github.com/zbirenbaum/copilot.lua
  -- https://github.com/zbirenbaum/copilot-cmp
  -- https://github.com/folke/neodev.nvim for development
  -- https://github.com/utilyre/barbecue.nvim
  -- https://github.com/johmsalas/text-case.nvim
  -- https://github.com/anuvyklack/hydra.nvim
  -- https://github.com/romainl/vim-qf working with the quickfix
  -- laytan/cloak.nvim - useful when streaming and you want to hide what is in a file if accidentally viewing it
  -- https://github.com/stevearc/oil.nvim edit buffer to make directory changes
  -- https://github.com/kevinhwang91/nvim-ufo
  -- https://github.com/johmsalas/text-case.nvim
  -- https://github.com/folke/neodev.nvim for developing plugins, has better autocomplete
  -- https://github.com/protex/better-digraphs.nvim use telescope with digraphs
  -- https://github.com/gabrielpoca/replacer.nvim
  -- https://github.com/epwalsh/obsidian.nvim
  -- AI stuffs:
  -- https://github.com/huynle/ogpt.nvim
  -- https://github.com/David-Kunz/gen.nvim
  -- https://github.com/nomnivore/ollama.nvim
  -- https://github.com/mg979/vim-visual-multi or https://github.com/smoka7/multicursors.nvim
  -- https://github.com/LunarVim/bigfile.nvim for turning off things for big files
  -- https://github.com/brenoprata10/nvim-highlight-colors colours in virtual text
  -- https://github.com/johmsalas/text-case.nvim
  -- https://github.com/stevearc/aerial.nvim outline of code
  -- https://github.com/folke/snacks.nvim lots of QoL plugins, couple look good
  -- https://github.com/chrisgrieser/nvim-scissors quick creation of snippets
  -- https://github.com/chrisgrieser/nvim-spider better w,e,b movement, can skip punctuation
  -- https://github.com/MagicDuck/grug-far.nvim find and replace
  -- https://github.com/OXY2DEV/helpview.nvim better viewing of help files
  -- https://github.com/HakonHarnes/img-clip.nvim uses pngpaste to do embed links to images, apparently you can do drag and drop in kitty?
  -- https://github.com/S1M0N38/dante.nvim ai writing, simple changes
  -- https://github.com/Maan2003/lsp_lines.nvim shows lsp diagnostics on separate lines underneath the thing, kinda cool? see below, in new neovim
  -- https://github.com/b0o/incline.nvim show file name top right, could be really good to then use the global statusline e.g. https://github.com/b0o/incline.nvim/discussions/29
  -- https://github.com/smjonas/inc-rename.nvim incremental rename
  -- https://github.com/saghen/blink.cmp faster completion
  -- https://github.com/Saghen/blink.pairs faster pair matching etc.
  -- https://github.com/iguanacucumber/magazine.nvim nvim-cmp fork
  -- https://github.com/Robitx/gp.nvim gpt prompting and library etc.
  -- https://github.com/NStefan002/screenkey.nvim for showing which key(s) are being pressed
  -- https://github.com/OXY2DEV/markview.nvim markdown viewer
  -- https://github.com/stevearc/quicker.nvim quickfix editing etc.
  -- https://github.com/TaDaa/vimade for fading inactive window
  -- https://github.com/cbochs/grapple.nvim?tab=readme-ov-file like harpoon
  -- https://github.com/folke/sidekick.nvim ai side panel by folke, has some good preset prompts
  -- https://github.com/NickvanDyke/opencode.nvim?tab=readme-ov-file opencode integration
  --
  -- new neovim features:
  -- https://gpanders.com/blog/whats-new-in-neovim-0-11/ virtual lines looks cool
  --
  -- plugin lists to look through:
  -- - https://github.com/yutkat/dotfiles/blob/master/.config/nvim/lua/rc/pluginlist.lua
  --
  -- dotfiles:
  -- - https://github.com/bluz71/dotfiles/blob/master/vim/lua/lsp-config.lua
--]]
