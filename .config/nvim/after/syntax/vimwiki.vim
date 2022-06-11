" Match things like <leader>
syntax match customStatement '<.[^>]*>'
highlight link customStatement Statement

" Match @answer
syntax match myAnswer '@\canswer'
highlight link myAnswer DiffText

" Match @important
syntax match myImportant '@\cimportant'
highlight link myImportant ErrorMsg

" Match @todo
syntax match myTodo '@\ctodo'
highlight link myTodo Todo

" Match @done
syntax match myDone '@\cdone'
highlight link myDone DiffText

" Match things like @michael, but not bob@hotmail.com
syntax match atWord '\([^a-z]\|^\)@\(todo\|important\|answer\|done\)\@!\w\+'
highlight link atWord Special

" Modify the checkboxes to stand out more
syntax region myCheckMark matchgroup=myCheckBox start='[-*]\s\[' end='\][^(]' skip='[ \.oOxX]{1}' oneline
highlight link myCheckBox Delimiter
highlight link myCheckMark Special
