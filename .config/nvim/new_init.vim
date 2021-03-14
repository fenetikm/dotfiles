" File: vimrc.
" Author: Michael Welford.

let g:python3_host_prog = '/usr/local/bin/python3'

luafile ~/.config/nvim/lua/plugins.lua
source ~/.config/nvim/general/settings.vim
source ~/.config/nvim/general/folding.vim
source ~/.config/nvim/general/filetypes.vim
source ~/.config/nvim/general/auto_buffers.vim
source ~/.config/nvim/general/commands.vim

" TODO
source ~/.config/nvim/keys/mappings.vim


" Helper functions {{{

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction
xnoremap @ :<c-u>call ExecuteMacroOverVisualRange()<CR>

" }}} End Helper functions
" Plugin settings {{{

" Tag plugins {{{

"tagbar
" nmap <leader>tt :TagbarToggle<cr>
let g:tagbar_iconchars = ['', '']
" take preview window from vimrc set options
let g:tagbar_previewwin_pos = ""

" }}} End Tag plugins
" PHP plugins {{{

"php folding
"let g:DisablePHPFoldingClass=1
let g:PHPFoldingCollapsedSymbol='+'
let g:PHPFoldingRepeatSymbol=''
let g:PHPFoldingShowPercentage=0
let g:phpDocIncludedPostfix=''

let g:DisableAutoPHPFolding=1

"php indenting
let g:PHP_vintage_case_default_indent=1

"php documenter
" I think this is causing weird shit to happen sometimes with <space>p
" inoremap <leader>pd <ESC>:call PhpDocSingle()<cr>i
" nnoremap <leader>pd :call PhpDocSingle()<cr>
" vnoremap <leader>pd :call PhpDocRange()<cr>

"php namespace
function! IPhpInsertUse()
    call PhpInsertUse()
    call feedkeys('a',  'n')
endfunction

function! IPhpExpandClass()
    call PhpExpandClass()
    call feedkeys('a',  'n')
endfunction

autocmd FileType php noremap <localleader>pu :call PhpInsertUse()<cr>
autocmd FileType php noremap <localleader>pe :call PhpExpandClass()<cr>
autocmd FileType php noremap <localleader>pa :PHPExpandFQCNAbsolute<cr>

"sort the use statements after inserting
let g:php_namespace_sort_after_insert=1

"phpunitqf
let g:phpunit_cmd='/usr/local/bin/phpunit'

"documenter
let g:pdv_template_dir = "/Users/mjw/.config/nvim/plugged/pdv/templates_snip"

"refactoring
" turn this off and just use our custom command list
let g:vim_php_refactoring_use_default_mapping=0

"disable php manual online shortcut
let g:php_manual_online_search_shortcut = ''

function! UpdatePhpDocIfExists()
  normal! k
  if getline('.') =~ '/'
      normal! V%d
  else
      normal! j
  endif
  call PhpDocSingle()
  normal! k^%k$
  if getline('.') =~ ';'
      exe "normal! $svoid"
  endif
endfunction

" phpactor omni
" autocmd FileType php setlocal omnifunc=phpactor#Complete

" enable echodoc to show function signatures
autocmd FileType php :EchoDocEnable

let g:phpactorOmniAutoClassImport = v:true
let g:phpactorOmniError = v:true

"php syntax
"disable html inside of php syntax highlighting
let g:php_html_load=0

" For UltiSnips
" 0 is braces on the same line
" 1 is braces below
let g:php_brace_style=0

" For UltiSnips
" Number of spaces to indent in PHP
let g:php_indent=2

" }}} End PHP plugins
" Debug plugins {{{

"debugging
"path_maps should be replace in a project .lvimrc
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

" }}} End Debug plugins
" Vimux {{{

"percentage size
let g:VimuxHeight="32"

"set pane to open on right
let g:VimuxOrientation = 'h'

" nnoremap <leader>vp :VimuxPromptCommand<cr>
" nnoremap <leader>vx :VimuxCloseRunner<cr>
" nnoremap <leader>vo :VimuxOpenPane<cr>
" nnoremap <leader>vl :VimuxRunLastCommand<cr>
nnoremap <leader>vl :call VimuxSendKeys("!! C-m C-m")<cr>

" let g:VimuxRunnerIndex=3

" }}} End Vimux
" Splitjoin {{{

"check the ftplugin settings for specific settings

" }}} End Splitjoin
" Local vimrc {{{

let g:localvimrc_ask=0 "don't ask to load local version
let g:localvimrc_sandbox=0 "don't load in sandbox (security)
let g:localvimrc_name=['.lvimrc'] "name of the local vimrc

