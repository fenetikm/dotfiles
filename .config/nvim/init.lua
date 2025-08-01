require('disable_builtin')

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

-- haven't yet worked out where to put these but here works
-- todo: replace with exrc
vim.g.localvimrc_ask = 0
vim.g.localvimrc_sandbox = 0

require('keys.escape')
require('settings')

require('lazy').setup("plugins",
  {
    change_detection = {
      enabled = false,
      notify = false,
    },
    rocks = {
      hererocks = true
    },
    performance = {
      rtp = {
        disabled_plugins = {
          'getscript',
          'getscriptPlugin',
          'gzip',
          'matchit',
          'matchparen',
          -- 'netrwPlugin',
          'tar',
          'tarPlugin',
          'tutor',
          'vimball',
          'vimballPlugin',
          'zip',
          'zipPlugin',
        }
      }
    }
  }
)

require('general')

-- replace with just "keys" via init.lua
require('keys.mappings')
require('keys.toggle')
require('keys.searchreplace')

-- todo: what are these, push to falcon?
vim.api.nvim_set_hl(0, "TextInfo", { fg = "#e0def4" })
vim.api.nvim_set_hl(0, "TextMuted", { fg = "#6e6a86" })
