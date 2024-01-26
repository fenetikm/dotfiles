return {
  {
    'hrsh7th/nvim-cmp',
    version = false,
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lua',
      -- 'quangnguyen30192/cmp-nvim-ultisnips',
      'saadparwaiz1/cmp_luasnip',
      -- 'amarakon/nvim-cmp-buffer-lines',
    },
    opts = function ()
      local lspkind = require('lspkind')
      lspkind.init()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

      return {
        completion = {
          keyword_length = 2
        },
        snippet = {
          expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- vim.fn['UltiSnips#Anon'](args.body) -- For `ultisnips` users.
            -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<c-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior },
          ["<c-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior },
          ['<c-d>'] = cmp.mapping.scroll_docs(-4),
          ['<c-u>'] = cmp.mapping.scroll_docs(4),
          ['<c-space>'] = cmp.mapping.complete(),
          ['<c-l>'] = function(fallback)
              if cmp.visible() then
                -- close, show line matches
                cmp.mapping.close()
                fallback()
              else
                fallback()
              end
            end,
          ['<c-e>'] = function(fallback)
              if cmp.visible() then
                -- close and move to end
                cmp.mapping.close()
                fallback()
              else
                fallback()
              end
            end,
          ['<c-cr>'] = cmp.mapping.confirm({ select = true }),
          ['<c-j'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end
          end, {'i'})
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lua', max_item_count = 15 },
          { name = 'nvim_lsp', max_item_count = 15},
          -- { name = 'ultisnips', priority = 1, max_item_count  = 15},
          { name = 'luasnip', priority = 1, max_item_count = 7 }, -- For luasnip users.
        },
        {
          { name = 'path', max_item_count = 15, keyword_length = 5 },
          {
            name = 'buffer',
            max_item_count = 15,
            get_bufnrs = function()
              -- complete from visible buffers
              local bufs = {}
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                bufs[vim.api.nvim_win_get_buf(win)] = true
              end
              return vim.tbl_keys(bufs)
            end
          },
          -- {
          --   name = 'buffer-lines',
          --   option = {
          --     leading_whitespace = false,
          --   },
          --   max_item_count = 5,
          -- }
        }),
        formatting = {
          format = lspkind.cmp_format {
            mode = 'symbol_text',
            maxwidth = 30,
            ellipsis_char = '...',
            menu = {
              -- ['buffer-lines'] = '[BfL]',
              buffer = '[Buf]',
              nvim_lsp = '[LSP]',
              nvim_lua = '[Lua]',
              path = '[Path]',
              -- ultisnips = '[Snip]',
              luasnip = '[Snip]',
            }
          }
        },
        sorting = {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            function(entry1, entry2)
              local _, entry1_under = entry1.completion_item.label:find "^_+"
              local _, entry2_under = entry2.completion_item.label:find "^_+"
              entry1_under = entry1_under or 0
              entry2_under = entry2_under or 0
              if entry1_under > entry2_under then
                return false
              elseif entry1_under < entry2_under then
                return true
              end
            end,

            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        experimental = {
          native_menu = false,
          ghost_text = {
            hl_group = 'CmpGhostText'
          }
        }
      }
    end
  },
}
