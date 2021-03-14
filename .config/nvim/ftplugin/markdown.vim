function! s:InsertEnter() abort
  let line = getline('.')
  if &ft != 'markdown'
    return "\<cr>"
  endif

  "check for numbers
  let isNumbers = 0
  if line =~ '^\s\{-}\d\+\.'
    let isNumbers = 1
    let num = matchstr(line, '^\s\{-}\(\d\+\).', '\1')
    let nextNum = str2nr(num) + 1
    return "\<cr>" . nextNum . '. '
  endif

  "check for list markers
  let isList = 0
  let listMarker = '-'
  if line =~ '^\s\{-}-\|\*'
    let isList = 1
    if line =~ '^\s\{-}\*'
      let listMarker = '*'
    endif
  endif

  let hasCheckbox = 0
  if line =~ '\[.\]'
    let hasCheckbox = 1
  endif

  "check for colon
  let hasColon = 0
  if line =~ '.*:$'
    let hasColon = 1
  endif

  if hasColon != 1 && isList != 1
    return "\<cr>"
  endif

  let retVal = "\<cr>"
  if hasColon == 1
    let retVal = retVal . "\t"
  endif

  let retVal = retVal . listMarker . ' '

  if hasCheckbox == 1
    let retVal = retVal . '[ ] '
  endif

  call append(getline("."), retVal)
  return ""

  " return retVal
endfunction

function! NormalEnter(where) abort
  let l:what = s:InsertEnter()

  echom l:what
  if empty(l:what)
    execute "normal! A<cr>"
    return
  endif
  " execute "normal! A" . what
  call append(getline('.'), l:what)
  call feedkeys('A', 'n')
endfunction

function! ToggleCheckbox() abort
  let line = getline('.')
  if line =~ '\[.\]'
    let check = matchstr(line, '\[\(.\)\]', '\1')
    if check == ' '
      call setline(l, substitute(line, '\[.\]', '\[x\]', "g"))
    endif
  endif
endfunction

"todo: toggle checkbox being on the line?

" inoremap <silent> <cr> <c-r>=<sid>InsertEnter()<cr>
" nnoremap o :call NormalEnter('below')<cr>

nmap <cr> ge
