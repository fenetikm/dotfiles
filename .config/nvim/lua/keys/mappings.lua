local yank = require 'custom.yank'

-- center the screen on the cursor when jumping around methods
vim.keymap.set('n', '[m', '[mzz', { noremap = true })
vim.keymap.set('n', ']m', ']mzz', { noremap = true })

-- yank to end of line, just like shit-d, shift-c
vim.keymap.set('n', '<s-y>', 'y$', { noremap = true })

-- incremental selection
vim.keymap.set({ "x" }, "v", function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require("vim.treesitter._select").select_parent(vim.v.count1)
  else
    vim.lsp.buf.selection_range(vim.v.count1)
  end
end, { desc = "Select parent treesitter node or outer incremental lsp selections" })

vim.keymap.set({ "x" }, "V", function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require("vim.treesitter._select").select_child(vim.v.count1)
  else
    vim.lsp.buf.selection_range(-vim.v.count1)
  end
end, { desc = "Select child treesitter node or inner incremental lsp selections" })

-- yank with extra info, from: https://github.com/richardgill/nix/blob/bdd30a0a4bb328f984275c37c7146524e99f1c22/modules/home-manager/dot-files/nvim/lua/config/keymap.lua
vim.keymap.set('n', '<leader>ya', function()
  yank.yank_path(yank.get_buffer_absolute(), 'absolute')
end, { desc = '[Y]ank [A]bsolute path to clipboard' })

vim.keymap.set('n', '<leader>yr', function()
  yank.yank_path(yank.get_buffer_cwd_relative(), 'relative')
end, { desc = '[Y]ank [R]elative path to clipboard' })

vim.keymap.set('v', '<leader>ya', function()
  yank.yank_visual_with_path(yank.get_buffer_absolute(), 'absolute')
end, { desc = '[Y]ank selection with [A]bsolute path' })

vim.keymap.set('v', '<leader>yr', function()
  yank.yank_visual_with_path(yank.get_buffer_cwd_relative(), 'relative')
end, { desc = '[Y]ank selection with [R]elative path' })

-- move selection up and down, thanks prime
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- open file under cursor
vim.keymap.set('n', 'gx', [[:execute '!open ' . shellescape(expand('<cfile>'), 1)<CR>]],
  { noremap = true, silent = true })

-- if current line is empty, send to _ register, otherwise copy
vim.keymap.set("n", "dd", function()
  if vim.fn.getline(".") == "" then return '"_dd' end
  return "dd"
end, { expr = true })

-- previous mappings
-- redo shift+u
vim.keymap.set('n', 'U', '<c-r>')

-- map j and k to do linewise up and down, don't mess with count for relative numbering
vim.keymap.set('n', 'j', 'v:count ? "j" : "gj"', { noremap = true, expr = true })
vim.keymap.set('n', 'k', 'v:count ? "k" : "gk"', { noremap = true, expr = true })

-- bigger move up and down
vim.keymap.set('n', 'J', '6j', {})
vim.keymap.set('n', 'K', '6k', {})

-- keep cursor in middle of page when going to next search hit
vim.keymap.set('n', 'n', 'nzzzv', { noremap = true })
vim.keymap.set('n', 'N', 'Nzzzv', { noremap = true })

-- split navigation
vim.keymap.set('n', '<c-h>', '<c-w>h', { noremap = true })
vim.keymap.set('n', '<c-j>', '<c-w>j', { noremap = true })
vim.keymap.set('n', '<c-k>', '<c-w>k', { noremap = true })
vim.keymap.set('n', '<c-l>', '<c-w>l', { noremap = true })

-- swap window direction
vim.keymap.set('n', '<c-w>s', '<cmd>call custom#ToggleWindowHorizontalVerticalSplit()<cr>',
  { noremap = true, silent = true })

-- switch tabs
vim.keymap.set('n', '<c-w>n', '<c-pagedown>', { noremap = true })
vim.keymap.set('n', '<c-w>p', '<c-pageup>', { noremap = true })

-- focus fold, close others
vim.keymap.set('n', 'z<space>', 'zMzAzz', { noremap = true })

-- navigate folds
vim.keymap.set('n', '[z', 'zk', { noremap = true })
vim.keymap.set('n', 'z]', 'zj', { noremap = true })

-- in visual mode can go back and forward on the current selection
vim.keymap.set('v', '*', '<cmd>call VisualSelection("f")', { noremap = true, silent = true })
vim.keymap.set('v', '#', '<cmd>call VisualSelection("b")', { noremap = true, silent = true })

-- get the selection back after indenting
vim.keymap.set('x', '<', '<gv', { noremap = true })
vim.keymap.set('x', '>', '>gv', { noremap = true })

vim.cmd([[
  "remap ` to '
  "` jumps to the line and column marked with ma
  nnoremap ' `
  nnoremap ` '

  "yanking and pasting from a register with indent
  "can these be made shorter? better?
  "TODO use these more? change?
  " nnoremap <leader>y "uyy
  " nnoremap <leader>d "udd
  " nnoremap <leader>p "up=iB
  " nnoremap <leader>P "uP=iB

  " paste without destroying what was previously yanked, neat
  vnoremap <leader>p "_dP

  "easier begin and end of line
  nnoremap <s-h> ^
  vnoremap <s-h> ^
  nnoremap <s-l> $
  vnoremap <s-l> $

  "map alternate file switching to leader leader
  nnoremap <leader><leader> <c-^>
  " alternate
  " nnoremap <Backspace> <c-^>

  " Use CTRL-S for saving
  noremap <silent> <c-s> :update!<cr>

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

  " navigation of quick / location
  nnoremap <Down> :lnext<cr>
  nnoremap <Up> :lprevious<cr>
  nnoremap <Right> :cnext<cr>
  nnoremap <Left> :cprevious<cr>

  "quick enter command mode
  noremap ; :
  nnoremap q; q:

  " tab to go forward
  inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

  " shift tab to go backwards
  inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

  "jump to end when inserting
  inoremap <c-e> <c-o>$

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
  nnoremap <leader>et :call OpenOrSplit("~/.tmux.conf")<cr>
  nnoremap <leader>ek :call OpenOrSplit("~/.config/karabiner/karabiner.json")<cr>
  nnoremap <leader>ey :call OpenOrSplit("~/.config/kitty/kitty.conf")<cr>
  nnoremap <leader>ei :call OpenOrSplit("~/.config/yabai/yabairrc")<cr>
  nnoremap <leader>eh :call OpenOrSplit("~/.hammerspoon/init.lua")<cr>
  nnoremap <leader>ez :call OpenOrSplit("~/.zshrc")<cr>
  nnoremap <leader>eg :call OpenOrSplit("~/.gitconfig")<cr>
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
