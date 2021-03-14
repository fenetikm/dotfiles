" Thanks gary. Renames current file.
function! custom#renamefile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction

function! custom#trimwhitespace()
  %s/\s\+$//e
endfunction

"Again thanks gary. Remove stupid fancy characters.
function! custom#removefancycharacters()
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

function! custom#deleteinactivebufs()
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
function! custom#startprofile()
  profile start ~/.config/nvim/start_profile.log
  profile func *
  profile file *
endfunction

function! custom#stopprofile()
  profile stop
endfunction

function! custom#toggleverbose()
    if !&verbose
        set verbosefile=~/.config/nvim/verbose.log
        set verbose=15
    else
        set verbose=0
        set verbosefile=
    endif
endfunction

function! custom#togglesyntax()
   if exists("g:syntax_on") | syntax off | else | syntax enable | endif
endfunction

" Thanks to wincent for this.
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
