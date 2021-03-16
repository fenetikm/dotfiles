" File: vimrc.
" Author: Michael Welford.

let g:python3_host_prog = '/usr/local/bin/python3'

luafile ~/.config/nvim/lua/plugins.lua
source ~/.config/nvim/general/settings.vim
source ~/.config/nvim/general/folding.vim
source ~/.config/nvim/general/filetypes.vim
source ~/.config/nvim/general/auto_buffers.vim
source ~/.config/nvim/general/functions.vim
source ~/.config/nvim/general/commands.vim

" TODO additional plugin settings
" Note that files in plugin directory would have already loaded

" TODO
source ~/.config/nvim/keys/escape.vim
source ~/.config/nvim/keys/toggle.vim
source ~/.config/nvim/keys/searchreplace.vim
source ~/.config/nvim/keys/mappings.vim

" Completion {{{
if !exists('g:context_filetype#same_filetypes')
  let g:context_filetype#same_filetypes = {}
endif

" stop insertion, match with the longest common match, still show if one option
" set completeopt=longest,menuone

" tab to go forward
inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" shift tab to go backwards
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

" }}} End Deoplete
" nvim-compe {{{
" deoplete setting
" set completeopt=longest,menuone
set completeopt=menuone,noselect

" from the README, need to check them out
let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
" let g:compe.source.calc = v:true
" let g:compe.source.vsnip = v:true
let g:compe.source.ultisnips = v:true
let g:compe.source.nvim_lsp = v:true
" let g:compe.source.nvim_lua = v:true
let g:compe.source.spell = v:true
" let g:compe.source.tags = v:true
" let g:compe.source.snippets_nvim = v:true
let g:compe.source.treesitter = v:true
let g:compe.source.omni = v:true

" because of lexima
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm(lexima#expand('<LT>CR>', 'i'))
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

"filetype specific setups

" }}} nvim-compe

" EasyMotion, Sneak, Snipe etc. --------------------------------------------------- {{{
" Markdown --------------------------------------------------- {{{

" let g:mkdx#settings = { 'map': { 'enable': 0 },
"                        \ 'checkbox': { 'toggles': [' ', 'x', '-'] }
"                        \ }
" let g:polyglot_disabled = ['markdown']

"highlight frontmatter
let g:vim_markdown_frontmatter = 1

"strikethrough support, with two tildes ~~
let g:vim_markdown_strikethrough = 1

" .md not required in links
let g:vim_markdown_no_extensions_in_markdown = 1

" bullets and indenting is covered by bullets.vim
" disable new line bullets
let g:vim_markdown_auto_insert_bullets = 0

"disable the indenting
let g:vim_markdown_new_list_item_indent = 0

"save file when following a link
let g:vim_markdown_autowrite = 1

let g:vim_markdown_folding_style_pythonic = 1

" }}} End Markdown
" Neuron --------------------------------------------------- {{{
let g:neuron_no_mappings = 1
" let g:neuron_dir = '/Users/mjw/Google\ Drive/zettelkasten/'
let g:neuron_inline_backlinks = 1
let g:neuron_executable = '/Users/mjw/.nix-profile/bin/neuron'
let g:neuron_tags_style = 'inline'
let g:neuron_debug_enable = 0

func! NewZettel(...)
  let l:only = get(a:, 1, 0)
  let l:type = get(a:, 2, 0)
  let l:file_name = systemlist('od -vAn -N4 -tx < /dev/urandom | tr -d " "')[0]
  let g:startify_disable_at_vimenter=1
  exec 'new'
  if !empty(l:only)
    exec 'only'
  endif
  exec 'w ' . l:file_name . '.md'
  exec 'set filetype=markdown'
  if empty(l:type)
    call feedkeys('ifz')
  else
    call feedkeys('ifzb')
  endif
  call feedkeys("\<c-j>", 'x')
endfunc
command! NewZettel call NewZettel()

" }}} End Neuron
"
" treesitter {{{

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { "c", "php" },  -- list of language that will be disabled
  },
}
EOF

