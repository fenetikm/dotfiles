--to update one day, if not replaced
--[[
let g:vdebug_options = {
    \    'port' : 9000,
    \    'timeout' : 20,
    \    'server' : '',
    \    'on_close' : 'stop',
    \    'break_on_open' : 1,
    \    'ide_key' : '',
    \    'debug_window_level' : 0,
    \    'debug_file_level' : 0,
    \    'debug_file' : '',
    \    'path_maps' : '',
    \    'watch_window_style' : 'compact',
    \    'marker_default' : '⬦',
    \    'marker_closed_tree' : '▸',
    \    'marker_open_tree' : '▾',
    \    'sign_breakpoint' : '▷',
    \    'sign_current' : '▶',
    \    'continuous_mode'  : 1,
    \    'background_listener' : 1,
    \    'auto_start' : 1,
    \    'window_commands' : {
    \        'DebuggerWatch' : 'vertical belowright new',
    \        'DebuggerStack' : 'belowright new',
    \        'DebuggerStatus' : 'belowright new'
    \    },
    \    'window_arrangement' : ['DebuggerWatch', 'DebuggerStack', 'DebuggerStatus']
    \}

"defaults
let g:vdebug_keymap = {
    \    "run" : "<F5>",
    \    "run_to_cursor" : "<F9>",
    \    "step_over" : "<F2>",
    \    "step_into" : "<F3>",
    \    "step_out" : "<F4>",
    \    "close" : "<F6>",
    \    "detach" : "<F7>",
    \    "set_breakpoint" : "<F10>",
    \    "get_context" : "<F11>",
    \    "eval_under_cursor" : "<F12>",
    \    "eval_visual" : "<Leader>e",
    \}

let g:vdebug_features = {
    \   "max_depth": "2048"
    \}

" nmap <leader>xrd :call RemapDebug()<cr>
]]
