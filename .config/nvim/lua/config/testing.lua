vim.cmd [[
nnoremap <leader>oo :TestLast<cr>
nnoremap <leader>of :TestFile<cr>
nnoremap <leader>on :TestNearest<cr>
nnoremap <leader>os :TestSuite<cr>

" rest of this is in autoload/vim-test.vim
function! CustomVimuxStrategy(cmd)
  " Note: if there is only one count then this seems to do the right thing and pops out a new pane
  let pane_count = str2nr(system('tmux list-panes | wc -l'))
  if pane_count == '3'
    let g:VimuxRunnerIndex = pane_count
  endif
  call VimuxClearRunnerHistory()
  call VimuxRunCommand('clear')
  call VimuxRunCommand(a:cmd)
endfunction

let g:test#custom_strategies = {'custom_vimux': function('CustomVimuxStrategy')}
let g:test#strategy = 'custom_vimux'

let test#custom_runners = {'php': ['megarunner']}
]]
