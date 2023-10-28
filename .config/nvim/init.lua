-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('general.disable_builtin')
require('keys.escape')
require('general.settings')

require("lazy").setup("plugins")

require('general.folding')
require('general.filetypes')
require('keys.mappings')

vim.cmd([[
  " set cursors depending on mode
  set t_SI=[6\ q
  set t_SR=[4\ q
  set t_SR=[2\ q
]])