" }}} End Local vimrc
" Testing {{{

"mnemonic 'ok'
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

" }}} End Testing
" EasyAlign {{{

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

let g:easy_align_bypass_fold = 1
let g:easy_align_ignore_groups = []

" }}} End EasyAlign
" Buftabline {{{
" turn on separators
let g:buftabline_separators=1

" }}} End Buftabline
" Loupe {{{

"turn off insertion of \v
let g:LoupeVeryMagic=0

" }}} End Loupe
" Devicons {{{

"enable on nerdtree
let g:webdevicons_enable_nerdtree=1
let g:WebDevIconsUnicodeDecorateFileNodes=0

" hide the brackets, not useful
let g:webdevicons_conceal_nerdtree_brackets=1
" single width for icons
let g:WebDevIconsUnicodeGlyphDoubleWidth=0

" show the folder glpyh
let g:WebDevIconsUnicodeDecorateFolderNodes=1
let g:DevIconsEnableFoldersOpenClose=1

let NERDTreeDirArrowExpandable = ' ' " make arrows invisible
let NERDTreeDirArrowCollapsible = ' ' " make arrows invisible
let NERTreeNodeEdelimiter=' '

"avoid the system call to detect OS
let g:WebDevIconsOS = 'Darwin'

augroup devicons_nerdtree
    autocmd FileType nerdtree setlocal list
    autocmd FileType nerdtree setlocal nolist
augroup END

" after a re-source, fix syntax matching issues (concealing brackets):
if exists('g:loaded_webdevicons')
  "check for nerdtree loaded
  if exists('g:NERTTreeIgnore')
    call webdevicons#refresh()
  endif
endif

" }}} End Webdevicons
" phpactor {{{

"omnicompletion
" autocmd FileType php setlocal omnifunc=phpactor#Complete
"
" autocmd FileType php LanguageClientStart
" autocmd FileType php set omnifunc=LanguageClient#complete

" }}} End phpactor
" Javascript Plugins {{{

"highlight jsx in .js files too.
let g:jsx_ext_required = 0

" }}} End Javascript Plugins
" Indent guide {{{ "

" disable automatic colors, will use colorscheme settings
let g:indent_guides_auto_colors=0

"size to be one space
let g:indent_guides_guide_size=1

" }}} Indent guide "
" Ale {{{ "
let g:ale_javascript_eslint_use_global = 0

let g:ale_linters = {
      \   'php': ['phpcs', 'phpmd'],
      \   'javascript': ['eslint'],
      \   'javascript.jsx': ['eslint'],
      \}
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_php_phpcs_standard = 'Drupal'
"
let g:ale_sign_error=''
let g:ale_sign_info=''
let g:ale_sign_warning=''

" }}} Ale "
" tcomment {{{ "
" let g:tcomment_maps=0
let g:tcomment#blank_lines=0
let g:tcomment#strip_on_uncomment=2
let g:tcomment_mapleader1='<F17>'
" }}} tcomment "
" Vimwiki and Markdown {{{ "
" let wiki_1 = {}
" let wiki_1.path = '~/vimwiki'
" let wiki_1.syntax = 'markdown'
" let wiki_1.ext = '.md'
" let wiki_1.conceallevel = 0
" let g:vimwiki_list = [wiki_1]
" let g:vimwiki_global_ext = 0

" list remapping
" map <leader>lc <Plug>VimwikiRemoveSingleCB
" map <leader>ll <Plug>VimwikiToggleListItem
" map <leader>lt :call ShiftTodoDone()<cr>

"don't override tab so deoplete works
" nmap <leader>wn <Plug>VimwikiNextLink
" nmap <leader>wp <Plug>VimwikiPrevLink
"disable table mapping too to make this work
" let g:vimwiki_table_mappings = 0

"remap enter, leave folding stuff as is
" have now reverted folding expansion to c-cr
" nmap <leader>wl <Plug>VimwikiFollowLink
" vmap <leader>wl <Plug>VimwikiFollowLink
" nmap <leader>wr <Plug>VimwikiDeleteLink

" nmap <leader>wd <Plug>VimwikiMakeDiaryNote

"remove mapping VimwikiReturn
" inoremap <F20> VimwikiReturn

" }}}  "
" Completion {{{

" disabled to try coc
" autocmd InsertEnter * call StartDeoplete()
" function! StartDeoplete() abort
"   call deoplete#enable()
"   " call g:deoplete#custom#var('buffer', {'require_same_filetype': v:false})
" endfunction

