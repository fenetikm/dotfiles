-- use indentation scripts per filetype
vim.api.nvim_command('filetype plugin indent on')

-- Drupal / PHP
vim.filetype.add({
  pattern = {
    ['*.module'] = 'php',
    ['*.theme'] = 'php',
    ['*.install'] = 'php',
    ['*.test'] = 'php',
    ['*.inc'] = 'php',
    ['*.profile'] = 'php',
    ['*.view'] = 'php',
  },
})

vim.filetype.add({
  pattern = {
    ['.env'] = 'conf',
    ['*.sh'] = 'zsh',
  }
})
