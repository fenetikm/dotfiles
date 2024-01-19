vim.cmd([[
  " control-enter
  " set <F13>=[25~
  " map <F13> <c-cr>
  " map! <F13> <c-cr>

  " control-slash
  " set <F17>=[31~ replaced with the real thing!

  " control-period
  " set <F19>=[33~
  " map <F19> <c-.>
  " map! <F19> <c-.>

  " control-[ is now f20 via karabiner elements
  nnoremap <F18> <c-t>
  "apparently this is f18 in tmux?
  nnoremap <S-F6> <c-t>

  "without this the world dies when <c-,> is hit?
  inoremap <F18> <nop>

]])
