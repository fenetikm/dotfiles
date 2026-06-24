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
    'folke/trouble.nvim',
    cmd = "Trouble",
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',      silent = true, noremap = true, desc = "Diagnostics (Trouble)" },
      { '<leader>xq', '<cmd>Trouble qflist toggle<cr>',                        silent = true, noremap = true, desc = "Quickfix (Trouble)" },
      { '<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>',           silent = true, noremap = true, desc = "Symbols (Trouble)" },
      { ']x',         '<cmd>lua require("trouble").next({ focus = true})<cr>', silent = true, noremap = true, desc = "Next item (Trouble)" },
      { '[x',         '<cmd>lua require("trouble").prev({ focus = true})<cr>', silent = true, noremap = true, desc = "Prev item (Trouble)" },
    },
    opts = {
      signs = {
        error = '!',
        warning = '?',
        information = 'i',
        hint = 'h'
      },
    }
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    config = true,
  },
  {
    "lukas-reineke/lsp-format.nvim",
    event = 'VeryLazy',
  }
}
