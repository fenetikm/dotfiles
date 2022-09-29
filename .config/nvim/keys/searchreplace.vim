" search / find
nnoremap <c-p> <cmd>lua require'telescope.builtin'.find_files(_G.falcon.get_full_theme({}))<cr>

" nnoremap <silent> <c-p> :Files<cr>
" nnoremap <silent> <leader>ff :AllFiles<cr>

"other stuff
" nnoremap <silent> <leader>fh :History<cr>
nnoremap <silent> <leader>fh <cmd>lua require'telescope.builtin'.oldfiles(_G.falcon.get_full_theme({}))<cr>
" nnoremap <silent> <leader>fc :Commands<cr>
nnoremap <silent> <leader>fc <cmd>lua require'telescope.builtin'.commands(_G.falcon.get_full_theme({}))<cr>
" nnoremap <silent> <leader>fm :Maps<cr>
nnoremap <silent> <leader>fm <cmd>lua require'telescope.builtin'.keymaps(_G.falcon.get_simple_theme({}))<cr>
" nnoremap <silent> <leader>T :BTags<cr>
nnoremap <silent> <leader>T <cmd>lua require'telescope.builtin'.current_buffer_tags(_G.falcon.get_simple_theme({}))<cr>
" nnoremap <silent> <leader>ft :Tags<cr>
" noremap <silent> <c-t> :Tags<cr>
" noremap <silent> <c-t> :Tags<cr>
" nnoremap <silent> <c-t> <cmd>lua require'telescope.builtin'.tags(_G.falcon.get_full_theme({show_line = true}))<cr>
nnoremap <silent> <c-t> <cmd>lua require'telescope.builtin'.tags{path_display = {"smart"}, show_line = true}<cr>

" nnoremap <silent> <leader>fb :Buffers<cr>
nnoremap <silent> <leader>fb <cmd>lua require'telescope.builtin'.buffers(_G.falcon.get_simple_theme({}))<cr>
" nnoremap <silent> <leader>fl :BLines<cr>
nnoremap <silent> // <cmd>lua require'telescope.builtin'.current_buffer_fuzzy_find(_G.falcon.get_simple_theme({}))<cr>
" nnoremap <silent> // :BLines!<cr>

"search through help files
" nnoremap <silent> <leader>? :Helptags!<cr>
nnoremap <silent> <leader>? <cmd>lua require'telescope.builtin'.help_tags(_G.falcon.get_full_theme({}))<cr>

"search through command history
" nnoremap <silent> <leader>: :History:<cr>
nnoremap <silent> <leader>: <cmd>lua require'telescope.builtin'.command_history(_G.falcon.get_simple_theme({}))<cr>
"search through search history
" nnoremap <silent> <leader>/ :History/<cr>
nnoremap <silent> <leader>/ <cmd>lua require'telescope.builtin'.search_history(_G.falcon.get_simple_theme({}))<cr>

"replace
" replace current word, then can replace next with n . etc.
nnoremap <silent> <leader>c :let @/='\<'.expand('<cword>').'\>'<CR>cgn
xnoremap <silent> <leader>c "sy:let @/=@s<CR>cgn

" search and replace current word in current 'paragraph'
" nnoremap <leader>r :'{,'}s/\<<C-r>=expand('<cword>')<CR>\>/

" search and replace current word in whole buffer
nnoremap <silent> <leader>r :%s/\<<C-r>=expand('<cword>')<CR>\>/

" return a representation of the selected text
" suitable for use as a search pattern
function! GetSelection()
    let old_reg = getreg("v")
    normal! gv"vy
    let raw_search = getreg("v")
    call setreg("v", old_reg)
    return substitute(escape(raw_search, '\/.*$^~[]'), "\n", '\\n', "g")
endfunction

" visual replace in current buffer
xnoremap <expr> <leader>r v:count > 0 ? ":\<C-u>s/\<C-r>=GetSelection()\<CR>//g\<Left>\<Left>" : ":\<C-u>%s/\<C-r>=GetSelection()\<CR>//g\<Left>\<Left>"

let g:FerretMap=0

let g:agriculture#rg_options='--colors "path:fg:239" --colors "match:fg:252" --colors "line:fg:254"'
let g:agriculture#fzf_extra_options='--no-bold --color=hl:7,hl+:3 --prompt="=> "'

" nnoremap <leader>s :Rg<space>
nnoremap <silent> <leader>fg <cmd>lua require'telescope.builtin'.live_grep(_G.falcon.get_full_theme({}))<cr>
nmap <silent> <leader>s <cmd>lua require'telescope.builtin'.grep_string(_G.falcon.get_full_theme({ search = vim.fn.input('Search > ') }))<cr>
" todo get the full ignore working
nmap <silent> <leader>S <cmd>lua require'telescope.builtin'.grep_string(_G.falcon.get_full_theme({ search = vim.fn.input('Search all > '), no_ignore = true, hidden = true}))<cr>
" :lua require('telescope.builtin').grep_string{ search = vim.fn.input('Grep for > ' ) })
" nmap <leader>s <Plug>RgRawSearch
" nmap <leader>S <Plug>RgRawAllSearch
" xmap <leader>s <Plug>RgRawVisualSelection<cr>
nmap <silent> <leader>k <cmd>lua require'telescope.builtin'.grep_string(_G.falcon.get_full_theme({}))<cr>
" nmap <silent> <leader>k <Plug>RgRawWordUnderCursor<cr>
" nmap <silent> <leader>K <Plug>RgRawAllWordUnderCursor<cr>

"replace across files
nmap <silent> <leader>R <Plug>(FerretAcks)
" nmap <silent> <leader>

"highlight matches in place with g*, doesn't work?
" nnoremap <silent> g* :let @/='\<'.expand('<cword>').'\>'<CR>
" xnoremap <silent> g* "sy:let @/=@s<CR>

" }}} Searching and replacing [leader s*] "

