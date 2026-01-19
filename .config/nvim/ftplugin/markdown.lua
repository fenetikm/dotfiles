-- strikethrough, bold and italic shortcuts
vim.keymap.set('v', '<localleader>s', 'c~~<c-r>"~~')
vim.keymap.set('v', '<localleader>b', 'c**<c-r>"**')
vim.keymap.set('v', '<localleader>i', 'c_<c-r>"_')
vim.keymap.set('n', '<localleader>s', 'viwc~~<c-r>"~~<esc>')
vim.keymap.set('n', '<localleader>b', 'viwc**<c-r>"**<esc>')
vim.keymap.set('n', '<localleader>i', 'viwc_<c-r>"_<esc>')

-- urls and titles
vim.keymap.set('v', '<localleader>t', 'c[<c-r>"]()<left>')
vim.keymap.set('v', '<localleader>u', 'c[](<c-r>")<c-o>F]')
vim.keymap.set('n', '<localleader>t', 'viwc[<c-r>"]()<left>')
vim.keymap.set('n', '<localleader>u', 'viwc[](<c-r>")<c-o>F]')

-- backticks
vim.keymap.set('v', '<localleader>`', 'c`<c-r>"`')
vim.keymap.set('n', '<localleader>`', 'viwc`<c-r>"`<esc>')

-- double quotes
vim.keymap.set('v', '<localleader>"', 'c"<c-r>""')
vim.keymap.set('n', '<localleader>"', 'viwc"<c-r>""<esc>')

-- kbd tag
vim.keymap.set('v', '<localleader>k', 'c<kbd><c-r>"<kbd>')
