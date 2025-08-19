return {
  {
    'nvimtools/none-ls.nvim',
    event = 'VeryLazy',
    config = function()
      local null_ls = require('null-ls')
      null_ls.setup({
        sources = {
          null_ls.builtins.diagnostics.vale.with({
            filetypes = { 'markdown', 'txt' },
          })
        },
        on_attach = function(client, bufnr)
          vim.diagnostic.config({
            virtual_text = false,
            signs = false,
            underline = false,
          })
        end
      })
    end,
    opts = {},
  },
  {
    'nvim-lua/lsp-status.nvim', -- for status counts
    event = 'VeryLazy',
  },
  {
    'ray-x/lsp_signature.nvim',
    event = 'InsertEnter',
    opts = {
      -- floating_window = false,
    },
  },
  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
  },
  {
    'folke/trouble.nvim',
    event = 'VeryLazy',
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', silent = true, noremap = true, desc = "Diagnostics (Trouble)" },
    },
    opts = {
      signs = {
        error = '',
        warning = '▲',
        information = '',
        hint = '⚑'
      },
    }
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    config = true,
  }
}
