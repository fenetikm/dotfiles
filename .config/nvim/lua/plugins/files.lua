return {
  {
    'pbrisbin/vim-mkdir', --save file in directory, don't fail
    event = 'VeryLazy',
  },
  {
    'fenetikm/oil.nvim', -- fork that hides files icons but keeps folder icons
    cmd = "Oil",
    keys = {
      { '<c-e>', '<cmd>Oil<cr>', silent = true, noremap = true },
    },
    opts = {
      default_file_explorer = true,
      columns = {
        { 'icon', directory_only = true, file_icon = '┊' },
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
    dependencies = { "nvim-tree/nvim-web-devicons" },
  }
}
