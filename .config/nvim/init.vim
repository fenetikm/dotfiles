" Set fold marker to {{{}}}
" vim: set fdm=marker fmr={{{,}}} fdl=0 :

" General options --------------------------------------------------- {{{

set nocompatible " disable compatibility with vi
set scrolloff=5 "set number of lines to show above and below cursor
set sidescrolloff=5 " same as scrolloff, but for columns
filetype plugin indent on "use indentation scripts per filetype
set history=9999 "number of lines of history
set cursorline "highlight the line the cursor is on
set clipboard=unnamed "for copy and paste, anonymous register aliased to * register
set autoread "set to auto read when a file is changed from the outside

let mapleader = "\<Space>" "set variable mapleader
let g:mapleader = "\<Space>" "set global variable mapleader see http://stackoverflow.com/a/15685904

set wildmenu "turn on wildmenu, commandline completion
set wildmode=longest:full,full
set wildignore+=.hg,.git,.svn " Version Controls"
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg "Binary Imgs"
set wildignore+=*.sw? "Vim swap files"
set wildignore+=*.DS_Store "OSX SHIT"

set ruler "show column/row/line number position
set number "show line numbers
set relativenumber "set to relative number mode
set cmdheight=2 "height of the command bar
set laststatus=2 "always show status line
set backspace=eol,start,indent "delete over end of line, autoindent, start of insert
set whichwrap+=<,>,h,l,[,] "wrap with cursor keys and h and l

set ignorecase "ignore case when searching
set smartcase "use case searching if uppercase character is included
set hlsearch "highlight search results
set incsearch "incremental search
set magic "regex magic
set showmatch "show matching brackets when text indicator is over them
set mat=2 "how many tenths of a second to blink when matching brackets

set noerrorbells "no annoying beeps
set novisualbell "no screen flashes on errors
set t_vb= "no screen flashes
set timeoutlen=2000 "timeout for leader key
set noshowmode "hide showing which mode we are in, the status bar is fine

syntax enable "enable syntax highlighting

set guifont=Consolas:h10:cANSI

if has("gui_running")
	set guioptions-=T "remove toolbar"
  set guioptions+=e "add tab pages
  set guioptions-=r "remove right hand scrollbar
	set guioptions-=R "remove split window right hand scrollbar
  set guioptions-=l "remove left hand scrollbar
	set guioptions-=L "remove split window left hand scrollbar
	set t_Co=256 "enable 256 colors
	set guitablabel=%M\ %t
endif

set encoding=utf-8 "set utf8 as standard encoding

set hidden "hide buffers instead of closing them

set expandtab "substitute tabs with spaces
set smarttab "be smart about using tabs, delete that many spaces when appropriate
set shiftwidth=2 "how far to shift with <,>
set tabstop=2 "how many columns does a tab count for
set lbr "enable linebreaking
set tw=500 "set textwidth to 500 to auto linebreak with really long lines
set autoindent "copy indentation from line above
"set smartindent "indent if not handled by plugins, disabled since plugins!
set wrap "wrap visually, don't actually change the file
set list                              " show whitespace
set listchars=nbsp:⦸                  " CIRCLED REVERSE SOLIDUS (U+29B8, UTF-8: E2 A6 B8)
set listchars+=tab:▷┅                 " WHITE RIGHT-POINTING TRIANGLE (U+25B7, UTF-8: E2 96 B7)
                                      " + BOX DRAWINGS HEAVY TRIPLE DASH HORIZONTAL (U+2505, UTF-8: E2 94 85)
set listchars+=extends:»              " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00BB, UTF-8: C2 BB)
set listchars+=precedes:«             " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00AB, UTF-8: C2 AB)
set listchars+=trail:•                " BULLET (U+2022, UTF-8: E2 80 A2)
set nojoinspaces                      " don't autoinsert two spaces after '.', '?', '!' for join command
" old version is below, above from @wincent
" set listchars=tab:›\ ,trail:X,extends:#,nbsp:. "characters to use when showing formatting characters
" format trailing whitespace as if it was in error state
match ErrorMsg '\s\+$'

set shortmess+=A                      " ignore annoying swapfile messages
set shortmess+=O                      " file-read message overwrites previous
set shortmess+=T                      " truncate non-file messages in middle
set shortmess+=W                      " don't echo "[w]"/"[written]" when writing
set shortmess+=a                      " use abbreviations in messages eg. `[RO]` instead of `[readonly]`
set shortmess+=o                      " overwrite file-written messages
set shortmess+=t                      " truncate file messages at start

