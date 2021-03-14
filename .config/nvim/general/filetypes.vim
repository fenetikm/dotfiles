
" Drupal / PHP --------------------------------------------------- {{{

if has("autocmd")
    augroup module
        autocmd BufRead,BufNewFile *.module set filetype=php
        autocmd BufRead,BufNewFile *.theme set filetype=php
        autocmd BufRead,BufNewFile *.install set filetype=php
        autocmd BufRead,BufNewFile *.test set filetype=php
        autocmd BufRead,BufNewFile *.inc set filetype=php
        autocmd BufRead,BufNewFile *.profile set filetype=php
        autocmd BufRead,BufNewFile *.view set filetype=php
        autocmd BufRead,BufNewFile *.php set filetype=php
    augroup END
endif

" }}} End Drupal / PHP

"actionscript/flash files. RIP.
au BufNewFile,BufRead *.as set filetype=actionscript

"json
au FileType json setlocal shiftwidth=4 tabstop=4

"quickfix
au FileType qf setlocal nonumber colorcolumn=

"vimwiki
au FileType vimwiki setlocal tw=0

"markdown
au FileType markdown setlocal conceallevel=0

"fzf
au FileType fzf setlocal nonu nornu

au FileType help setlocal nonumber norelativenumber
