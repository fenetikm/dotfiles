require('general.disable_builtin')

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
vim.g.localvimrc_ask = 0
vim.g.localvimrc_sandbox = 0

require('keys.escape')
require('general.settings')

-- local rocks_config = {
--   rocks_path = vim.env.HOME .. "/.local/share/nvim/rocks",
-- }
--
-- vim.g.rocks_nvim = rocks_config
--
-- local luarocks_path = {
--   vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?.lua"),
--   vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?", "init.lua"),
-- }
-- package.path = package.path .. ";" .. table.concat(luarocks_path, ";")
--
-- local luarocks_cpath = {
--   vim.fs.joinpath(rocks_config.rocks_path, "lib", "lua", "5.1", "?.so"),
--   vim.fs.joinpath(rocks_config.rocks_path, "lib64", "lua", "5.1", "?.so"),
--   -- Remove the dylib and dll paths if you do not need macos or windows support
--   vim.fs.joinpath(rocks_config.rocks_path, "lib", "lua", "5.1", "?.dylib"),
--   vim.fs.joinpath(rocks_config.rocks_path, "lib64", "lua", "5.1", "?.dylib"),
--   vim.fs.joinpath(rocks_config.rocks_path, "lib", "lua", "5.1", "?.dll"),
--   vim.fs.joinpath(rocks_config.rocks_path, "lib64", "lua", "5.1", "?.dll"),
-- }
-- package.cpath = package.cpath .. ";" .. table.concat(luarocks_cpath, ";")
--
-- vim.opt.runtimepath:append(vim.fs.joinpath(rocks_config.rocks_path, "lib", "luarocks", "rocks-5.1", "rocks.nvim", "*"))

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

require('general.folding')
require('general.filetypes')
require('general.auto_commands')
require('general.commands')
require('general.highlights')

require('keys.mappings')
require('keys.toggle')
require('keys.searchreplace')

vim.api.nvim_set_hl(0, "TextInfo", { fg = "#e0def4" })
vim.api.nvim_set_hl(0, "TextMuted", { fg = "#6e6a86" })
