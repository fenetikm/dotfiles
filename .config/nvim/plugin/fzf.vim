" TODO get this out of `plugin`
" match splitting to ctrl-w splitting
let g:fzf_action = {
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-o': '!open'}

" default layout
let g:fzf_layout = { 'window': 'call FloatingFZF()' }

"show fzf results in floating window
function! FloatingFZF()
  let buf = nvim_create_buf(v:false, v:true)

  let height = &lines - 3
  if (height > 25)
    let height = 25
  endif

  let width = float2nr(&columns - 8)
  if (width < 90)
    let width = &columns
  endif

  let col = float2nr((&columns - width) / 2)
  let row = float2nr(&lines - height - 4)

  let opts = {
        \ 'relative': 'editor',
        \ 'row': row,
        \ 'col': col,
        \ 'width': width,
        \ 'height': height
        \ }

  let win = nvim_open_win(buf, v:true, opts)

  "Set Floating Window Highlighting
  call setwinvar(win, '&winhl', 'Normal:NormalFloat')

  setlocal
        \ buftype=nofile
        \ nobuflisted
        \ bufhidden=hide
        \ nonumber
        \ norelativenumber
        \ signcolumn=no
endfunction

"Default Ag command with addition of changing color
" command! -bang -nargs=* Ag
"   \ call fzf#vim#ag(<q-args>, '--color-path "38;5;241" --color-match "38;5;254" --color-line-number "38;5;254"', g:fzf_layout)

" Ag all files
" command! -bang -nargs=* AgAll
"   \ call fzf#vim#ag(<q-args>, '--color-path "38;5;241" --color-match "38;5;254" --color-line-number "38;5;254;" -a', g:fzf_layout)

"don't jump to an open buffer, reopen
let g:fzf_buffers_jump=0

" command! -bang -nargs=* AFiles call fzf#vim#grep('rg --no-heading --fixed-strings --ignore-case --no-ignore --hidden --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)
command! -bang -nargs=* AllFiles call fzf#vim#grep('fd --hidden --no-ignore --type f '.shellescape(<q-args>), 1, {'options': '--no-bold --color=hl:7,hl+:3'})

" command! -bang -nargs=* FilesDir call fzf#vim#files(<q-args>, <bang>0)

function! s:FilesDir(dir)
  execute "call fzf#vim#files(" . a:dir . ")"
endfunction
command! -nargs=1 FilesDir call s:FilesDir(<q-args>)

function! s:ProcessMyCommand(l)
  let keys = split(a:l, ':\t')
  let command_parts = split(keys[0], '|')
  let command_function = split(command_parts[1], '#')
  "for commands that might run through vagrant
  if command_parts[0] == 'dh' || command_parts[0] == 'dc' || command_parts[0] == 'rb' || command_parts[0] == 'cp'
    let command_bin = 'vagrant exec'
    "drush, drupal console, robo, composer
    "check for the vagrant binstub version
    if command_parts[0] == 'dh' && filereadable('vbin/drush')
      let command_bin = 'vbin/drush'
    elseif command_parts[0] == 'dc' && filereadable('vbin/drupal')
      let command_bin = 'vbin/drupal'
    elseif command_parts[0] == 'rb' && filereadable('vbin/robo')
      let command_bin = 'vbin/robo'
    elseif command_parts[0] == 'cp'
      let command_bin = 'composer'
    endif
    "check for * which signifies to use a prompt
    let trimmed_function = split(command_function[0], '*')
    if len(trimmed_function) == 2
      let pane_count = str2nr(system('tmux list-panes | wc -l'))
      if pane_count == '3'
        let g:VimuxRunnerIndex = pane_count
      endif
      "Extra space for after prompt
      execute 'call VimuxPromptCommand("'.command_bin.trimmed_function[0].' ")'
    else
      let pane_count = str2nr(system('tmux list-panes | wc -l'))
      if pane_count == '3'
        let g:VimuxRunnerIndex = pane_count
      endif
      execute 'call VimuxRunCommand("'.command_bin.command_function[0].'")'
    endif
  elseif command_parts[0] == 'vc'
    "vim call
    execute 'call '.command_function[0]
  elseif command_parts[0] == 'op'
    execute '!open -g '.command_function[0]
  else
    "just do whatever it says
    execute command_function[0]
  endif
endfunction

"Pull in from *.cmd files from current directory and home nvim config directory.
" command! -bang -nargs=* MyCommands call fzf#run({'sink': function('<sid>ProcessMyCommand'), 'source': 'cat '.$HOME.'/.config/nvim/*.cmd *.cmd 2>/dev/null'})
" not using this any more
" nnoremap <c-c> :MyCommands<cr>

"@todo need to insert in the DrupalRoot here
function! s:DoDrupalEditConfig(c)
  execute 'call VimuxRunCommand("vbin/drush cedit '.a:c.'")'
endfunction

command! -bang -nargs=* DrupalEditConfig call fzf#run({'sink': function('<sid>DoDrupalEditConfig'), 'source': 'vbin/drush sqlq \"select name from config\"'})

function! s:DirWithDrupalRoot(options)
  let root = DrupalRoot()
  " let ret_val = {'options': '--color-path 400'}
  let ret_val = {}
  if a:options != ''
    ret_val['source'] = 'ag ' . a:options
  endif
  if v:shell_error
    return ret_val
  endif
  ret_val['dir'] = root
  return ret_val
endfunction

" Add your path here.
let plugins_dir='/Users/mjw/.config/nvim/plugged' 
let preview_file = plugins_dir . "/fzf.vim/bin/preview.sh"

" Preview for BTags
command! -bang BTags
  \ call fzf#vim#buffer_tags('', {
  \     'window': 'call FloatingFZF()',
  \     'options': '--with-nth 1 
  \                 --prompt "=> " 
  \                 --preview-window="50%" 
  \                 --preview "
  \                     tail -n +\$(echo {3} | tr -d \";\\\"\") {2} |
  \                     head -n 16"'
  \ })

"add preview to Tags, might have to put this in lvimrc
let preview_file = '/Users/mjw/.config/preview/preview.sh'
command! -bang -nargs=* Tags
  \ call fzf#vim#tags(<q-args>, {
  \      'window': 'call FloatingFZF()',
  \      'options': '
  \         --with-nth 1,2
  \         --prompt "=> "
  \         --preview-window="50%"
  \         --preview ''' . preview_file . ' {}'''
  \ }, <bang>0)
