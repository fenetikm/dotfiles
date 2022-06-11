" Match things like <leader>
syntax match myTag '<.[^>]*>' containedin=mkdNonListItemBlock,mkdListItemLine
highlight link myTag Statement

" Match @answer
syntax match myAnswer '@\canswer' containedin=mkdNonListItemBlock,mkdListItemLine
highlight link myAnswer Special

" Match @important
syntax match myImportant '@\cimportant' containedin=mkdNonListItemBlock,mkdListItemLine
highlight link myImportant ErrorMsg

" Match @todo
syntax match myTodo '@\ctodo' containedin=mkdNonListItemBlock,mkdListItemLine
highlight link myTodo Todo

" Match @done
syntax match myDone '@\cdone' containedin=mkdNonListItemBlock,mkdListItemLine
highlight link myDone Done

" Match things like @michael, but not bob@hotmail.com
syntax match atWord '\([^a-z]\|^\)@\(todo\|important\|answer\|done\)\@!\w\+' containedin=mkdNonListItemBlock,mkdListItemLine
highlight link atWord Keyword

" only one character is a checkbox
" when there is more than one then it is a link
" Modify the checkboxes to stand out more
syntax region myCheckMark matchgroup=myCheckBox start='[-*]\s\[' end='\][^(]' skip='[ \.oOxX]{1}' oneline
highlight link myCheckBox Delimiter
highlight link myCheckMark Special
