inoremap <c-.> <space>=><space>

"splitjoin settings
let b:splitjoin_trailing_comma=1
let b:splitjoin_split_callbacks=['sj#php#SplitArray']

"php namespace
function! IPhpInsertUse()
    call PhpInsertUse()
    call feedkeys('a',  'n')
endfunction

function! IPhpExpandClass()
    call PhpExpandClass()
    call feedkeys('a',  'n')
endfunction

autocmd FileType php noremap <localleader>pu :call PhpInsertUse()<cr>
autocmd FileType php noremap <localleader>pe :call PhpExpandClass()<cr>
autocmd FileType php noremap <localleader>pa :PHPExpandFQCNAbsolute<cr>

"sort the use statements after inserting
let g:php_namespace_sort_after_insert=1

"phpunitqf
let g:phpunit_cmd='/usr/local/bin/phpunit'

"disable php manual online shortcut
let g:php_manual_online_search_shortcut = ''

" enable echodoc to show function signatures
" autocmd FileType php :EchoDocEnable

"php syntax
"disable html inside of php syntax highlighting
let g:php_html_load=0

" For UltiSnips
" 0 is braces on the same line
" 1 is braces below
let g:php_brace_style=0

" For UltiSnips
" Number of spaces to indent in PHP
let g:php_indent=2
