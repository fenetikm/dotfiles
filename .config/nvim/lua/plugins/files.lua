return {
  {
    'pbrisbin/vim-mkdir', --save file in directory, don't fail
    event = 'VeryLazy',
  },
  -- {
  --   'kyazdani42/nvim-tree.lua',
  --   keys = {
  --     {'<c-e>', '<cmd>NvimTreeFindFileToggle<cr>', silent = true, noremap = true}
  --   },
  --   dependencies = {'kyazdani42/nvim-web-devicons'},
  --   opts = {
  --     view = {
  --       width = 35,
  --     },
  --     renderer = {
  --       icons = {
  --         webdev_colors = false,
  --         show = {
  --           file = false,
  --           folder = true,
  --           folder_arrow = false,
  --           git = true,
  --         },
  --       },
  --       highlight_opened_files = "name",
  --       indent_markers = {
  --         enable = false,
  --       },
  --     },
  --   },
  -- },
  {
    'fenetikm/oil.nvim',
    event = 'VeryLazy',
    keys = {
      {'<c-e>', '<cmd>Oil<cr>', silent = true, noremap = true},
      -- {'<c-s-e>', function() require('oil').open_float() end, silent = true, noremap = true},
    },
    opts = {
      default_file_explorer = true,
      columns = {
        {'icon', directory_only = true, file_icon = '┊'},
      },
      view_options = {
        show_hidden = true,
      },
      use_default_keymaps = false,
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        -- ["<C-s>"] = "actions.select_vsplit",
        -- ["<C-h>"] = "actions.select_split",
        -- ["<C-t>"] = "actions.select_tab",
        -- ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        -- ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        -- ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
      },
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  }
}