if has('linebreak')
  let &showbreak='↳ '                 " DOWNWARDS ARROW WITH TIP RIGHTWARDS (U+21B3, UTF-8: E2 86 B3)
endif

if has('virtualedit')
  set virtualedit=block               " allow cursor to move where there is no text in visual block mode
endif

set fileformat=unix "default fileformat

" set python3 host program location
let g:python3_host_prog = '/usr/local/bin/python3'

" turn on matchit which extends % key matching
runtime macros/matchit.vim

" }}} End General options
" Filetypes --------------------------------------------------- {{{

" Drupal / PHP --------------------------------------------------- {{{

if has("autocmd")
    augroup module
        autocmd BufRead,BufNewFile *.module set filetype=php
        autocmd BufRead,BufNewFile *.theme set filetype=php
        autocmd BufRead,BufNewFile *.install set filetype=php
        autocmd BufRead,BufNewFile *.test set filetype=php
        autocmd BufRead,BufNewFile *.inc set filetype=php
        autocmd BufRead,BufNewFile *.profile set filetype=php
        autocmd BufRead,BufNewFile *.view set filetype=php
        autocmd BufRead,BufNewFile *.php set filetype=php
    augroup END
endif

"run Neomake on php files on save
function! RunAutoPHP()
  Neomake phpcs
endfunction

autocmd! BufWritePost * call RunAutoPHP()

" set omni for php
" au FileType php set omnifunc=phpcomplete#CompletePHP

" }}} End Drupal / PHP

au BufNewFile,BufRead *.as set filetype=actionscript

" }}} End Filetypes
" Buffer handling --------------------------------------------------- {{{

" Make sure Vim returns to the same line when you reopen a file.
augroup line_return
  au!
  au BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \     execute 'normal! g`"zvzz' |
      \ endif
augroup END

" Remember info about open buffers on close
set viminfo^=%

"turn off the cursorline when not in a window
autocmd InsertLeave,WinEnter * set cursorline
autocmd InsertEnter,WinLeave * set nocursorline

"refresh screen that turns off highlights, fix syntax highlight etc.
"@TODO fix this
" nnoremap <leader>l :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>

" }}} End Buffer handling
" Helper functions --------------------------------------------------- {{{

function! TrimWhiteSpace()
    %s/\s\+$//e
endfunction

function! SearchWordWithAg()
    execute 'Ag' expand('<cword>')
endfunction

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

function! DeleteInactiveBufs()
    "From tabpagebuflist() help, get a list of all buffers in all tabs
    let tablist = []
    for i in range(tabpagenr('$'))
        call extend(tablist, tabpagebuflist(i + 1))
    endfor

    "Below originally inspired by Hara Krishna Dara and Keith Roberts
    "http://tech.groups.yahoo.com/group/vim/message/56425
    let nWipeouts = 0
    for i in range(1, bufnr('$'))
        if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
        "bufno exists AND isn't modified AND isn't in the list of buffers open in windows and tabs
            silent exec 'bwipeout' i
            let nWipeouts = nWipeouts + 1
        endif
    endfor
    echomsg nWipeouts . ' buffer(s) wiped out'
endfunction
command! Bdi :call DeleteInactiveBufs()

" Function to start profiling commmands
function! StartProfile()
  profile start profile.log
  profile func *
  profile file *
endfunction

command! StartProfile call StartProfile()

function! StopProfile()
  profile pause
  " noautocmd qall!
endfunction

command! StopProfile call StopProfile()

nmap <C-S-C> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" }}} End Helper functions
" Plugins --------------------------------------------------- {{{

call plug#begin()

" Global, system, movement --------------------------------------------------- {{{

Plug 'tpope/vim-surround' "change surrounding characters
Plug 'SirVer/ultisnips' "ultisnips snippets
Plug 'honza/vim-snippets' "snippets library
Plug 'tpope/vim-dispatch' "async dispatching
Plug 'radenling/vim-dispatch-neovim' "dispatch for neovim
Plug 'neomake/neomake' "async syntax checking
Plug 'ludovicchabant/vim-gutentags' "tag generation
Plug 'rizzatti/dash.vim' "lookup a word in dash
" Plug 'easymotion/vim-easymotion' "vimperator style jumping around
Plug 'embear/vim-localvimrc' "local vimrc
Plug 'dbakker/vim-projectroot' "project root stuff
Plug 'cohama/lexima.vim' "auto closing pairs
Plug 'terryma/vim-expand-region' "expand region useful for selection
" Plug 'AndrewRadev/splitjoin.vim' "convert single/multi line code expressions
" Plug 'breuckelen/vim-resize' "resize splits
Plug 'benmills/vimux' "Interact with tmux from vim
" Plug 'tpope/vim-eunuch' "Better unix commands
Plug 'tpope/vim-unimpaired' "Various dual pair commands

