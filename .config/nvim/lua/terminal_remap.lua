-- c-[ mapped to f18 in karabiner
vim.keymap.set('n', '<F18>', '<c-t>', { noremap = true })
vim.cmd([[

  nnoremap <F18> <c-t>
  "apparently this is f18 in tmux?
  nnoremap <S-F6> <c-t>

  "without this the world dies when <c-,> is hit?
  " inoremap <F18> <nop>
]])
