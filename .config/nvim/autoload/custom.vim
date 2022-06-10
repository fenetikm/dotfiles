" Thanks gary. Renames current file.
function! custom#RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction

" Trim the white space from a file
function! custom#TrimWhiteSpace()
  %s/\s\+$//e
endfunction

" Insert text at the cursor
function! custom#InsertText(text)
  let cur_line_num = line('.')
  let cur_col_num = col('.')
  let orig_line = getline('.')
  let modified_line =
      \ strpart(orig_line, 0, cur_col_num - 1)
      \ . a:text
      \ . strpart(orig_line, cur_col_num - 1)
  " Replace the current line with the modified line.
  call setline(cur_line_num, modified_line)
  " Place cursor on the last character of the inserted text.
  call cursor(cur_line_num, cur_col_num + strlen(a:text))
endfunction

" Get the current visual selection
function! custom#GetVisualSelection()
  let [line_start, column_start] = getpos("'<")[1:2]
  let [line_end, column_end] = getpos("'>")[1:2]
  let lines = getline(line_start, line_end)
  if len(lines) == 0
      return ''
  endif
  let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][column_start - 1:]
  return join(lines, "\n")
endfunction

"Again thanks gary. Remove stupid fancy characters.
function! custom#RemoveFancyCharacters()
  let typo = {}
  let typo["“"] = '"'
  let typo["”"] = '"'
  let typo["‘"] = "'"
  let typo["’"] = "'"
  let typo["–"] = '--'
  let typo["—"] = '---'
  let typo["…"] = '...'
  :exe ":%s/".join(keys(typo), '\|').'/\=typo[submatch(0)]/ge'
endfunction

" Delete inactive (not visible) buffers
function! custom#DeleteInactiveBufs()
  "From tabpagebuflist() help, get a list of all buffers in all tabs
  let tablist = []
  for i in range(tabpagenr('$'))
    call extend(tablist, tabpagebuflist(i + 1))
  endfor

  "Below originally inspired by Hara Krishna Dara and Keith Roberts
  "http://tech.groups.yahoo.com/group/vim/message/56425
  let nWipeouts = 0
  for i in range(1, bufnr('$'))
    if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
      "bufno exists AND isn't modified AND isn't in the list of buffers open in windows and tabs
      silent exec 'bwipeout' i
      let nWipeouts = nWipeouts + 1
    endif
  endfor
  echomsg nWipeouts . ' buffer(s) wiped out'
endfunction

" Function to start profiling commmands
function! custom#StartProfile()
  profile start ~/.config/nvim/start_profile.log
  profile func *
  profile file *
endfunction

" Stop the profiling
function! custom#StopProfile()
  profile stop
endfunction

" Verbose logging of what is currently going on
function! custom#ToggleVerbose()
    if !&verbose
        set verbosefile=~/.config/nvim/verbose.log
        set verbose=15
    else
        set verbose=0
        set verbosefile=
    endif
endfunction

" Toggle syntax highlighting
function! custom#ToggleSyntax()
   if exists("g:syntax_on") | syntax off | else | syntax enable | endif
endfunction

" Thanks to wincent for this.
" This puts all your zsh directory hashes in $xxx var links
function! custom#variables() abort
  " Set up shortcut variables for "hash -d" directories.
  let l:dirs=system(
        \ 'zsh -c "' .
        \ 'source ~/.config/zsh/directory_hashes.zsh; ' .
        \ 'hash -d"'
        \ )
  let l:lines=split(l:dirs, '\n')
  for l:line in l:lines
    let l:pair=split(l:line, '=')
    if len(l:pair) == 2
      let l:var=l:pair[0]
      let l:dir=l:pair[1]

      " Make sure we don't clobber any pre-existing variables.
      if !exists('$' . l:var)
        execute 'let $' . l:var . '="' . l:dir . '"'
      endif
    endif
  endfor
endfunction

function! custom#ToggleColorizer()
  if !exists("g:cz_on")
    let g:cz_on=1
  endif
  if g:cz_on == 0
    ColorizerAttachToBuffer
    let g:cz_on = 1
  else
    ColorizerDetachFromBuffer
    let g:cz_on = 0
  endif
endfunction

function! custom#SetColorColumn()
  if !exists("g:cc_on")
    let g:cc_on=1
  endif
  if g:cc_on == 1
    setlocal cc=81
    let g:cc_on=0
  else
    setlocal cc=
    let g:cc_on=1
  endif
endfunction

" This gem will let one run a leader from a command e.g: NormLead ev
function! custom#ExecuteLeader(suffix)
  let l:leader = get(g:,"mapleader","\\")
  if l:leader == ' '
    let l:leader = '1' . l:leader
  endif
  execute "normal ".l:leader.a:suffix
endfunction

" Flip a window from horizontal to veritcal and vice versa
function! custom#ToggleWindowHorizontalVerticalSplit()
  if !exists('t:splitType')
    let t:splitType = 'vertical'
  endif

  if t:splitType == 'vertical' " is vertical switch to horizontal
    windo wincmd K
    let t:splitType = 'horizontal'

  else " is horizontal switch to vertical
    windo wincmd H
    let t:splitType = 'vertical'
  endif
endfunction
