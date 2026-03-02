return {
  {
    'tpope/vim-fugitive',
    cmd = {
      'Gvdiffsplit',
      'Gdiffsplit'
    },
    keys = {
      { '<leader>gr', '<cmd>Gread<cr>',     noremap = true },
      { '<leader>gb', '<cmd>Git blame<cr>', noremap = true },
    }
  },
  {
    'dlyongemallo/diffview.nvim',
    cmd = {
      'DiffviewOpen',
      'DiffviewFileHistory',
    },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<cr>',        noremap = true },
      { '<leader>gf', '<cmd>DiffviewOpen -uno<cr>',   noremap = true }, -- `-uno`, ignore files not addedd
      { '<leader>gc', '<cmd>DiffviewClose<cr>',       noremap = true },
      { '<leader>gh', '<cmd>DiffviewFileHistory<cr>', noremap = true },
    },
    opts = {
      use_icons = false, --one day can we have folders without file icons?
      diff_binaries = false,
      watch_index = true,
      enhanced_diff_hl = true, -- See |diffview-config-enhanced_diff_hl|
      default_args = {
        DiffviewOpen = { "--imply-local" }
      },
      view = {
        default = {
          layout = "diff2_horizontal",
          disable_diagnostics = true,
          winbar_info = true,
        },
        merge_tool = {
          layout = "diff3_horizontal", -- diff3_horizontal | diff3_vertical | diff3_mixed | diff4_mixed
          disable_diagnostics = true,
          winbar_info = true,
        },
        file_history = {
          layout = "diff2_horizontal",
          disable_diagnostics = true,
          winbar_info = true,
        },
      },
    },
  },
  {
    'NeogitOrg/neogit',
    keys = {
      { '<leader>gs', '<cmd>Neogit<cr>', silent = true, noremap = true },
    },
    cmd = {
      'Neogit',
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
    },
    config = function()
      local neogit = require("neogit")
      neogit.setup {
        integrations = {
          diffview = true,
        },
      }
    end,
  }
}
