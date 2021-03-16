local map = require('config.utils').map
local g = vim.g
g.matchup_matchparen_deferred = 1
g.matchup_matchparen_deferred_show_delay = 100
g.matchup_matchparen_hi_surround_always = 1
g.matchup_override_vimtex = 1
g.matchup_delim_start_plaintext = 0
g.matchup_transmute_enabled = 0

local options = {silent = true, noremap = false}
map({'x', 'n'}, 's', '<Nop>', options)
