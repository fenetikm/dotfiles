local g = vim.g
local map = require('config.utils').map
local tree = require('nvim-tree')

tree.setup {
  view = {
    width = 35
  }
}

g.nvim_tree_width = 35
g.nvim_tree_show_icons = {git = 1, folders = 1, files = 0}
g.nvim_tree_indent_markers = 1
g.nvim_tree_highlight_opened_files = 2
g.nvim_tree_add_trailing = 1

local options = {silent = true, noremap = true}
map({'n'}, '<c-e>', ':NvimTreeFindFileToggle<cr>', options)
