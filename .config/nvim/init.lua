-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.localvimrc_ask = 0
vim.g.localvimrc_sandbox = 0

require('general.disable_builtin')
require('keys.escape')
require('general.settings')

require('lazy').setup("plugins")

require('general.folding')
require('general.filetypes')
require('general.auto_buffers')
require('general.commands')

require('keys.mappings')
require('keys.toggle')
require('keys.searchreplace')

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'HighlightedyankRegion',
            timeout = 400,
        })
    end,
})

vim.cmd([[
  " set cursors depending on mode
  set t_SI=[6\ q
  set t_SR=[4\ q
  set t_SR=[2\ q
]])