" }}} End Global, system, movement
" Interface, fuzzy handling --------------------------------------------------- {{{

" Plug 'bling/vim-airline' "improved status line
"Plug 'ctrlpvim/ctrlp.vim' "fuzzy file searching
" Plug 'Numkil/ag.nvim' "ag for nvim
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } "fuzzy finder
Plug 'junegunn/fzf.vim' "fuzzy finder stuff
Plug 'airblade/vim-gitgutter' "place git changes in the gutter
Plug 'tpope/vim-fugitive' "git management
Plug 'kshenoy/vim-signature' "marks handling
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } "autocomplete
" Plug 'Valloric/YouCompleteMe', { 'do': './install.py' } "youcompleteme omnicomplete
Plug 'Valloric/ListToggle' "toggle quickfix and location lists
" Plug 'majutsushi/tagbar' "tagbar
" Plug 'vim-php/tagbar-phpctags.vim' "tagbar phpctags
Plug 'mhinz/vim-startify' "startify
Plug 'scrooloose/nerdtree' "nerdtree file tree explorer
Plug 'Xuyuanp/nerdtree-git-plugin' "nerdtree git plugin
Plug 'ryanoasis/vim-devicons' "icons using the nerd font
" Plug 'junegunn/vim-emoji' "emojis for vim
" Plug 'yuttie/comfortable-motion.vim' "Nice scrolling in vim

" }}} End Interface, fuzzy handling
" Syntax --------------------------------------------------- {{{

Plug 'plasticboy/vim-markdown' "markdown handling
Plug 'cakebaker/scss-syntax.vim' "scss syntax
Plug 'evidens/vim-twig' "twig syntax
Plug 'jeroenbourgois/vim-actionscript' "actionscript syntax
Plug 'elzr/vim-json' "better json syntax
Plug 'ap/vim-css-color' "css color preview

" }}} End Syntax 
" Coding, text objects --------------------------------------------------- {{{

Plug 'tomtom/tcomment_vim' "commenting
Plug 'sniphpets/sniphpets' "php snippets
Plug 'sniphpets/sniphpets-common' "php snippets
Plug 'gerw/vim-HiLinkTrace' "show syntax color groups
Plug '2072/PHP-Indenting-for-VIm' "updated indenting
" Plug 'paulyg/Vim-PHP-Stuff' "updated php syntax
Plug 'StanAngeloff/php.vim', { 'for': 'php' } "More updatd php syntax
Plug 'arnaud-lb/vim-php-namespace' "insert use statements automatically
" Plug 'Rican7/php-doc-modded' "insert php doc blocks
Plug 'adoy/vim-php-refactoring-toolbox' "php refactoring
Plug 'tobyS/vmustache' "mustache templater for pdv
Plug 'tobyS/pdv' "php documenter
Plug 'rayburgemeestre/phpfolding.vim' "php folding
Plug 'alvan/vim-php-manual' "php manual
" Plug 'sickill/vim-pasta' "paste with indentation
Plug 'joonty/vdebug' "debugger
" Plug '~/.config/nvim/eclim' "eclim for completion
" Plug 'lvht/phpcd.vim', { 'for': 'php', 'do': 'composer update' }
" Plug 'przepompownia/phpcd.vim', { 'for': 'php', 'do': 'composer update' }
Plug 'joonty/vim-phpunitqf' "PHPUnit runner
Plug 'janko-m/vim-test' "Test runner
Plug 'wellle/targets.vim' "Additional target text objects
" Plug 'kana/vim-textobj-function' "function textobj , buggy...
" Plug 'michaeljsmith/vim-indent-object' "indentation text objects
" Plug 'padawan-php/deoplete-padawan' "deoplete padawan completion
" Plug 'm2mdas/phpcomplete-extended-symfony' "phpcomplete symfony (drupal)
" Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
" Disabled, not sure if worth it.
" Plug 'Shougo/echodoc.vim' "prints completion in echo area

" }}} End Coding, text objects
" To try --------------------------------------------------- {{{

