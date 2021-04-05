local gitsigns = require('gitsigns')

gitsigns.setup {
  signs = {
    add = {hl = 'GitSignsAdd', text = '▎'},
    change = {hl = 'GitSignsChange', text = '▎'},
    delete = {hl = 'GitSignsDelete', text = '◢'},
    topdelete = {hl = 'GitSignsDelete', text = '◥'},
    changedelete = {hl = 'GitSignsChangeDelete', text = '▌'},
  },
  keymaps = {
    buffer = true,
    ['n ]c'] = '<cmd>lua require"gitsigns".next_hunk({wrap = true})<CR>',
    ['n [c'] = '<cmd>lua require"gitsigns".prev_hunk({wrap = true})<CR>',
  },
  max_file_length = 100000
}
