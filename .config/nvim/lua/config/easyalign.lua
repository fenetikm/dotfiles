local map = require('config.utils').map
local g = vim.g
g.easy_align_bypass_fold = 1
g.easy_align_ignore_groups = {}

local options = {silent = true, noremap = false}
map({'x', 'n'}, 'ga', '<Plug>(EasyAlign)', options)