func! Node()
lua <<EOF
ts_utils = require 'nvim-treesitter.ts_utils'
print(ts_utils.get_node_at_cursor())
EOF
endfunc
command! ShowNode call Node()

lua <<EOF
local ts_utils = require 'nvim-treesitter.ts_utils'
EOF
" }}} treesitter
" lsp {{{

lua << EOF
local nvim_lsp = require'lspconfig'

local on_attach = function(client)
end

nvim_lsp.intelephense.setup({ on_attach=on_attach })

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)
EOF

" have a fixed column for the diagnostics to appear in
" this removes the jitter when warnings/errors flow in
set signcolumn=yes

" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=300
" Show diagnostic popup on cursor hover
autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()

" Goto previous/next diagnostic warning/error
nnoremap <silent> g[ <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> g] <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

" }}}

" Mappings {{{

" Key escape remapping {{{
" Insert mode mappings {{{

"jump to end when inserting
inoremap <c-e> <c-o>$

" insert rocket
" inoremap <c-l> <space>=><space>
"
"completion shortcuts
"complete with tags
inoremap <c-]> <c-x><c-]>
"omni / language completion
inoremap <c-space> <c-x><c-o>
"buffer completion
inoremap <c-b> <c-x><c-p>
"file path completion
inoremap <c-f> <c-x><c-f>
"line completion, conflicts with php rocket... not any more!
inoremap <c-l> <c-x><c-l>

" something else is being called on the below
" inoremap <expr> <c-x><c-x> fzf#vim#complete#buffer_line({'window': 'call FloatingFZF()'})
" imap <c-x><c-x> <plug>(fzf-complete-line)

" }}} End Insert mode mappings
" Easy file opening [leader e*]{{{

"ev to edit vimrc, eV to source vimrc
nnoremap <silent> <leader>eV :so $MYVIMRC <bar>exe 'normal! zvzz'<cr>

"quick editing straight open or split
function! OpenOrSplit(filename)
  if bufname('') == 'Startify' || bufname('') == ''
    execute 'edit' a:filename | execute 'normal! zvzz'
  else
    execute 'vsplit' a:filename | execute 'normal! zvzz'
  endif
endfunction
nnoremap <leader>ev :call OpenOrSplit($MYVIMRC)<cr>
nnoremap <leader>ed :call OpenOrSplit("~/.drush/aliases.drushrc.php")<cr>
nnoremap <leader>et :call OpenOrSplit("~/.tmux.conf")<cr>
nnoremap <leader>ek :call OpenOrSplit("~/.config/karabiner/karabiner.json")<cr>
nnoremap <leader>ey :call OpenOrSplit("~/Library/Preferences/kitty/kitty.conf")<cr>
nnoremap <leader>eh :call OpenOrSplit("~/.hammerspoon/init.lua")<cr>
nnoremap <leader>ez :call OpenOrSplit("~/.zshrc")<cr>
nnoremap <leader>eg :call OpenOrSplit("~/.gitconfig")<cr>
nnoremap <leader>ew :call OpenOrSplit("~/.taskrc")<cr>
nnoremap <leader>er :call OpenOrSplit("~/.config/ranger/rc.conf")<cr>
nnoremap <leader>eu :UltiSnipsEdit<cr>
nnoremap <leader>ep :call StartSlime()<cr>

function! StartSlime()
  execute 'bd'
  let g:startify_disable_at_vimenter=1
  execute 'new'
  execute 'only'
  execute 'set ft=php'
  call append(0, "<?php")
endfunction

" }}} End Easy file opening
" Searching and replacing [leader s*] {{{ "

" refold php
function! PHPFold(close) abort
  execute ":EnablePHPFolds()<cr>"
  normal! zmzAzz
  if (a:close == 1)
    normal! za
  endif
