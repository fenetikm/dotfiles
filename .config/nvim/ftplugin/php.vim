inoremap <c-.> <space>=><space>

"splitjoin settings
let b:splitjoin_trailing_comma=1
let b:splitjoin_split_callbacks=['sj#php#SplitArray']

"common
" nmap <localleader>g :call phpactor#GotoDefinition()<cr>
" nmap <localleader>j :call phpactor#Navigate()<cr>
" nmap <localleader>m :call phpactor#ContextMenu()<cr>
" nmap <localleader>t :call phpactor#Transform()<cr>
nnoremap <localleader>f :r! echo %<cr>