if !exists('g:context_filetype#same_filetypes')
  let g:context_filetype#same_filetypes = {}
endif

"vista settings
" let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
" let g:vista_sidebar_width = 26
" let g:vista_executive_for = {
"   \ 'php': 'coc',
"   \ }

" let g:vista#renderer#enable_icon = 1

" let g:context_filetype#same_filetypes.yaml = 'yaml.ansible,ansible'

let g:deoplete#enable_at_startup = 0
" this changes the ultisnips matching to get really short ones and use fuzzy matching
" call deoplete#custom#set('ultisnips', 'matchers', ['matcher_fuzzy'])
let g:deoplete#ignore_sources = {'_': ['tag']}
" let g:deoplete#sources = {}
" let g:deoplete#sources.php = ['around', 'member', 'buffer', 'ultisnips']
" let g:deoplete#sources.php = ['member', 'buffer']
" let g:deoplete#sources.php = ['member', 'buffer']
" let g:deoplete#sources.text = ['ultisnips', 'buffer', 'ultisnips', 'dictionary']
let g:deoplete#auto_complete_delay=50
" Use smartcase.
let g:deoplete#enable_smart_case = 1

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

" Undotree {{{ "
nnoremap <leader>u :UndotreeToggle<cr>
" }}} Undotree "
" Colorizer {{{ "
" let g:colorizer_startup=0
" lua require 'colorizer'.setup()
lua require 'colorizer'.setup { 'css'; 'javascript'; html = { mode = 'foreground'; } }
" }}} Colorizer "
" ExpandRegion --------------------------------------------------- {{{

"`il` requires the line texobj plugin.
"`ic` requires the comment texobj plugin.
let g:expand_region_text_objects = {
      \ 'iw'  :0,
      \ 'iW'  :0,
      \ 'i"'  :0,
      \ 'i''' :0,
      \ 'i]'  :1,
      \ 'il'  :1,
      \ 'ib'  :1,
      \ 'iB'  :1,
      \ 'ic'  :0,
      \ 'ip'  :1,
      \ 'ie'  :0,
      \ }

" }}} End ExpandRegion
" EasyMotion, Sneak, Snipe etc. --------------------------------------------------- {{{

"EasyMotion
"turn off default mapping
" let g:EasyMotion_do_mapping = 0

" Jump anywhere via s{char}
" nmap s <Plug>(easymotion-overwin-f)

" Turn on case insensitive feature
" let g:EasyMotion_smartcase = 1

" JK motions: Line motions
" nmap <leader>j <Plug>(easymotion-j)
" nmap <leader>k <Plug>(easymotion-k)

"Sneak
"one key replacement for f and t, breaks macros :(
" nnoremap <silent> f :<C-U>call sneak#wrap('',           1, 0, 1, 1)<CR>
" nnoremap <silent> F :<C-U>call sneak#wrap('',           1, 1, 1, 1)<CR>
" xnoremap <silent> f :<C-U>call sneak#wrap(visualmode(), 1, 0, 1, 1)<CR>
" xnoremap <silent> F :<C-U>call sneak#wrap(visualmode(), 1, 1, 1, 1)<CR>
" onoremap <silent> f :<C-U>call sneak#wrap(v:operator,   1, 0, 1, 1)<CR>
" onoremap <silent> F :<C-U>call sneak#wrap(v:operator,   1, 1, 1, 1)<CR>
" map t <Plug>Sneak_t
" map T <Plug>Sneak_T

" nmap f <Plug>Sneak_f
" nmap F <Plug>Sneak_F

"enable clever sneak, s to go to next
" let g:sneak#s_next = 1

" reset ; and ,
" let g:sneak#f_reset = 1

" easymotion style labeling
let g:sneak#label = 1

" case insensitive match vim settings
let g:sneak#use_ic_scs = 1

" }}} End EasyMotion
" Slime --------------------------------------------------- {{{

let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": "default", "target_pane": "{right}"}

" }}} End Slime
" Highlightedyank --------------------------------------------------- {{{

let g:highlightedyank_highlight_duration=750

" }}} End Highlightedyank
" Startify --------------------------------------------------- {{{

