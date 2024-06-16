local mw_group = vim.api.nvim_create_augroup('mw_group', { clear = true })

-- set / unset cursorline in inactive window
vim.api.nvim_create_autocmd({ 'InsertLeave', 'WinEnter' }, {
  pattern = '*',
  command = 'set cursorline',
  group = mw_group
})
vim.api.nvim_create_autocmd({ 'InsertEnter', 'WinLeave' }, {
  pattern = '*',
  command = 'set nocursorline',
  group = mw_group
})

-- reload window when gaining focus - is this right?!
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter' }, {
  pattern = '*',
  command = 'silent! !',
  group = mw_group
})

-- auto resize on size change
vim.api.nvim_create_autocmd({ 'VimResized' }, {
  pattern = '*',
  command = 'wincmd =',
  group = mw_group
})

-- reopen file at same place
vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
  pattern = '*',
  callback = function()
    if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.api.nvim_command("normal! g'\"zz")
    end
  end,
  group = mw_group
})

-- tweak yank highlight timing
vim.api.nvim_create_autocmd({ 'TextYankPost' }, {
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'HighlightedyankRegion',
      timeout = 400,
    })
  end,
  group = mw_group
})
