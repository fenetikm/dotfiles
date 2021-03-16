local map = require('config.utils').map
vim.g.loaded_compe_treesitter = true
vim.g.loaded_compe_snippets_nvim = true
vim.g.loaded_compe_spell = true
vim.g.loaded_compe_tags = true
vim.g.loaded_compe_ultisnips = true
vim.g.loaded_compe_vim_lsc = true
vim.g.loaded_compe_vim_lsp = true

require('compe').setup {
  enabled = true,
  debug = false,
  min_length = 1,
  preselect = 'always',
  autocomplete = true,
  source = {
    ultisnips = true,
    path = true,
    buffer = true,
    nvim_lsp = true,
    nvim_lua = true
    -- treesitter
    -- omni
    -- spell
    -- tags
    -- calc
    -- vsnip
  }
}

local opts = {noremap = true, silent = true, expr = true}
-- map('i', '<c-c>', [[compe#complete()]], opts)
-- map('i', '<cr>', [[compe#confirm('<cr>')]], opts)
-- map('i', '<c-e>', [[compe#close('<c-e>')]], opts)

--[[
" because of lexima
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm(lexima#expand('<LT>CR>', 'i'))
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
]]