" Plug 'tpope/vim-eunuch' "unix commands
" Plug 'tpope/vim-characterize' "character codes and emoji codes. html entities
Plug 'janko-m/vim-test' "testing at diff granularities
" Plug 'itchyny/calendar.vim' "calendar, integrate with GCal?!
" Plug 'chrisbra/csv.vim' "CSV file syntax and commands
" Plug 'Shougo/vinarise.vim' "Hex editor
" Plug 'lambdalisue/gina.vim' "Alternative git plugin
" Plug 'lambdalisue/vim-gista' "Messing with gists
" Plug 'mbbill/undotree ' "Undo tree
" Plug 'tpope/vim-repeat' "Repeat plugin commands
" Plug 'phpstan/vim-phpstan' "PHP static analysis
" Plug 'ntpeters/vim-better-whitespace' "whitespace handing
" Plug 'tpope/vim-scriptease' "vim script helper functions
" Plug 'mkitt/browser-refresh.vim' "Refresh browser from vim

" }}} End To try plugins
" Colors --------------------------------------------------- {{{

Plug 'flazz/vim-colorschemes' "colorscheme pack
Plug 'AlessandroYorba/Monrovia'
Plug 'AlessandroYorba/Sidonia'
Plug 'AlessandroYorba/Despacio'
Plug 'sjl/badwolf'
Plug 'davidklsn/vim-sialoquent'
Plug 'croaker/mustang-vim'
Plug 'vim-airline/vim-airline-themes'
Plug 'gosukiwi/vim-atom-dark'
Plug 'fcpg/vim-orbital'
Plug 'jonathanfilip/vim-lucius'
Plug 'liuchengxu/space-vim-dark'
Plug 'whatyouhide/vim-gotham'

" }}} End Colors

call plug#end()

" }}} End Plugins
" Plugin settings --------------------------------------------------- {{{

" FZF, CtrlP, Ag --------------------------------------------------- {{{

nnoremap <C-p> :GitFiles<cr>
" for some reason :Buffers is giving me something funky from elsewhere...
nnoremap <leader>b :call fzf#vim#buffers()<cr>
nnoremap <leader>f :Files<cr>
" Given this up for the testing namespace
" nnoremap <leader>t :Tags<cr>
" nnoremap <C-r> :History<cr>
nnoremap <silent> \ :Ag<space>

"line completion
imap <c-x><c-l> <plug>(fzf-complete-line)

