"centering when going between methods
nnoremap [m [mzz
nnoremap ]m ]mzz

" yank to end of line, just like shit-d, shift-c
noremap <s-y> y$

"Redo for shift-u
noremap U <c-r>

"treat long lines as break lines, but don't mess with the count for relative numbering
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

" Fast switching between splits
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

"s for `swap` direction
nnoremap <silent> <c-w>s :call custom#ToggleWindowHorizontalVerticalSplit()<cr>

" switch tabs
nnoremap <c-w>n <c-pagedown>
nnoremap <c-w>p <c-pageup>

"focus the current fold
nnoremap z<space> zMzAzz

" Folds navigation
nnoremap [z zk
nnoremap ]z zj

"visual mode pressing * or # searches for the current selection
vnoremap <silent> * :call VisualSelection('f')<cr>
vnoremap <silent> # :call VisualSelection('b')<cr>

"remap ` to '
"` jumps to the line and column marked with ma
nnoremap ' `
nnoremap ` '

"get the selection back after indenting
xnoremap <  <gv
xnoremap >  >gv

"yanking and pasting from a register with indent
"can these be made shorter? better?
"TODO use these more? change?
nnoremap <leader>y "uyy
nnoremap <leader>d "udd
nnoremap <leader>p "up=iB
nnoremap <leader>P "uP=iB

"visual mode
xnoremap <leader>y "uyy
xnoremap <leader>d "ud

"easier begin and end of line
nnoremap <s-h> ^
vnoremap <s-h> ^
nnoremap <s-l> $
vnoremap <s-l> $

"map alternate file switching to leader leader
nnoremap <leader><leader> <c-^>

"close the preview window with leader z
"TODO never do this?
nmap <leader>z :pclose<cr>

" Use CTRL-S for saving, also in Insert mode
noremap <silent> <c-s> :update!<cr>
vnoremap <silent> <c-s> <c-c>:update!<cr>
inoremap <silent> <c-s> <c-o>:update!<cr>

" quit all
nnoremap ZQ :qa!<cr>

" map w!! to sudo save
" TODO does this still work?
cmap w!! w !sudo tee % >/dev/null

"fast quit, fast write
noremap <C-q> :quit<cr>
nnoremap <c-x> :wq!<cr>

"disable accidental Ex mode
nnoremap Q <nop>

"this breaks things... somewhere
map <c-,> nop

"region expanding
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" hooray for programmable keyboards, navigation of quick / location
nnoremap <Down> :lnext<cr>
nnoremap <Up> :lprevious<cr>
nnoremap <Right> :cnext<cr>
nnoremap <Left> :cprevious<cr>

"sensible increment / decrement, the default is mapped
nnoremap + <C-a>
nnoremap - <C-x>

"for visual selections, will create incremental list when all 0 on each line
xnoremap + g<C-a>
xnoremap - g<C-x>

"quick enter command mode
noremap ; :
nnoremap q; q:

" tab to go forward
inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" shift tab to go backwards
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
