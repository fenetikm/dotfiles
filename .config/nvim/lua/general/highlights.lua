-- highlight trailing whitespace as if it was an error
vim.api.nvim_command('match ErrorMsg \'\\s\\+$\'')
