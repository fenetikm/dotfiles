nnoremap <leader>ga :Git add %:p<cr><cr>
nnoremap <silent> <leader>gs :Git<cr>
nnoremap <leader>gd :Gvdiffsplit!<cr>
nnoremap <leader>gr :Gread<cr>
nnoremap <leader>gl :Glog<cr>
nnoremap <leader>gh :0Glog<cr>
nnoremap <leader>gp :Gpush<cr>
nnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gm :Gmerge<cr>

function! QuickCommitMessage()
  if &ft == 'todo'
    execute 'Gcommit -m "Update todo"'
  elseif
    execute 'Gcommit -m "Quick update"'
  endif
endfunction

" Stage and commit the current file.
nnoremap <leader>gg :Gwrite<cr>:call QuickCommitMessage()<cr>

"merging mappings
nnoremap <c-left> :diffget //2<cr>
nnoremap <c-right> :diffget //3<cr>
nnoremap <c-up> [c
nnoremap <c-down> ]c
