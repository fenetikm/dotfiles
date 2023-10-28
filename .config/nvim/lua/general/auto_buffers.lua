vim.cmd([[
  " Toggle relative and normal numbers depending on active or not
  function! SetNumbers(s)
    let fname = expand('%:t')
    if fname != '' && &ft != 'help' && &ft != 'nerdtree' && &ft != 'fzf' && &ft != 'NvimTree' && &ft != 'qf'
      if a:s == 'on'
        setlocal relativenumber
      else
        setlocal norelativenumber
      endif
    else
      setlocal norelativenumber
    endif
  endfunction

  " turn off relativenumber in non active window
  augroup BgHighlight
      autocmd!
      autocmd WinEnter,FocusGained * call SetNumbers('on')
      autocmd WinLeave,FocusLost * call SetNumbers('off')
  augroup END

  " Make sure Vim returns to the same line when you reopen a file.
  autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \     execute 'normal! g`"zvzz' |
      \ endif

  " Remember info about open buffers on close
  set viminfo^=%

  "turn off the cursorline when not in a window
  autocmd InsertLeave,WinEnter * set cursorline
  autocmd InsertEnter,WinLeave * set nocursorline

  " Reload when gaining focus
  autocmd FocusGained,BufEnter * :silent! !

  " auto resize on size change
  autocmd VimResized * wincmd =
]])
