-- quite a few things from https://github.com/wincent/wincent/blob/main/aspects/nvim/files/.config/nvim/after/plugin/nvim-cmp.lua

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
      -- 'hrsh7th/cmp-nvim-lsp-signature-help', -- tends to give two windows then
    },
    config = function ()
      -- local lspkind = require('lspkind')
      -- lspkind.init()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

      -- from https://github.com/wincent/wincent/blob/main/aspects/nvim/files/.config/nvim/after/plugin/nvim-cmp.lua - thanks!
      local confirm = function(entry)
        local behavior = cmp.ConfirmBehavior.Replace
        if entry then
          local completion_item = entry.completion_item
          local newText = ''
          if completion_item.textEdit then
            newText = completion_item.textEdit.newText
          elseif type(completion_item.insertText) == 'string' and completion_item.insertText ~= '' then
            newText = completion_item.insertText
          else
            newText = completion_item.word or completion_item.label or ''
          end

          -- How many characters will be different after the cursor position if we
          -- replace?
          local diff_after = math.max(0, entry.replace_range['end'].character + 1) - entry.context.cursor.col

          -- Does the text that will be replaced after the cursor match the suffix
          -- of the `newText` to be inserted? If not, we should `Insert` instead.
          if entry.context.cursor_after_line:sub(1, diff_after) ~= newText:sub(-diff_after) then
            behavior = cmp.ConfirmBehavior.Insert
          end
        end
        cmp.confirm({ select = true, behavior = behavior })
      end

      local select_next_item = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end

      local select_prev_item = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end

      cmp.setup {
        completion = {
          keyword_length = 2
        },

        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },

        mapping = cmp.mapping.preset.insert({
          ["<c-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior },
          ["<c-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior },
          ['<c-d>'] = cmp.mapping.scroll_docs(-4),
          ['<c-u>'] = cmp.mapping.scroll_docs(4),
          ['<c-space>'] = cmp.mapping.complete(),
          -- ['<c-l>'] = function(fallback)
          --     if cmp.visible() then
          --       -- close, show line matches
          --       cmp.mapping.close()
          --       fallback()
          --     else
          --       fallback()
          --     end
          --   end,
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
          end, {'i', 's'}),
          ['<c-k'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              fallback()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, {'i', 's'}),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lua', max_item_count = 15 },
          { name = 'nvim_lsp', max_item_count = 15},
          { name = 'luasnip', priority = 1, max_item_count = 7 },
          -- { name = 'nvim_lsp_signature_help'},
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
          --     max_size = 50, -- max filesize in KB
          --   },
          --   max_item_count = 5,
          -- }
        }),
        formatting = {
          format = function(entry, vim_item)
            vim_item.kind = string.format('%s', vim_item.kind)
            vim_item.menu = ({
              buffer = '[Buf]',
              nvim_lsp = '[LSP]',
              nvim_lua = '[Lua]',
              path = '[Path]',
              luasnip = '[Snip]',
            })[entry.source.name]
            return vim_item
          end
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
          -- ghost_text = {
          --   hl_group = 'CmpGhostText'
          -- }
        }
      }

      -- filetype specific setup
      cmp.setup.filetype({ 'markdown', 'help' }, {
        sources = {
          { name = 'luasnip'},
          { name = 'path'},
          { name = 'buffer'},
        },
        completion = {
          autocomplete = false
        }
      })
    end
  },
}
