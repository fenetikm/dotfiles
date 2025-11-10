require("lsp-format").setup {}

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    require("lsp-format").on_attach(client, args.buf)
  end,
})

vim.cmd([[
autocmd FileType php setlocal shiftwidth=4 tabstop=4

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

function! CustomVimuxStrategyDebug(cmd)
  " Note: if there is only one count then this seems to do the right thing and pops out a new pane
  let pane_count = str2nr(system('tmux list-panes | wc -l'))
  if pane_count == '3'
    let g:VimuxRunnerIndex = pane_count
  endif
  call VimuxClearRunnerHistory()
  call VimuxRunCommand('clear')
  call VimuxRunCommand(a:cmd . ' --debug')
endfunction

let g:test#custom_strategies = {'custom_vimux': function('CustomVimuxStrategy'), 'custom_vimux_debug': function('CustomVimuxStrategyDebug')}
let g:test#strategy = 'custom_vimux'

let test#base#no_colors = 1

"to php slime:
" create new window
" open up tmux pane, run `php -r`
" in vim, either select or in normal and <c-c><c-c>
let g:slime_default_config = {"socket_name": "default", "target_pane": "{right}"}
let g:slime_dont_ask_default = 1
]])

local dap = require('dap')

dap.adapters.php = {
  type = 'executable',
  command = 'node',
  args = { os.getenv('HOME') .. '/tmp/vscode-php-debug/out/phpDebug.js' }
}

dap.configurations.php = {
  {
    type = 'php',
    request = 'launch',
    name = 'Listen for Xdebug (9003)',
    port = 9003,
    log = true,
  },
}
