-- center the screen on the cursor when jumping around methods
vim.keymap.set('n', '[m', '[mzz', {noremap = true})
vim.keymap.set('n', ']m', ']mzz', {noremap = true})

-- yank to end of line, just like shit-d, shift-c
vim.keymap.set('n', '<s-y>', 'y$', {noremap = true})

-- move selection up and down, thanks prime
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- open file under cursor
vim.keymap.set('n', 'gx', [[:execute '!open ' . shellescape(expand('<cfile>'), 1)<CR>]], {noremap = true, silent = true})

-- if current line is empty, send to _ register, otherwise copy
vim.keymap.set("n", "dd", function ()
  if vim.fn.getline(".") == "" then return '"_dd' end
  return "dd"
end, {expr = true})

-- redoo shift+u
vim.keymap.set('n', 'U', '<c-r>')

-- map j and k to do linewise up and down, don't mess with count for relative numbering
vim.keymap.set('n', 'j', 'v:count ? "j" : "gj"', { noremap = true, expr = true })
vim.keymap.set('n', 'k', 'v:count ? "k" : "gk"', { noremap = true, expr = true })

-- bigger move up and down
vim.keymap.set('n', 'J', '6j', {})
vim.keymap.set('n', 'K', '6k', {})

-- keep cursor in middle of page when going to next search hit
vim.keymap.set('n', 'n', 'nzzzv', {noremap = true})
vim.keymap.set('n', 'N', 'Nzzzv', {noremap = true})

-- fast split switching
vim.keymap.set('n', '<c-h>', '<c-w>h', {noremap = true})
vim.keymap.set('n', '<c-j>', '<c-w>j', {noremap = true})
vim.keymap.set('n', '<c-k>', '<c-w>k', {noremap = true})
vim.keymap.set('n', '<c-l>', '<c-w>l', {noremap = true})

-- swap window direction
vim.keymap.set('n', '<c-w>s', '<cmd>call custom#ToggleWindowHorizontalVerticalSplit()<cr>', {noremap = true, silent = true})

-- switch tabs
vim.keymap.set('n', '<c-w>n', '<c-pagedown>', { noremap = true })
vim.keymap.set('n', '<c-w>p', '<c-pageup>', { noremap = true })

-- focus fold, close others
vim.keymap.set('n', 'z<space>', 'zMzAzz', { noremap = true })

vim.cmd([[
  "Redo for shift-u
  " noremap U <c-r>

  " Edit macro
  " not sure how to use this!
  " nnoremap <leader>m  :<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>

  "treat long lines as break lines, but don't mess with the count for relative numbering
  " nnoremap <expr> j v:count ? 'j' : 'gj'
  " nnoremap <expr> k v:count ? 'k' : 'gk'

  " Keep search matches in the middle of the window, n goes forward, N goes back
  " How to make this work?
  " nnoremap <expr> n  'Nn'[v:searchforward] . 'zv'
  " xnoremap <expr> n  'Nn'[v:searchforward]
  " onoremap <expr> n  'Nn'[v:searchforward]
  "
  " nnoremap <expr> N  'nN'[v:searchforward] . 'zv'
  " xnoremap <expr> N  'nN'[v:searchforward]
  " onoremap <expr> N  'nN'[v:searchforward]
  " nnoremap n nzzzv
  " nnoremap N Nzzzv

  " Fast switching between splits
  " nnoremap <c-h> <c-w>h
  " nnoremap <c-j> <c-w>j
  " nnoremap <c-k> <c-w>k
  " nnoremap <c-l> <c-w>l

  "s for `swap` direction
  " nnoremap <silent> <c-w>s :call custom#ToggleWindowHorizontalVerticalSplit()<cr>

  " switch tabs
  " nnoremap <c-w>n <c-pagedown>
  " nnoremap <c-w>p <c-pageup>

  "focus the current fold
  " nnoremap z<space> zMzAzz

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
  " nnoremap <leader>d "udd
  nnoremap <leader>p "up=iB
  nnoremap <leader>P "uP=iB

  "visual mode
  xnoremap <leader>y "uyy
  " xnoremap <leader>d "ud

  "easier begin and end of line
  nnoremap <s-h> ^
  vnoremap <s-h> ^
  nnoremap <s-l> $
  vnoremap <s-l> $

  "map alternate file switching to leader leader
  nnoremap <leader><leader> <c-^>

  "close the preview window with leader z
  "TODO never do this?
  " nmap <leader>z :pclose<cr>
  " replaced with zenmode toggle

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
  " replaced with dial.nvim mapping
  " nnoremap + <C-a>
  " nnoremap - <C-x>

  "for visual selections, will create incremental list when all 0 on each line
  " xnoremap + g<C-a>
  " xnoremap - g<C-x>

  "quick enter command mode
  noremap ; :
  nnoremap q; q:

  " tab to go forward
  inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

  " shift tab to go backwards
  inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

  "jump to end when inserting
  inoremap <c-e> <c-o>$

  "line completion
  " inoremap <c-l> <c-x><c-l>

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
  nnoremap <leader>ey :call OpenOrSplit("~/.config/kitty/kitty.conf")<cr>
  nnoremap <leader>eh :call OpenOrSplit("~/.hammerspoon/init.lua")<cr>
  nnoremap <leader>ez :call OpenOrSplit("~/.zshrc")<cr>
  nnoremap <leader>eg :call OpenOrSplit("~/.gitconfig")<cr>
  nnoremap <leader>ew :call OpenOrSplit("~/.taskrc")<cr>
  nnoremap <leader>er :call OpenOrSplit("~/.config/ranger/rc.conf")<cr>
  nnoremap <leader>eu :lua require'luasnip.loaders'.edit_snippet_files({edit = function(file) vim.cmd("vsp " .. file)end})<cr>
  nnoremap <leader>ep :call StartSlime()<cr>

  function! StartSlime()
    execute 'bd'
    let g:startify_disable_at_vimenter=1
    execute 'new'
    execute 'only'
    execute 'set ft=php'
    call append(0, "<?php")
  endfunction

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
]])
