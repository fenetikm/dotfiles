return {
  {
    'pbrisbin/vim-mkdir', --save file in directory, don't fail
    event = 'VeryLazy',
  },
  {
    'kyazdani42/nvim-tree.lua',
    keys = {
      {'<c-e>', '<cmd>NvimTreeFindFileToggle<cr>', silent = true, noremap = true}
    },
    dependencies = {'kyazdani42/nvim-web-devicons'},
    opts = {
      view = {
        width = 35,
      },
      renderer = {
        icons = {
          webdev_colors = false,
          show = {
            file = false,
            folder = true,
            folder_arrow = false,
            git = true,
          },
        },
        highlight_opened_files = "name",
        indent_markers = {
          enable = false,
        },
      },
    },
  },
}
