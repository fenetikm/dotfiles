return {
  'lukas-reineke/indent-blankline.nvim',
  event = 'VeryLazy',
  opts = {
    indent = {
      char = {'│', '┊'},
      highlight = {'IndentBlanklineIndent1', 'IndentBlanklineIndent1'},
    },
    whitespace = {
      remove_blankline_trail = true,
    },
    scope = { enabled = false },
    exclude = {
      filetypes = {
        'help',
        'alpha',
        'dashboard',
        'neo-tree',
        'Trouble',
        'trouble',
        'lazy',
        'mason',
        'notify',
        'toggleterm',
        'lazyterm',
        'NvimTree',
      },
    },
  },
  main = 'ibl',
}