let g:startify_custom_header = [
\ '',
\ '                               ..       ..',
\ '     .uef^"               x .d88"  x .d88"    ..                                  .uef^"',
\ '  :d88E                   5888R    5888R    @L                                 :d88E',
\ '   `888E            .u     `888R    `888R   9888i   .dL       .u          u     `888E',
\ '    888E .z8k    ud8888.    888R     888R   `Y888k:*888.   ud8888.     us888u.   888E .z8k',
\ '    888E~?888L :888`8888.   888R     888R     888E  888I :888`8888. .@88 "8888"  888E~?888L',
\ '    888E  888E d888 `88%"   888R     888R     888E  888I d888 `88%" 9888  9888   888E  888E',
\ '    888E  888E 8888.+"      888R     888R     888E  888I 8888.+"    9888  9888   888E  888E',
\ '    888E  888E 8888L        888R     888R     888E  888I 8888L      9888  9888   888E  888E',
\ '    888E  888E `8888c. .+  .888B .  .888B .  x888N><888` `8888c. .+ 9888  9888   888E  888E',
\ '   m888N= 888>  "88888%    ^*888%   ^*888%    "88"  888   "88888%   "888*""888" m888N= 888>',
\ '    `Y"   888     "YP`       "%       "%            88F     "YP`     ^Y"   ^Y`   `Y"   888',
\ '         J88"                                      98"                                J88"',
\ '         @%                                      ./"                                  @%',
\ '       :"                                       ~`                                  :"',
\ '',
\ '',
\]

" }}} End Startify
" Cleverf --------------------------------------------------- {{{

"only stay on the same line
let g:clever_f_across_no_line=1
let g:clever_f_timeout_ms=3000

" }}} End Cleverf
" Wordmotion --------------------------------------------------- {{{

"make dw and cw work as usual
" nmap dw de
" nmap cw ce

" }}} End Wordmotion
" Doge --------------------------------------------------- {{{
let g:doge_mapping='<LocalLeader>d'
let g:doge_mapping_comment_jump_forward='<c-j>'
let g:doge_mapping_comment_jump_backward='<c-k>'
let g:doge_comment_jump_modes=['i','s']

" }}} End Doge
" AsyncRun --------------------------------------------------- {{{

"Auto open the quickfix with a height when starting asyncrun
let g:asyncrun_open=8

" }}} End AsyncRun
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
" Sandwich --------------------------------------------------- {{{

"stop bad s stuff
nmap s <Nop>
xmap s <Nop>

" }}} End Sandwich
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
" Bullets --------------------------------------------------- {{{

let g:bullets_enabled_file_type = ['markdown', 'text']
let g:bullets_enable_in_empty_buffers = 0
let g:bullets_pad_right = 0
" partial completion
let g:bullets_checkbox_markers = ' .oOX'

" }}} End Bullets
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

" }}} End Plugin settings
" Mappings {{{

" Key escape remapping {{{

