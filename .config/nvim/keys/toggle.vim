"toggle guides
" nnoremap <silent> <leader>ti :IndentGuidesToggle<cr>
nnoremap <silent> <leader>ti :IndentBlanklineToggle!<cr>

"toggle search highlight
nnoremap <silent> <esc> :nohlsearch<cr>

"toggle line numbers
nnoremap <silent> <leader>tn :setlocal nonumber! norelativenumber!<CR>

"toggle wrapping
nnoremap <silent> <leader>tw :setlocal wrap! breakindent!<CR>

"toggle tagbar
nnoremap <silent> <leader>tt :TagbarToggle<cr>

"toggle list
nnoremap <silent> <leader>tl :LToggle<cr>

"toggle quickfix
nnoremap <silent> <leader>tq :QToggle<cr>

"toggle syntax
nnoremap <leader>ts :ToggleSyntax<cr>

"toggle spelling
nnoremap <silent> <leader>tz :setlocal spell! spelllang=en_au<cr>

"toggle cursor column
nnoremap <silent> <leader>to :setlocal nocuc!<cr>

"toggle colorizer
nnoremap <leader>tc :call custom#togglecolorizer()<cr>

"toggle color column
nnoremap <silent> <leader>tb :call custom#SetColorColumn()<cr>

" toggle cursor line
nnoremap <silent> <leader>t- :setlocal cursorline!<cr>