" match splitting to ctrl-w splitting
let g:fzf_action = {
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

" change the color path of the Ag output
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>, '--color-path 400', fzf#vim#default_layout)

"don't jump to an open buffer, reopen
let g:fzf_buffers_jump=0

" Add in custom :Find command which will use ripgrep
" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

function! s:ProcessMyCommand(l)
  let keys = split(a:l, ':\t')
  let command_parts = split(keys[0], '|')
  let command_function = split(command_parts[1], '#')
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
      "Extra space for after prompt
      execute 'call VimuxPromptCommand("'.command_bin.trimmed_function[0].' ")'
    else
      execute 'call VimuxRunCommand("'.command_bin.command_function[0].'")'
    endif
  elseif command_parts[0] == 'vc'
    "vim call
    execute 'call '.command_function[0]
  elseif command_parts[0] == 'op'
    execute '!open '.command_function[0]
  else
    "just do whatever it says
    execute command_function[0]
  endif
endfunction

"Pull in from *.cmd files from current directory and home nvim config directory.
command! -bang -nargs=* MyCommands call fzf#run({'sink': function('<sid>ProcessMyCommand'), 'source': 'cat '.$HOME.'/.config/nvim/*.cmd *.cmd 2>/dev/null'})
nnoremap <c-c> :MyCommands<cr>

"ctrlp settings
" let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
" let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
" let g:ctrlp_prompt_mappings = {
"   \ 'PrtSelectMove("j")':   ['<c-j>', '<down>'],
"   \ 'PrtSelectMove("k")':   ['<c-k>', '<up>'],
"   \ 'PrtSelectMove("t")':   ['<Home>', '<kHome>'],
"   \ 'PrtSelectMove("b")':   ['<End>', '<kEnd>'],
"   \ 'PrtSelectMove("u")':   ['<PageUp>', '<kPageUp>'],
"   \ 'PrtSelectMove("d")':   ['<PageDown>', '<kPageDown>'],
"   \ }
" " disable jumping to window if file already open, will always open
" let g:ctrlp_switch_buffer = "0"
" nnoremap <leader>t :CtrlPTag<cr>
" nnoremap <leader>tj :CtrlPTag<cr><C-r><C-w><cr>
" " @todo need to fix buffer to work with ag
" nnoremap <leader>b :CtrlPBuffer<cr>

"silver searcher stuff, replaced with fzf
" if executable('ag')
"   set grepprg=ag\ --nogroup\ --nocolor " Use ag over grep
"   let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""' " Use ag in CtrlP for listing files
"   let g:ctrlp_use_caching = 0 " ag is fast enough that CtrlP doesn't need to cache
" endif

" let g:ag_working_path_mode='r' "set ag to run from project root by default
" "search for word under cursor
" nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
" "map \ to LAg (Ag using the location-list)
" nnoremap \ :LAg!<SPACE>

" }}} End FZF, CtrlP, Ag
" Status line --------------------------------------------------- {{{

"turn on airline to use patched style fonts
let g:airline_powerline_fonts = 1

" }}} End Status line
" NERDTree --------------------------------------------------- {{{

"map ctrl-e to show nerdtree
map <C-e> :NERDTreeToggle<CR>

"width
let g:NERDTreeWinSize=40

" Disable display of '?' text and 'Bookmarks' label.
let g:NERDTreeMinimalUI=1

" }}} End NERDTree
" NeoMake --------------------------------------------------- {{{

" neomake syntax checking
let g:neomake_php_phpcs_args_standard = 'Drupal'

" }}} End NeoMake
" ListToggle --------------------------------------------------- {{{

let g:lt_location_list_toggle_map = '<leader>l'
let g:lt_quickfix_list_toggle_map = '<leader>q'

" }}} End ListToggle
" EasyMotion --------------------------------------------------- {{{

let g:EasyMotion_do_mapping = 0 "Disable default mappings
let g:EasyMotion_smartcase = 1 "Enable smartcase like vim
nmap s <Plug>(easymotion-overwin-f)
nmap <leader>w <Plug>(easymotion-w)
map  <leader>w <Plug>(easymotion-bd-w)
nmap <leader>w <Plug>(easymotion-overwin-w)

" }}} End EasyMotion
" UltiSnips --------------------------------------------------- {{{

"directory for my snippets
let g:UltiSnipsSnippetsDir="~/.config/nvim/UltiSnips"
"open edit in vertical split
let g:UltiSnipsEditSplit="vertical"
"in select mode hit ctrl-u to delete the whole line
snoremap <C-u> <Esc>:d1<cr>i

" }}} End UltiSnips
" Deoplete --------------------------------------------------- {{{

" let g:EclimCompletionMethod = 'omnifunc'
let g:deoplete#enable_at_startup = 1
" this changes the ultisnips matching to get really short ones
" call deoplete#custom#set('ultisnips', 'matchers', ['matcher_fuzzy'])
let g:deoplete#sources = {}
" let g:deoplete#omni#input_patterns.php = '\w*|[^. \t]->\w*|\w*::\w*'
let g:deoplete#sources.php = ['buffer', 'member', 'ultisnips']
let g:deoplete#sources.text = ['buffer', 'ultisnips', 'dictionary']
" let deoplete#tag#cache_limit_size = 50000000
let g:deoplete#auto_complete_delay=50
" close the preview window automatically.
" autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
"
" Use smartcase.
let g:deoplete#enable_smart_case = 1

" stop insertion, match with the longest common match, still show if one option
set completeopt=longest,menuone
" hide the preview window
set completeopt-=preview

" inoremap <silent><expr><tab> pumvisible() ? deoplete#close_popup() : "\<TAB>"

" if menu is showing then hitting enter will select the items
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" these keeps the menu showing as you type
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

let g:echodoc_enable_at_startup=1

" function IniEclim()
" 	if !filereadable("~/Documents/workspace/.metadata/.lock")
"     execute '!~/Eclipse.app/Contents/Eclipse/eclimd &> /dev/null &'
"     autocmd Filetype php setlocal omnifunc=eclim#php#complete#CodeComplete
" 	endif
" :endfunction
" command! -nargs=* IniEclim call IniEclim()

" the below is phpcd stuff, maybe one day.
" let g:deoplete#ignore_sources = get(g:, 'deoplete#ignore_sources', {})
" let g:deoplete#ignore_sources.php = ['omni']

" }}} End Deoplete
" Fugitive --------------------------------------------------- {{{

nnoremap <leader>ga :Git add %:p<cr><cr>
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gc :Gcommit -v -q<cr>
nnoremap <leader>gt :Gcommit -v -q %:p<cr>
nnoremap <leader>gd :Gvdiff<cr>
nnoremap <leader>ge :Gedit<cr>
nnoremap <leader>gr :Gread<cr>
nnoremap <leader>gw :Gwrite<cr><cr>
nnoremap <leader>gl :silent! Glog<cr>:bot copen<cr>
" nnoremap <leader>gp :Gpush<cr>
nnoremap <leader>gm :Gmove<leader>
nnoremap <leader>gb :Git branch<leader>
nnoremap <leader>go :Git checkout<leader>
nnoremap <leader>gps :Dispatch! git push<cr>
nnoremap <leader>gpl :Dispatch! git pull<cr>

" }}} End Fugitive
" Dash --------------------------------------------------- {{{

"open word under cursor in dash, by default uses filetype
nnoremap <leader>da :Dash<cr>
"specify these since filetype might be either or
nnoremap <leader>dd :Dash <C-r><C-w> drupal<cr>
nnoremap <leader>dp :Dash <C-r><C-w> php<cr>

" }}} End Dash
" Tag plugins --------------------------------------------------- {{{

"gutentags
let g:gutentags_ctags_exclude=['*.json', '*.css', '*.html', '*.sh', '*.yml', '*.html.twig', '*.sql', '*.md']
let g:gutentags_file_list_command='find vendor/symfony vendor/symfony-cmf vendor/twig vendor/psr app -type f'

"tagbar
nmap <leader>tt :TagbarToggle<cr>

" }}} End Tag plugins
" PHP plugins --------------------------------------------------- {{{
"
"padawan completion server
" command! StartPadawan call deoplete#sources#padawan#StartServer()
" command! StopPadawan call deoplete#sources#padawan#StopServer()
" command! RestartPadawan call deoplete#sources#padawan#RestartServer()

"php folding
nnoremap <leader>pz :EnablePHPFolds<cr>
nnoremap <leader>pzd :DisablePHPFolds<cr>

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

" Let's disable these since I think they are also causing mischief
" autocmd FileType php inoremap <leader>pu <Esc>:call IPhpInsertUse()<cr>
" autocmd FileType php inoremap <leader>pe <Esc>:call IPhpExpandClass()<cr>
autocmd FileType php noremap <leader>pu :call PhpInsertUse()<cr>
autocmd FileType php noremap <leader>pe :call PhpExpandClass()<cr>

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

" }}} End PHP plugins
" Debug plugins --------------------------------------------------- {{{

"debugging
function! SetupDebug()
  let g:vdebug_options['ide_key']='PHPSTORM'
  let g:vdebug_options['port']=9001
  let g:vdebug_options['path_maps']={'/web': call('projectroot#get', a:000)}
endfunction
nmap <leader>xd :call SetupDebug()<cr>

function! RemapDebug()
  let g:vdebug_keymap = {
    \    "run" : "<leader>xr",
    \    "run_to_cursor" : "<leader>xc",
    \    "step_over" : "<leader>xo",
    \    "step_into" : "<leader>xi",
    \    "step_out" : "<leader>xu",
    \    "close" : "<leader>xx",
    \    "detach" : "<leader>xt",
    \    "set_breakpoint" : "<leader>xb",
    \    "get_context" : "<leader>xg",
    \    "eval_under_cursor" : "<leader>xe",
    \    "eval_visual" : "<leader>xv",
    \}
endfunction
nmap <leader>xrd :call RemapDebug()<cr>

" }}} End Debug plugins
" Vimux --------------------------------------------------- {{{

"vimux stuff
let g:VimuxHeight="15"
"vagrant
nnoremap <leader>vs :VimuxRunCommand("vagrant ssh")<cr>
nnoremap <leader>vu :VimuxRunCommand("vagrant up")<cr>
nnoremap <leader>vh :VimuxRunCommand("vagrant halt")<cr>
nnoremap <leader>vc :VimuxRunCommand("bin/drush -r app cr")<cr>
nnoremap <leader>vd :VimuxPromptCommand("bin/drush -r app ")<cr>
nnoremap <leader>vv :VimuxPromptCommand("vagrant ")<cr>
nnoremap <leader>vp :VimuxPromptCommand<cr>
nnoremap <leader>vx :VimuxCloseRunner<cr>
nnoremap <leader>vo :VimuxOpenPane<cr>
nnoremap <leader>vl :VimuxRunLastCommand<cr>
"
" drupal vagrant shortcuts
nnoremap <leader>drc :VimuxRunCommand('vagrant ssh -c "/vagrant/bin/drush -r /vagrant/app cr"')<cr>
" nnoremap <leader>drc :!vagrant ssh -c "/vagrant/bin/drush -r /vagrant/app cr"<cr>
nnoremap <leader>drd :!vagrant ssh -c "/home/vagrant/.composer/vendor/bin/robo dev:twig-debug-disable"<cr>
nnoremap <leader>dre :!vagrant ssh -c "/home/vagrant/.composer/vendor/bin/robo dev:twig-debug-enable"<cr>


" }}} End Vimux
" Splitjoin --------------------------------------------------- {{{

"splitjoin
" let g:splitjoin_split_mapping = ''
" let g:splitjoin_join_mapping = ''
" nnoremap ss :SplitjoinSplit<cr>
" nnoremap sj :SplitjoinJoin<cr>

" }}} End Splitjoin
" Local vimrc --------------------------------------------------- {{{

let g:localvimrc_ask=0 "don't ask to load local version
let g:localvimrc_sandbox=0 "don't load in sandbox (security)
let g:localvimrc_name=['.lvimrc'] "name of the local vimrc

" }}} End Local vimrc
" Emojis --------------------------------------------------- {{{

" if emoji#available()
"   let g:gitgutter_sign_added = emoji#for('small_blue_diamond')
"   let g:gitgutter_sign_modified = emoji#for('small_orange_diamond')
"   let g:gitgutter_sign_removed = emoji#for('small_red_triangle')
"   let g:gitgutter_sign_modified_removed = emoji#for('collision')
" endif

" }}} End Emojis
" Resize splits --------------------------------------------------- {{{

" @todo need to work out the sending of escape sequences...
let g:vim_resize_disable_auto_mappings = 1

" }}} End Resize splits
" Testing --------------------------------------------------- {{{

" let g:test#runner_commands = ['PHPUnit', 'Codeception']
let test#php#codeception#executable = 'vbin/codecept'
nnoremap <leader>tf :TestFile -strategy=vimux --steps<cr>
nnoremap <leader>ts :TestSuite -strategy=vimux --steps --html<cr>
nnoremap <leader>tl :TestLast -strategy=vimux --steps<cr>

" }}} End Testing

" }}} End Plugin settings
" Statusline --------------------------------------------------- {{{

let g:currentmode={
    \ 'n'  : 'N ',
    \ 'no' : 'N·Operator Pending ',
    \ 'v'  : 'V ',
    \ 'V'  : 'V·Line ',
    \ '^V' : 'V·Block ',
    \ 's'  : 'Select ',
    \ 'S'  : 'S·Line ',
    \ '^S' : 'S·Block ',
    \ 'i'  : 'I ',
    \ 'R'  : 'R ',
    \ 'Rv' : 'V·Replace ',
    \ 'c'  : 'Command ',
    \ 'cv' : 'Vim Ex ',
    \ 'ce' : 'Ex ',
    \ 'r'  : 'Prompt ',
    \ 'rm' : 'More ',
    \ 'r?' : 'Confirm ',
    \ '!'  : 'Shell ',
    \ 't'  : 'Terminal '
    \}

" Automatically change the statusline color depending on mode
function! ChangeStatuslineColor()
  if (mode() =~# '\v(n|no)')
    exe 'hi! StatusLine ctermfg=008'
  elseif (mode() =~# '\v(v|V)' || g:currentmode[mode()] ==# 'V·Block' || get(g:currentmode, mode(), '') ==# 't')
    exe 'hi! StatusLine ctermfg=005'
  elseif (mode() ==# 'i')
    exe 'hi! StatusLine ctermfg=004'
  else
    exe 'hi! StatusLine ctermfg=006'
  endif

  return ''
endfunction

" Find out current buffer's size and output it.
function! FileSize()
  let bytes = getfsize(expand('%:p'))
  if (bytes >= 1024)
    let kbytes = bytes / 1024
  endif
  if (exists('kbytes') && kbytes >= 1000)
    let mbytes = kbytes / 1000
  endif

  if bytes <= 0
    return '0'
  endif

  if (exists('mbytes'))
    return mbytes . 'MB '
  elseif (exists('kbytes'))
    return kbytes . 'KB '
  else
    return bytes . 'B '
  endif
endfunction

function! ReadOnly()
  if &readonly || !&modifiable
    return ''
  else
    return ''
endfunction

function! GitInfo()
  let git = fugitive#head()
  if git != ''
    return ' '.fugitive#head()
  else
    return ''
endfunction

set laststatus=2
set statusline=
set statusline+=%{ChangeStatuslineColor()}               " Changing the statusline color
set statusline+=%0*\ %{toupper(g:currentmode[mode()])}   " Current mode
set statusline+=%8*\ [%n]                                " buffernr
set statusline+=%8*\ %{GitInfo()}                        " Git Branch name
set statusline+=%8*\ %<%F\ %{ReadOnly()}\ %m\ %w\        " File+path
set statusline+=%#warningmsg#
set statusline+=%*
set statusline+=%9*\ %=                                  " Space
set statusline+=%8*\ %y\                                 " FileType
" Encoding & Fileformat
set statusline+=%7*\ %{(&fenc!=''?&fenc:&enc)}\[%{&ff}]\
set statusline+=%8*\ %-3(%{FileSize()}%)                 " File size
set statusline+=%0*\ %3p%%\ \ %l:\ %3c\                 " Rownumber/total (%)

"Custom user colours
hi User1 ctermfg=007
hi User2 ctermfg=008
hi User3 ctermfg=008
hi User4 ctermfg=008
hi User5 ctermfg=008
hi User7 ctermfg=008
hi User8 ctermfg=008
hi User9 ctermfg=007

" }}} End Statusline
" Mappings --------------------------------------------------- {{{

" Movement --------------------------------------------------- {{{

"treat long lines as break lines
map j gj
map k gk

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

" Fast switching between splits
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

" }}} End Movement

"tab to toggle folding
nnoremap <Tab> za

"I like this idea, would be good to use the hyper and j/k to do this.
nnoremap <silent> <Up> :cprevious<CR>
nnoremap <silent> <Down> :cnext<CR>

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

"jump to end when inserting
inoremap <c-e> <c-o>$
"jump one character right in insert (this overwrites digraph entry)
inoremap <c-k> <c-o>k

" always search forward for n, always backward for N
" @TODO conflicts with the centering thingy
" nnoremap <expr> n  'Nn'[v:searchforward]
" nnoremap <expr> N  'nN'[v:searchforward]

"remap visual for put and get
xnoremap dp :diffput<cr>
xnoremap do :diffget<cr>
nnoremap du :diffupdate<cr>

"easier begin and end of line
nnoremap <s-b> ^
nnoremap <s-e> $

"ev to edit vimrc, sv to source vimrc
nmap <silent> <leader>ev :vsplit $MYVIMRC<cr>
nmap <silent> <leader>sv :so $MYVIMRC<cr>

"quick editing
nnoremap <leader>ed :vsplit ~/.drush/aliases.drushrc.php<cr>
nnoremap <leader>et :vsplit ~/.tmux.conf<cr>
nnoremap <leader>ek :vsplit ~/.config/karabiner/karabiner.json<cr>
nnoremap <leader>eh :vsplit ~/.hammerspoon/init.lua<cr>
nnoremap <leader>ez :vsplit ~/.zshrc<cr>
nnoremap <leader>eu :UltiSnipsEdit<cr>

"move lines up and down
nnoremap <leader>k :m-2<cr>==
nnoremap <leader>j :m+<cr>==
xnoremap <leader>k :m-2<cr>gv=gv
xnoremap <leader>j :m'>+<cr>gv=gv

"close the preview window with leader z
nmap <leader>z :pclose<cr>

" Use CTRL-S for saving, also in Insert mode
noremap <C-S> :update<cr>
vnoremap <C-S> <C-C>:update<cr>
inoremap <C-S> <C-O>:update<cr>

" quit all
nnoremap ZQ :qa!<cr>
" map w!! to sudo save
cmap w!! w !sudo tee % >/dev/null

"fast quit
noremap <C-q> :quit<cr>
noremap <C-x> :quit<cr>

"disable accidental Ex mode
nnoremap Q <nop>

"region expanding
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

"fast escape
inoremap jk <Esc>

" }}} End Mappings
" Colors --------------------------------------------------- {{{

"24bit color
set termguicolors
"dark
set background=dark
" colorscheme mustang
" colorscheme lucius
" LuciusBlack
let g:airline_theme='tomorrow'
colorscheme gruvbox
let g:gruvbox_italic=1
let g:gruvbox_contrast_dark='hard'

"colorscheme customisation
hi NeomakeWarningSignAlt ctermfg=255 gui=none guifg=#ffffff guibg=#202020
let g:neomake_warning_sign={'text': '⚠', 'texthl': 'NeomakeWarningSignAlt'}

"set comments to italic
highlight Comment cterm=italic

" }}} End Colors
