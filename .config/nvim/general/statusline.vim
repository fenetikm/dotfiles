echom 'statusline'
"@todo override filename formatting to italic.
"@todo disable stuff on the right for NERDTree
"make modified a different colour

      " \ 'colorscheme': 'gruvbox',

set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'falcon',
      \ 'active': {
      \     'left': [ [ 'mode', 'paste' ],
      \               [ 'filename' ],
      \               [ 'method' ] ],
      \     'right': [ ['linter_status', 'lineinfo'],
      \                [ 'linter_warnings', 'linter_errors', 'linter_ok', 'fileformat', 'fileencoding', 'filetype' ] ]
      \   },
      \   'inactive': {
      \     'left': [ [ 'filename' ] ],
      \     'right': [ [ 'lineinfo' ],
      \                [ 'filetype' ] ]
      \   },
      \ 'component_function': {
      \   'lineinfo': 'LightlineLineinfo',
      \   'filename': 'LightlineFilename',
      \   'fugitive': 'LightlineFugitive',
      \   'fileformat': 'LightlineFileformat',
      \   'filetype': 'LightlineFiletype',
      \   'fileencoding': 'LightlineFileencoding',
      \   'mode': 'LightlineMode',
      \   'method': 'LightlineNearestMethod',
      \ },
      \ 'component_expand': {
      \    'linter_warnings': 'LightlineLinterWarnings',
      \    'linter_errors': 'LightlineLinterErrors',
      \    'linter_ok': 'LightlineLinterOk',
      \ },
      \ 'component_type': {
      \    'linter_warnings': 'warning',
      \    'linter_errors': 'error',
      \    'linter_ok': 'ok',
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '|' }
      \}
" some alternate sep glyph ideas
"  'left': '', 'right': ''
"  'left': '', 'right': ''
"  'left': '', 'right': ''
"  'left': '', 'right': ''

let g:lightline.mode_map = {
      \ 'n' : 'N',
      \ 'i' : 'I',
      \ 'R' : 'R',
      \ 'v' : 'V',
      \ 'V' : 'V-L',
      \ "\<C-v>": 'V-B',
      \ 'c' : 'C',
      \ 's' : 'S',
      \ 'S' : 'S-L',
      \ "\<C-s>": 'S-B',
      \ 't': 'T',
      \ }

function! LightlineLineinfo()
  let fname = expand('%:t')
  return fname =~ 'NERD_tree' ? '' : printf('%d:%-2d', line('.'), col('.'))
endfunction

function! LightlineLinterWarnings() abort
  return ''

  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ◆', all_non_errors)
endfunction

function! LightlineLinterErrors() abort
  return ''

  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ✗', all_errors)
endfunction

function! LightlineLinterOk() abort
  return ''

  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  let l:match_type=0
  for pkey in keys(g:ale_linters)
    if pkey == &ft
      let l:match_type = 1
    endif
  endfor
  if l:match_type == 0
    return ''
  endif
  return l:counts.total == 0 ? '✔' : ''
endfunction

" update status after ale finishes linting
autocmd User ALELint call lightline#update()

function! LightlineMode()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == 'ControlP' ? 'CtrlP' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! LightlineFugitive()
  try
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
      let mark = ' '  " edit here for cool mark
      let branch = fugitive#head()
      return branch !=# '' ? mark.branch : ''
    endif
  catch
  endtry
  return ''
endfunction

function! LightlineReadonly()
  return &ft !~? 'help' && &readonly ? '' : ''
endfunction

function! LightlineModified()
  return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightlineFilename()
  let fname = expand('%:t')
  return fname == 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? g:lightline.ctrlp_item :
        \ fname == '__Tagbar__' ? g:lightline.fname :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ &ft == 'unite' ? unite#get_status_string() :
        \ ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
        \ ('' != fname ? fname : '[No Name]') .
        \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction

function! LightlineFileformat()
  "return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  "return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightlineNearestMethod()
  let vmethod = cfi#format("%s", "")
  if vmethod != ''
    return '->' . vmethod
  endif
  return ''
endfunction
