" File: vimrc.
" Author: Michael Welford.

let g:python3_host_prog = '/usr/local/bin/python3'

luafile ~/.config/nvim/lua/plugins.lua
luafile ~/.config/nvim/lua/config/lsp.lua
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

"format in function / block
function FormatBlock()
  call feedkeys('=iB')
endfunction
nnoremap <leader>= :call FormatBlock()<cr>

" }}} End Mappings

" Colors {{{

"dark
set background=dark

" falcon settings
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

" Match @done
syntax match myDone '@\cdone'
highlight link myDone Done

" After this file is sourced, plugin code will be evaluated.
" See ~/.vim/after for files evaluated after that.
" See `:scriptnames` for a list of all scripts, in evaluation order.
" Launch Vim with `vim --startuptime vim.log` for profiling info.
" To see all leader mappings, including those from plugins:
"   vim -c 'set t_te=' -c 'set t_ti=' -c 'map <space>' -c q | sort