" control-enter
set <F13>=[25~
map <F13> <c-cr>
map! <F13> <c-cr>

" shift-enter
" set <F14>=[27~
" map <F14> <s-cr>
" map! <F14> <s-cr>

" control-slash
set <F17>=[31~

" control-period
set <F19>=[33~
map <F19> <c-.>
map! <F19> <c-.>

" control-[ is now f20 via karabiner elements

" commenting
" nnoremap <F17><F17> :TComment<cr>
" nnoremap <F17>b :TCommentBlock<cr>
" nnoremap <F17>i :TCommentInline<cr>
" inoremap <F17><F17> <c-o>:TComment<cr>
" inoremap <F17>b <c-o>:TCommentBlock<cr>
" inoremap <F17>i <c-o>:TCommentInline<cr>
" vnoremap <F17><F17> :TComment<cr>
" vnoremap <F17>b :TCommentBlock<cr>
" vnoremap <F17>i :TCommentInline<cr>
" have now just this via the setting

" }}} End Key escape remapping
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

" This gem will let one run a leader from a command e.g: NormLead ev
function! ExecuteLeader(suffix)
  let l:leader = get(g:,"mapleader","\\")
  if l:leader == ' '
    let l:leader = '1' . l:leader
  endif
  execute "normal ".l:leader.a:suffix
endfunction
command! -nargs=1 NormLead call ExecuteLeader(<f-args>)

" }}} End Easy file opening
" Toggling [leader t*] {{{ "

"toggle guides
nnoremap <silent> <leader>ti :IndentGuidesToggle<cr>

"toggle search highlight
nnoremap <silent> <esc> :nohlsearch<cr>

"toggle line numbers
nnoremap <silent> <leader>tn :setlocal nonumber! norelativenumber!<CR>

"toggle wrapping
nnoremap <silent> <leader>tw :setlocal wrap! breakindent!<CR>

"toggle tagbar
nnoremap <silent> <leader>tt :TagbarToggle<cr>

"toggle list
nnoremap <silent> <leader>tl :LToggle<cr>

"toggle quickfix
nnoremap <silent> <leader>tq :QToggle<cr>

"toggle syntax
nnoremap <leader>ts :ToggleSyntax<cr>

"toggle spelling
nnoremap <silent> <leader>tz :setlocal spell! spelllang=en_au<cr>

"toggle cursor column
nnoremap <silent> <leader>to :setlocal nocuc!<cr>

"toggle colorizer
nnoremap <leader>tc :call ToggleColorizer()<cr>

function! ToggleColorizer()
  if !exists("g:cz_on")
    let g:cz_on=1
  endif
  if g:cz_on == 0
    ColorizerAttachToBuffer
    let g:cz_on = 1
  else
    ColorizerDetachFromBuffer
    let g:cz_on = 0
  endif
endfunction

"toggle color column
function! SetColorColumn()
  if !exists("g:cc_on")
    let g:cc_on=1
  endif
  if g:cc_on == 1
    setlocal cc=81
    let g:cc_on=0
  else
    setlocal cc=
    let g:cc_on=1
  endif
endfunction
nnoremap <silent> <leader>tb :call SetColorColumn()<cr>

" toggle cursor line
" @TODO make this work with inactive windows, exiting insertion etc.
function! SetCursorLine()
  if !exists("g:cl_on")
    let g:cl_on=1
  endif
endfunction
function! ToggleCursorLine()

endfunction
nnoremap <silent> <leader>t- :setlocal cursorline!<cr>

" }}} Toggling "
" Finding [leader f*] {{{ "

"default files
nnoremap <silent> <c-p> :Files<cr>
nnoremap <silent> <leader>ff :AllFiles<cr>

"other stuff
nnoremap <silent> <leader>fh :History<cr>
nnoremap <silent> <leader>fc :Commands<cr>
nnoremap <silent> <leader>fm :Maps<cr>
nnoremap <silent> <leader>T :BTags<cr>
nnoremap <silent> <leader>ft :Tags<cr>
noremap <silent> <c-t> :Tags<cr>
nnoremap <silent> <leader>fb :Buffers<cr>
nnoremap <silent> <leader>fl :BLines<cr>
nnoremap <silent> // :BLines!<cr>

"search through help files
nnoremap <silent> <leader>? :Helptags!<cr>

"search through command history
nnoremap <silent> <leader>: :History:<cr>
"search through search history
nnoremap <silent> <leader>/ :History/<cr>

" }}} Finding "
" Searching and replacing [leader s*] {{{ "

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
nmap <leader>s <Plug>RgRawSearch
nmap <leader>S <Plug>RgRawAllSearch
xmap <leader>s <Plug>RgRawVisualSelection<cr>
nmap <silent> <leader>k <Plug>RgRawWordUnderCursor<cr>
nmap <silent> <leader>K <Plug>RgRawAllWordUnderCursor<cr>

"replace across files
nmap <silent> <leader>R <Plug>(FerretAcks)
" nmap <silent> <leader>

"highlight matches in place with g*, doesn't work?
" nnoremap <silent> g* :let @/='\<'.expand('<cword>').'\>'<CR>
" xnoremap <silent> g* "sy:let @/=@s<CR>

" }}} Searching and replacing [leader s*] "
" Pairs ][ {{{ "

" c-] for in to tags, c-[ for out, free up <c-t> for jump to tag
" set <F18>=[34~
" set <F18>=[17;2~
nnoremap <F18> <c-t>
"apparently this is f18 in tmux?
nnoremap <S-F6> <c-t>

"without this the world dies when <c-,> is hit?
inoremap <F18> <nop>

"add in zooming when going between methods
nnoremap [m [mzz
nnoremap ]m ]mzz

" }}} Pairs "

" yank to end of line, just like shit-d, shift-c
noremap <s-y> y$

"Redo for shift-u
noremap U <c-r>

"preview mappings
nnoremap <leader>vt :PreviewTag<cr>

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


function! ToggleWindowHorizontalVerticalSplit()
  if !exists('t:splitType')
    let t:splitType = 'vertical'
  endif

  if t:splitType == 'vertical' " is vertical switch to horizontal
    windo wincmd K
    let t:splitType = 'horizontal'

  else " is horizontal switch to vertical
    windo wincmd H
    let t:splitType = 'vertical'
  endif
endfunction

"s for `swap` direction
nnoremap <silent> <c-w>s :call ToggleWindowHorizontalVerticalSplit()<cr>

" switch tabs
nnoremap <c-w>n <c-pagedown>
nnoremap <c-w>p <c-pageup>

"focus the current fold
nnoremap z<space> zMzAzz

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
