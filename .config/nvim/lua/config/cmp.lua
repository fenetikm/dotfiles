local cmp = require 'cmp'
local lspkind = require('lspkind')
lspkind.init()

cmp.setup({
    completion = {
      keyword_length = 2
    },
    snippet = {
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        vim.fn['UltiSnips#Anon'](args.body) -- For `ultisnips` users.
        -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
      end,
    },
    mapping = {
      ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
      ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-l>'] = function(fallback)
          if cmp.visible() then
            -- close, show line matches
            cmp.mapping.close()
            fallback()
          else
            fallback()
          end
        end,
      ['<C-e>'] = function(fallback)
          if cmp.visible() then
            -- close and move to end
            cmp.mapping.close()
            fallback()
          else
            fallback()
          end
        end,
      ['<C-CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lua', max_item_count = 15 },
      { name = 'nvim_lsp', max_item_count = 15},
      { name = 'ultisnips', priority = 1, max_item_count  = 15}, -- For ultisnips users.
    }, {
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
    }),
    formatting = {
      format = lspkind.cmp_format {
        with_text = true,
        maxwidth = 30,
        menu = {
          buffer = '[Buf]',
          nvim_lsp = '[LSP]',
          nvim_lua = '[Lua]',
          path = '[Path]',
          ultisnips = '[Snip]',
        }
      }
      -- format = function(entry, vim_item)
      --   vim_item.menu = entry:get_completion_item().detail
      --   return vim_item
      -- end
      -- format = lspkind.cmp_format({with_text = false, maxwidth = 50})
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
    -- documentation = {
    --   border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    -- },
    experimental = {
      native_menu = false,
      ghost_text = true,
    }
  })

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- require('lspconfig')[%YOUR_LSP_SERVER%].setup {
  --   capabilities = capabilities
  -- }
