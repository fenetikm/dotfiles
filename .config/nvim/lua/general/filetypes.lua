vim.cmd([[
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
]])
