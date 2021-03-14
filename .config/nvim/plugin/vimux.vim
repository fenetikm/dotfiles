"percentage size
let g:VimuxHeight="32"

"set pane to open on right
let g:VimuxOrientation = 'h'

"run last command
nnoremap <leader>vl :call VimuxSendKeys("!! C-m C-m")<cr>
