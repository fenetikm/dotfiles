local map = require('config.utils').map

vim.o.completeopt = "menuone,noselect"

require('compe').setup {
  enabled = true,
  debug = false,
  min_length = 2,
  preselect = 'enable',
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  max_abbr_width = 40,
  max_kind_width = 100,
  max_menu_width = 40,
  documentation = true,
  autocomplete = true,
  source = {
    path = true,
    buffer = true,
    ultisnips = true,
    nvim_lsp = true,
    nvim_lua = true,
    -- treesitter = true,
    -- omni = true
    -- treesitter
    -- omni
    -- spell
    -- tags
    -- calc
    -- vsnip
  }
}

local opts = {noremap = true, silent = true, expr = true}
map('i', '<c-space>', [[compe#complete()]], opts)
map('i', '<cr>', [[compe#confirm(lexima#expand('<lt>cr>', 'i'))]], opts)