endfunction
nnoremap zp :silent! call PHPFold(0)<cr>
nnoremap zP :silent! call PHPFold(1)<cr>

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

"format in function / block
function FormatBlock()
  call feedkeys('=iB')
endfunction
nnoremap <leader>= :call FormatBlock()<cr>

"yanking and pasting from a register with indent
"can these be made shorter?
nnoremap <leader>y "uyy
nnoremap <leader>d "udd
nnoremap <leader>p "up=iB
nnoremap <leader>P "uP=iB

"visual mode
xnoremap <leader>y "uyy
xnoremap <leader>d "ud

"map alternate file switching to leader leader
nnoremap <leader><leader> <c-^>

"easier begin and end of line
nnoremap <s-h> ^
vnoremap <s-h> ^
nnoremap <s-l> $
vnoremap <s-l> $

"close the preview window with leader z
nmap <leader>z :pclose<cr>

" Use CTRL-S for saving, also in Insert mode
noremap <c-s> :update<cr>
vnoremap <c-s> <c-c>:update<cr>
inoremap <c-s> <c-o>:update<cr>

" quit all
nnoremap ZQ :qa!<cr>

" map w!! to sudo save
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

"refresh chrome
" nnoremap <silent> <leader>r :!chrome-cli reload<cr><cr>

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

" to unlearn it... will use it for something else later mebe
noremap : <nop>

" }}} End Mappings
" Abbreviations {{{

autocmd FileType php inoremap ,ec <?php echo  ?><left><left><left>

" }}} End Abbreviations

" Colors {{{

"dark
set background=dark

" falcon settings
let g:falcon_lightline = 1
let g:lightline.colorscheme='falcon'
let g:falcon_background = 0
let g:falcon_inactive = 1

colorscheme falcon

" set cursors depending on mode
set t_SI=[6\ q
set t_SR=[4\ q
set t_SR=[2\ q

" }}} End Colors
"
" Make a new diary entry
function! s:NewDiaryEntry()
  let s:currentdate = system('date +%Y-%m-%d')[:-2]
  let diaryfile = '~wiki/diary/' . s:currentdate . '.md'
  execute 'new | only'
  if (!empty(glob(diaryfile)))
    "open it
    execute 'e ' . diaryfile
    return
  else
    "create it
    execute 'w ' . diaryfile
  endif
  "run snippet
  call feedkeys('id')
  call feedkeys("\<c-j>", 'x')
endfunction
command! NewDiaryEntry call <sid>NewDiaryEntry()

"Toggles stuff, with fallback tree
"Toggle values
"Could also toggle if($thing) => if(!$thing)
function! s:MegaToggle()
  let word = expand("<cword>")
  let line = getline('.')
  "this might be better to do matching on the line?
  "match on word
  if word =~ 'true\|false\|1\|0\|yes\|no'
    echom 'match'
    return
  endif
  " match on checkbox
  if line =~ '-\s\[\(\s\|x\|X\|\-\)\]'
    echom 'mcb'
    return
  endif
  "on fold? don't think that is going to work?
  " let linenr = line(".") + 1
  " let foldnr = foldclosed(linenr)
  " let foldlev = foldlevel(linenr)
  " echom foldnr
  " echom foldlev
  echom 'nope'
endfunction
command! MegaToggle call <sid>MegaToggle()

" Match @done
syntax match myDone '@\cdone'
highlight link myDone Done

" autocmd ColorScheme * highlight! link SignColumn LineNr
" highlight! link SignColumn LineNr

" After this file is sourced, plugin code will be evaluated.
" See ~/.vim/after for files evaluated after that.
" See `:scriptnames` for a list of all scripts, in evaluation order.
" Launch Vim with `vim --startuptime vim.log` for profiling info.
" To see all leader mappings, including those from plugins:
"   vim -c 'set t_te=' -c 'set t_ti=' -c 'map <space>' -c q | sort
