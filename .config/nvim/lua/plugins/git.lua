return {
  {
    'tpope/vim-fugitive',
    cmd = {
      'Gvdiffsplit',
      'Gdiffsplit'
    },
    keys = {
      {'<leader>gr', '<cmd>Gread<cr>', noremap = true},
      {'<leader>gb', '<cmd>Git blame<cr>', noremap = true},
    }
  },
  {
    'sindrets/diffview.nvim',
    keys = {
      {'<leader>gd', '<cmd>DiffviewOpen dev<cr>', noremap = true},
    },
    opts = {
      default_args = {
        DiffviewOpen = { "--imply-local"}
      },
      use_icons = true, --one day can we have folders without file icons?
    }
  },
  {
    'NeogitOrg/neogit',
    keys = {
      {'<leader>gs', '<cmd>Neogit<cr>', silent = true, noremap = true},
      {'<leader>gc', '<cmd>Neogit commit<cr>', silent = true, noremap = true},
    },
    cmd = {
      'Neogit',
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
    },
    config = true,
  }
}
