" Check if NERDTree is open or active
function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

"map ctrl-e to show nerdtree
function! OpenNERD()
  let fname = expand('%:t')
  if bufname('') == 'Startify'
    execute 'NERDTreeToggle'
  elseif fname == '' || bufname('') == 'NERD_tree_1'
    execute 'NERDTreeToggle'
  else
    execute 'NERDTreeFind'
  endif
endfunction
noremap <silent> <c-e> :call OpenNERD()<cr>

"width
let g:NERDTreeWinSize=40

" Disable display of '?' text and 'Bookmarks' label.
let g:NERDTreeMinimalUI=1

" Show hidden files by default
let g:NERDTreeShowHidden=1

" turn off cursorline highlighting
let NERDTreeHighlightCursorline = 0

" nerdtree highlighting icon stuff.
let g:NERDTreeLimitedSyntax = 1
" let g:NERDTreeSyntaxDisableDefaultExtensions = 1
" let g:NERDTreeDisableExactMatchHighlight = 1
" let g:NERDTreeDisablePatternMatchHighlight = 1
" let g:NERDTreeSyntaxEnabledExtensions = ['yaml', 'php', 'js', 'css']

let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "~",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✓",
    \ 'Ignored'   : 'i',
    \ "Unknown"   : "?"
    \ }

let NERDTreeIgnore=['\.git']

" turn off aggressive updating of git status
let g:NERDTreeUpdateOnCursorHold = 0
let g:NERDTreeUpdateOnWrite      = 0
