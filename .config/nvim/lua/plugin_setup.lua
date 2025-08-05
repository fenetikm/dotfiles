require('lazy').setup(
  "plugins",
  {
    root = vim.fn.stdpath("data") .. "/lazy",
    change_detection = {
      enabled = false,
      notify = false,
    },
    rocks = {
      hererocks = true,
    },
    performance = {
      rtp = {
        disabled_plugins = {
          'getscript',
          'getscriptPlugin',
          'gzip',
          'matchit',
          'matchparen',
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
