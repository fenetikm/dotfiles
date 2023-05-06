local g = vim.g
local map = require('plugins.utils').map
local tree = require('nvim-tree')

tree.setup {
  view = {
    width = 35
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
}

local options = {silent = true, noremap = true}
map({'n'}, '<c-e>', ':NvimTreeFindFileToggle<cr>', options)
