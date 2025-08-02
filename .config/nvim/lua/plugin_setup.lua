require('lazy').setup(
  {
    import = 'plugins',
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
