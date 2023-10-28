local map = require('plugins.utils').map
local options = {silent = false, noremap = true}
map({'n'}, '<c-b>', ':TSHighlightCapturesUnderCursor<cr>', options)
