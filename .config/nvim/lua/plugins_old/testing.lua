local map = require('plugins.utils').map
local options = {silent = true, noremap = true}
map({'n'}, '<leader>oo', ':TestLast<cr>', options)
map({'n'}, '<leader>on', ':TestNearest<cr>', options)
map({'n'}, '<leader>of', ':TestFile<cr>', options)
