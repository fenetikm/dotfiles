" File: vimrc.
" Author: Michael Welford.

" General Options: {{{

set nocompatible " disable compatibility with vi
set scrolloff=5 "set number of lines to show above and below cursor
set sidescrolloff=5 " same as scrolloff, but for columns
filetype plugin indent on "use indentation scripts per filetype
set history=999 "number of lines of history
set cursorline "highlight the line the cursor is on
set clipboard=unnamed "for copy and paste, anonymous register aliased to * register
set autoread "set to auto read when a file is changed from the outside
set report=0 "Always report line changes
set mouse=nv " mouse only enabled in normal and visual
set noshowcmd "hide the command showing in the status
set nrformats= "force decimal-based arithmetic
set termguicolors "24bitcolors

let mapleader = "\<Space>" "set variable mapleader
let g:mapleader = "\<Space>" "set global variable mapleader see http://stackoverflow.com/a/15685904
let maplocalleader = ","

" Wildmenu {{{ "

set wildmenu "turn on wildmenu, commandline completion
set wildmode=longest:full,full
set wildignore+=.hg,.git,.svn " Version Controls"
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg "Binary Imgs"
set wildignore+=*.sw? "Vim swap files"
set wildignore+=*.DS_Store "OSX SHIT"
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=vendor/cache/**
set wildignorecase

" }}} Wildmenu "

set ruler "show column/row/line number position
set number "show line numbers
set relativenumber "set to relative number mode
set cmdheight=2 "height of the command bar
set laststatus=2 "always show status line
set backspace=eol,start,indent "delete over end of line, autoindent, start of insert
set whichwrap+=<,>,h,l,[,] "wrap with cursor keys and h and l
" set nowrapscan "don't wrap search scanning

" Search {{{ "

set infercase "adjust case when searching
set ignorecase "ignore case when searching
set smartcase "use case searching if uppercase character is included
set hlsearch "highlight search results
set incsearch "incremental search
set inccommand=nosplit "incremental replace
set magic "regex magic, more useable
set showmatch "show matching brackets when text indicator is over them
set mat=2 "how many tenths of a second to blink when matching brackets
set gdefault "substitute all in line or everywhere depending

" }}} Search "

set noerrorbells "no annoying beeps
set novisualbell "no screen flashes on errors
set t_vb= "no screen flashes
set timeoutlen=1000 "timeout for leader key
set ttimeoutlen=5 "timeout for key code delays
set noshowmode "hide showing which mode we are in, the status bar is fine

set fcs=vert:│ " Solid line for vsplit separator

set splitbelow "horizontal split shows up below
set previewheight=10

syntax enable "enable syntax highlighting

set guifont=FiraCode-Regular:h14

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
set breakindent "indent lines that are broken
set breakindentopt=shift:1 "set the indent shift to one space
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

set fillchars=vert:┃
set fillchars+=fold:
" set fillchars+=fold:<space>
"folding stuff
set foldmethod=indent "indent method
set foldlevelstart=99 "start unfolded
set foldtext=Customfoldtext()
set foldnestmax=10

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

set synmaxcol=600                     " Don't try to highlight lines longer than 600 characters.

if has('linebreak')
  let &showbreak='↳'                 " DOWNWARDS ARROW WITH TIP RIGHTWARDS (U+21B3, UTF-8: E2 86 B3)
endif

if has('virtualedit')
  set virtualedit=block               " allow cursor to move where there is no text in visual block mode
endif

set fileformat=unix "default fileformat

" set python3 host program location
let g:python3_host_prog = '/usr/local/bin/python3'

"set python2 host program location
let g:python_host_prog = '/usr/local/bin/python2'

" turn on matchit which extends % key matching
runtime macros/matchit.vim

"set the max time to update 200ms, gitgutter mainly
set updatetime=200

" }}} End General options
" Filetypes {{{

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

" }}} End Drupal / PHP

"actionscript/flash files. RIP.
au BufNewFile,BufRead *.as set filetype=actionscript

"json
au FileType json setlocal shiftwidth=4 tabstop=4

"quickfix
au FileType qf setlocal nonumber colorcolumn=

"vimwiki
au FileType vimwiki setlocal tw=0

"fzf
au FileType fzf setlocal nonu nornu

au FileType help setlocal nonumber norelativenumber

" Toggle relative and normal numbers depending on active or not
function! SetNumbers(s)
  let fname = expand('%:t')
  if fname != '' && &ft != 'help' && &ft != 'nerdtree' && &ft != 'fzf'
    if a:s == 'on'
      setlocal relativenumber
    else
      setlocal norelativenumber
    endif
  else
    setlocal norelativenumber
  endif
endfunction

" turn off relativenumber in non active window
augroup BgHighlight
    autocmd!
    autocmd WinEnter,FocusGained * call SetNumbers('on')
    autocmd WinLeave,FocusLost * call SetNumbers('off')
augroup END

" }}} End Filetypes
" Buffer handling {{{

" Make sure Vim returns to the same line when you reopen a file.
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \     execute 'normal! g`"zvzz' |
    \ endif

" Remember info about open buffers on close
set viminfo^=%

"turn off the cursorline when not in a window
autocmd InsertLeave,WinEnter * set cursorline
autocmd InsertEnter,WinLeave * set nocursorline

" Reload when gaining focus
autocmd FocusGained,BufEnter * :silent! !

" auto resize on size change
autocmd VimResized * wincmd =

"refresh screen that turns off highlights, fix syntax highlight etc.

" }}} End Buffer handling
" Helper functions {{{

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction
xnoremap @ :<c-u>call ExecuteMacroOverVisualRange()<CR>

" Based off of a post by Greg Sexton
function! Customfoldtext() abort
  "get first non-blank line
  let fs = v:foldstart
  while getline(fs) =~ '^\s*$' | let fs = nextnonblank(fs + 1)
  endwhile
  if fs > v:foldend
    let line = getline(v:foldstart)
  else
    let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
  endif

  let foldsymbol='+'
  let repeatsymbol=''
  let prefix = foldsymbol . ' '

  let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
  let foldSize = 1 + v:foldend - v:foldstart
  let foldSizeStr = " " . foldSize . " lines "
  let foldLevelStr = repeat("+--", v:foldlevel)
  let lineCount = line("$")
  let expansionString = repeat(repeatsymbol, w - strwidth(prefix.foldSizeStr.line.foldLevelStr))
  return prefix . line . expansionString . foldSizeStr . foldLevelStr
endfunction

function! TrimWhiteSpace()
  %s/\s\+$//e
endfunction
command! TrimWhiteSpace :call TrimWhiteSpace()

function! SearchWordWithAg()
  execute 'Ag' expand('<cword>')
endfunction

"shift current item to todo or done in vimwiki
"gary vimrc: https://github.com/garybernhardt/dotfiles/blob/master/.vimrc<Paste>
"my folding stuff: https://github.com/fenetikm/vim-textobj-function/blob/master/autoload/textobj/function/php.vim
function! ShiftTodoDone()
  "search up for todo and done
  let todoHeader = search('^#\+ Todo', 'bn')
  let doneHeader = search('^#\+ Done', 'bn')
  let currentPos = line('.')
  if todoHeader == 0 || doneHeader == 0
    echom 'Missing section'
    return
  endif
  if todoHeader > currentPos && doneHeader > currentPos
    echom 'Not inside section'
    return
  endif
endfunction
command! ShiftTodoDone :call ShiftTodoDone()

" Thanks gary. Renames current file.
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
command! RenameFile :call RenameFile()

"Again thanks gary. Remove stupid fancy characters.
function! RemoveFancyCharacters()
  let typo = {}
  let typo["“"] = '"'
  let typo["”"] = '"'
  let typo["‘"] = "'"
  let typo["’"] = "'"
  let typo["–"] = '--'
  let typo["—"] = '---'
  let typo["…"] = '...'
  :exe ":%s/".join(keys(typo), '\|').'/\=typo[submatch(0)]/ge'
endfunction
command! RemoveFancyCharacters :call RemoveFancyCharacters()

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
command! DeleteInactiveBuffers :call DeleteInactiveBufs()

" Function to start profiling commmands
function! StartProfile()
  profile start profile.log
  profile func *
  profile file *
endfunction
command! StartProfile call StartProfile()

function! StopProfile()
  profile stop
endfunction
command! StopProfile call StopProfile()

nmap <C-S-C> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

function! DrupalConsoleReloadConfig() "Do stuff
  " name of the file
  let fn = expand('%:t')
  " just the path containing the file
  let path = expand('%:p:h')
  " position of '/app/'
  let app_pos = match(path, '/app/')
  " full path to file inside of vagrant
  let webpath = '/vagrant' . strpart(path, app_pos) . '/' . fn
  let config_name = substitute(fn, '.yml', '', '')
  let dcommand = 'vbin/drupal config:import:single --file=' . webpath
  let g:VimuxRunnerIndex = 3
  echom dcommand
  execute 'call VimuxRunCommand("' . dcommand . '")'
endfunction
command! DrupalConsoleReloadConfig :call DrupalConsoleReloadConfig()

"Get the Drupal root
function! DrupalRoot()
  " This now does the trick.
  return projectroot#guess()
  " path containing the current file
  let path = expand('%:p:h')
  " position of '/app/'
  let app_pos = match(path, '/app')
  if app_pos == -1
    return ''
  endif
  return strpart(path, 0, app_pos)
endfunction
command! DrupalRoot call DrupalRoot()

function! ToggleSyntax()
   if exists("g:syntax_on") | syntax off | else | syntax enable | endif
endfunction
command! ToggleSyntax call ToggleSyntax()

" }}} End Helper functions
" Plugins: {{{

call plug#begin()

" Global, system, movement {{{

Plug 'tpope/vim-surround', { 'on': [] } "change surrounding characters
Plug 'SirVer/ultisnips', { 'on': [] } "ultisnips snippets
" Plug 'honza/vim-snippets' "snippets library
Plug 'tpope/vim-dispatch' "async dispatching
Plug 'radenling/vim-dispatch-neovim' "dispatch for neovim
Plug 'skywind3000/asyncrun.vim' "async runner
" Plug 'ludovicchabant/vim-gutentags' "tag generation
" Plug 'easymotion/vim-easymotion' "vimperator style jumping around
" Plug 'justinmk/vim-sneak' "like easy motion
Plug 'embear/vim-localvimrc' "local vimrc
Plug 'dbakker/vim-projectroot' "project root stuff
Plug 'cohama/lexima.vim' "auto closing pairs
Plug 'terryma/vim-expand-region' "expand region useful for selection
Plug 'AndrewRadev/splitjoin.vim', { 'for': 'php' } "convert single/multi line code expressions
Plug 'benmills/vimux' "Interact with tmux from vim
" Plug 'jebaum/vim-tmuxify' "tmux controlling, might be a bit more powerful than vimux?
" Plug 'tpope/vim-eunuch' "Better unix commands
Plug 'tpope/vim-unimpaired', { 'on': [] } "Various dual pair commands
Plug 'tpope/vim-repeat' "Repeat plugin commands
Plug 'ConradIrwin/vim-bracketed-paste' "auto set paste nopaste
" Plug 'vimwiki/vimwiki'  "Wiki for vim
" Plug 'tbabej/taskwiki' "taskwarrior integration
" Plug 'blindFS/vim-taskwarrior' "taskwarrior management
" Plug 'powerman/vim-plugin-AnsiEsc' "improve colour support for graphs
Plug 'tpope/vim-abolish' "abbreviation generation
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' } "Undo tree
Plug 'junegunn/goyo.vim' "distraction free writing
" Plug 'vim-scripts/Decho' "debugging
" Plug 'hecal3/vim-leader-guide' "show leader guide
Plug 'machakann/vim-highlightedyank' "highlight the last yanked item
Plug 'rhysd/clever-f.vim' "clever fFtT
Plug 'chaoren/vim-wordmotion' "Expand the definition of what a word is
Plug 'christoomey/vim-tmux-navigator' "navigate betwenn tmux splits and vim together

augroup load_ultisnips
  autocmd!
  autocmd InsertEnter * call plug#load('ultisnips') | autocmd! load_ultisnips
augroup END

augroup load_unimpaired
  autocmd!
  autocmd InsertEnter * call plug#load('vim-unimpaired') | autocmd! load_unimpaired
augroup END

augroup load_surround
  autocmd!
  autocmd InsertEnter * call plug#load('vim-surround') | autocmd! load_ultisnips
augroup END

" }}} End Global, system, movement
" Interface, fuzzy handling, completion {{{

Plug 'itchyny/lightline.vim' "statusline handling
Plug 'airblade/vim-gitgutter' "place git changes in the gutter
Plug 'kshenoy/vim-signature' "marks handling
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } "autocomplete
Plug 'Shougo/context_filetype.vim' "better filetype completion
" Plug 'ncm2/ncm2' "Completion manager
" Plug 'roxma/nvim-yarp' "plugin process required by ncm2
" Plug 'neoclide/coc.nvim', {'branch': 'release'} "coc, completion, release branch
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'} "coc, completion, master branch
Plug 'liuchengxu/vista.vim' "tagbar style for coc

" NCM2 plugins
" Plug 'ncm2/ncm2-ultisnips' "ultisnips
" Plug 'ncm2/ncm2-bufword' "bufferwords
" Plug 'ncm2/ncm2-path' "paths

Plug 'skywind3000/vim-preview' "preview commands
" Plug 'tenfyzhong/CompleteParameter.vim' "insert completion parameters
Plug 'Shougo/echodoc.vim' "show completion signatures

Plug 'Valloric/ListToggle' "toggle quickfix and location lists
Plug 'majutsushi/tagbar' "tagbar
" Plug 'vim-php/tagbar-phpctags.vim' "tagbar phpctags
Plug 'mhinz/vim-startify' "startify
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] } "nerdtree file tree explorer
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] } "nerdtree git plugin
Plug 'ryanoasis/vim-devicons' "icons using the nerd font
" Plug 'tiagofumo/vim-nerdtree-syntax-highlight', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] } "add in colors for above icons but seems to slow down nerdtree
"Plug 'auwsmit/vim-active-numbers' "line numbers only in active buffer, it's a bit disctracting though
"Plug 'roman/golden-ratio' "
" Plug 'junegunn/vim-emoji' "emojis for vim
" Plug 'ap/vim-buftabline' "Show what buffers are open at the top
" Plug 'edkolev/tmuxline.vim' "Change the tmux status to be similar to vim
" Plug 'roman/golden-ratio' "make the focused split bigger
" Plug 'jszakmeister/vim-togglecursor/' "change cursor depending on mode
"Plug 'sjl/vitality.vim' "more cursor stuff

" }}} End Interface, fuzzy handling
" Search, Fuzzy Finding {{{

Plug 'wincent/loupe' "nicer search highlighting
Plug 'wincent/ferret' "multi file search
Plug '/usr/local/opt/fzf' "fzf
Plug 'junegunn/fzf.vim' "fuzzy finder stuff
Plug 'nelstrom/vim-visual-star-search' "use * in visual mode to search
Plug 'jesseleite/vim-agriculture' "pass things through to rg

" }}} End Search, Fuzzy Finding
" Syntax {{{

Plug 'sheerun/vim-polyglot' "syntax for a lot of types
" Plug 'ap/vim-css-color' "css color preview
" Plug 'lilydjwg/colorizer' "colorize text, works with background inactive / active stuff
Plug 'norcalli/nvim-colorizer.lua' "better colorizer?

" Plug 'pangloss/vim-javascript', { 'for': 'javascript' } "javascript syntax
" Plug 'mxw/vim-jsx' "jsx syntax support
" Plug 'posva/vim-vue', { 'for': 'vue' } "vue support
Plug 'gerw/vim-HiLinkTrace' "show syntax color groups
Plug 'vim-scripts/todo-txt.vim' "handling of todo.txt
" Plug 'masukomi/vim-markdown-folding' "markdown folding
" Plug 'gabrielelana/vim-markdown' "better markdown support
Plug 'gregsexton/MatchTag', { 'for': 'html' } "html tag matching

" }}} End Syntax
" Coding, text objects {{{
"

Plug 'tpope/vim-projectionist' "navigation and alternates
" Plug 'tpope/vim-fugitive', {'on': []} "git management
Plug 'tpope/vim-fugitive'
" Plug 'jreybert/vimagit' "git management
Plug 'tomtom/tcomment_vim', {'on': []} "commenting
" Plug 'sickill/vim-pasta' "paste with indentation
" Plug 'joonty/vdebug', { 'for': 'php' } "debugger
Plug 'joonty/vdebug' "debugger
" Plug 'trendfischer/vim-phpqa', { 'for': 'php' } "coverage
" Plug '~/.config/nvim/eclim' "eclim for completion
" Plug 'lvht/phpcd.vim', { 'for': 'php', 'do': 'composer update' }
" Plug 'przepompownia/phpcd.vim', { 'for': 'php', 'do': 'composer update' }
Plug 'joonty/vim-phpunitqf', { 'for': 'php' } "PHPUnit runner
Plug 'janko-m/vim-test' "Test runner
Plug 'wellle/targets.vim', {'on': []} "Additional target text objects
Plug 'nathanaelkane/vim-indent-guides' "indent guides
Plug 'kana/vim-textobj-user' "user textobjects
" Plug 'kana/vim-textobj-entire' "entire document
" Plug 'kana/vim-textobj-fold' "fold textobj, 14ms to startup
Plug 'kana/vim-textobj-line' "line textobj
Plug 'kana/vim-textobj-indent' "indent textobj
Plug 'glts/vim-textobj-comment' "comment
" Plug 'michaeljsmith/vim-indent-object' "indentation text objects
" Plug 'roxma/nvim-completion-manager' "nvim completion manager
" Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
" Plug 'oxma/LanguageServer-php-neovim',  {'do': 'composer install && composer run-script parse-stubs'}
" Disabled, not sure if worth it.
" Plug 'int3/vim-extradite' "Git commit browser
Plug 'junegunn/vim-easy-align', { 'on': ['<Plug>(EasyAlign)', 'EasyAlign'] } "Alignment of variables, etc.
" Plug 'Konfekt/FastFold' "fastfolding and fold custom objects
Plug 'mattn/emmet-vim' "expansion of html/css to full tags
Plug 'jpalardy/vim-slime' "send output from buffer to tmux / repl
Plug 'kkoomen/vim-doge' "documentation generator

augroup load_targets
  autocmd!
  autocmd CursorHold,CursorHoldI * call plug#load('targets.vim') | autocmd! load_targets
augroup END

augroup load_tcomment
  autocmd!
  autocmd CursorHold,CursorHoldI * call plug#load('tcomment_vim') | autocmd! load_tcomment
augroup END

" a bit hacky, but required to get it working
" command! Gstatus call LazyLoadFugitive('Gstatus')
" command! Gdiff call LazyLoadFugitive('Gdiff')
" command! Glog call LazyLoadFugitive('Glog')
" command! Gblame call LazyLoadFugitive('Gblame')
" command! Gvdiff call LazyLoadFugitive('Gvdiff')
" command! Gread call LazyLoadFugitive('Gread')
" command! Gmerge call LazyLoadFugitive('Gmerge')

function! LazyLoadFugitive(cmd)
  if exists('g:llf')
    return
  endif

  let g:llf=1

  call plug#load('vim-fugitive')
  call fugitive#detect(expand('%:p'))
  exe a:cmd
endfunction

" PHP Specific {{{

" Plug 'sniphpets/sniphpets', { 'for': 'php' } "php snippets
" Plug 'sniphpets/sniphpets-common', { 'for': 'php' } "php snippets
Plug '2072/PHP-Indenting-for-VIm', { 'for': 'php' } "updated indenting
" Plug 'paulyg/Vim-PHP-Stuff' "updated php syntax
" Plug 'StanAngeloff/php.vim' "More updatd php syntax
Plug 'arnaud-lb/vim-php-namespace', { 'for': 'php' } "insert use statements automatically
Plug 'sahibalejandro/vim-php', { 'for': 'php' } "insert absolute FQCN
Plug 'fenetikm/php-doc-modded', { 'for': 'php' } "insert php doc blocks
Plug 'adoy/vim-php-refactoring-toolbox', { 'for': 'php' } "php refactoring
" Plug 'tobyS/vmustache' "mustache templater for pdv
" Plug 'tobyS/pdv' "php documenter
Plug 'fenetikm/phpfolding.vim', { 'for': 'php' } "php folding
Plug 'alvan/vim-php-manual', { 'for': 'php' } "php manual
Plug 'fenetikm/vim-textobj-function', { 'for': 'php' } "function textobj with php
" Plug 'padawan-php/deoplete-padawan' "deoplete padawan completion
" Plug 'phpactor/phpactor',  {'do': 'composer install', 'for': 'php'} "php completion
" Plug 'kristijanhusak/deoplete-phpactor' "async phpactor
" Plug 'm2mdas/phpcomplete-extended-symfony' "phpcomplete symfony (drupal)
" Plug 'guywithnose/vim-split-join' "split and join arrays, messes up syntax?

" }}} End PHP Specific

" }}} End Coding, text objects
" To try {{{

" Plug 'jeanCarloMachado/vim-toop' "text object operations, run through external commands
" Plug 'eedes/vim-pencil' "good setup for writing
" Plug 'tpope/vim-eunuch' "unix commands
" Plug 'tpope/vim-characterize' "character codes and emoji codes. html entities
" Plug 'itchyny/calendar.vim' "calendar, integrate with GCal?!
" Plug 'chrisbra/csv.vim' "CSV file syntax and commands
" Plug 'Shougo/vinarise.vim' "Hex editor
" Plug 'lambdalisue/gina.vim' "Alternative git plugin
" Plug 'lambdalisue/vim-gista' "Messing with gists
" Plug 'mbbill/undotree ' "Undo tree
" Plug 'phpstan/vim-phpstan' "PHP static analysis
" Plug 'ntpeters/vim-better-whitespace' "whitespace handing
" Plug 'tpope/vim-scriptease' "vim script helper functions
" Plug 'mkitt/browser-refresh.vim' "Refresh browser from vim
" Plug 'osyo-manga/vim-anzu' "show x/y when searching
" Plug 'idanarye/vim-merginal' "additional git branches on top of fugitive
" Plug 'AndrewRadev/switch.vim' "switch between values, e.g. true and false
" Plug 'francoiscabrol/ranger.vim' "ranger integration, mac osx?
" Plug 'Shougo/neoyank.vim' "saves yank history, can we use this with fzf?
" Plug 'svermeulen/vim-easyclip' "simplified clipboard / yank functionality see: https://github.com/svermeulen/vim-easyclip/issues/62
" Plug 'junegunn/gv.vim' "pretty git log file explorer
" Plug 'junegunn/vim-peekaboo' "show preview of registers, commands etc.
" Plug 'junegunn/vim-journal' "nice looking syntax for notes
Plug 'wincent/ferret' "multi file search and replace etc.
Plug 'w0rp/ale' "async linting engine
" Plug 'obertbasic/snipbar' "show snippets in a side bar
" Plug 'phpstan/vim-phpstan' "php static analysis plugin to call phpstan
" Plug 'https://github.com/tmux-plugins/vim-tmux-focus-events' "focus events for vim
" Plug 'kenng/vim-bettersearch' "show search results in a small window as you go?
" Plug 'mhinz/vim-sayonara'"smart closing of buffers
" Plug 'KabbAmine/vCoolor.vim' "color picker
" Plug 'nicwest/QQ.vim' "curl wrapper for in vim testing of endpoints

" }}} End To try plugins
" Colors {{{

" Plug 'AlessandroYorba/Monrovia'
" Plug 'AlessandroYorba/Sidonia'
" Plug 'AlessandroYorba/Despacio'
" Plug 'sjl/badwolf'
" Plug 'davidklsn/vim-sialoquent'
" Plug 'croaker/mustang-vim'
" Plug 'vim-airline/vim-airline-themes'
" Plug 'gosukiwi/vim-atom-dark'
" Plug 'fcpg/vim-orbital'
" Plug 'jonathanfilip/vim-lucius'
" Plug 'liuchengxu/space-vim-dark'
" Plug 'whatyouhide/vim-gotham'
" Plug 'morhetz/gruvbox'
" Plug 'sonph/onehalf', {'rtp': 'vim/'}
" Plug 'arcticicestudio/nord-vim'
" Plug 'rakr/vim-one'
" Plug 'cocopon/iceberg.vim'
" Plug 'jacoborus/tender.vim'
" Plug 'tomasiser/vim-code-dark'
" Plug 'mhartington/oceanic-next'
" Plug 'dracula/vim'
Plug '~/Documents/Work/internal/vim/colors/falcon'
" Plug 'rafi/awesome-vim-colorschemes'

" }}} End Colors

call plug#end()

" }}} End Plugins
" Plugin settings {{{

" FZF, CtrlP, Ag, Unite {{{

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

" }}} End FZF, CtrlP, Ag, Unite
" NERDTree and Plugins: {{{

" Check if NERDTree is open or active
function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

"map ctrl-e to show nerdtree
function! OpenNERD()
  let fname = expand('%:t')
  if bufname('') == 'Startify'
    execute 'NERDTreeToggle'
  elseif fname == '' || bufname('') == 'NERD_tree_1'
    execute 'NERDTreeToggle'
  else
    execute 'NERDTreeFind'
  endif
endfunction
noremap <silent> <c-e> :call OpenNERD()<cr>

"width
let g:NERDTreeWinSize=40

" Disable display of '?' text and 'Bookmarks' label.
let g:NERDTreeMinimalUI=1

" Show hidden files by default
let g:NERDTreeShowHidden=1

" turn off cursorline highlighting
let NERDTreeHighlightCursorline = 0

" nerdtree highlighting icon stuff.
let g:NERDTreeLimitedSyntax = 1
" let g:NERDTreeSyntaxDisableDefaultExtensions = 1
" let g:NERDTreeDisableExactMatchHighlight = 1
" let g:NERDTreeDisablePatternMatchHighlight = 1
" let g:NERDTreeSyntaxEnabledExtensions = ['yaml', 'php', 'js', 'css']

let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "~",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✓",
    \ 'Ignored'   : 'i',
    \ "Unknown"   : "?"
    \ }

let NERDTreeIgnore=['\.git']

" turn off aggressive updating of git status
let g:NERDTreeUpdateOnCursorHold = 0
let g:NERDTreeUpdateOnWrite      = 0

" }}} End NERDTree
" ListToggle {{{

let g:lt_location_list_toggle_map = '<leader>l'
let g:lt_quickfix_list_toggle_map = '<leader>q'

" }}} End ListToggle
" UltiSnips {{{

" directory for my snippets
let g:UltiSnipsSnippetsDir="~/.config/nvim/UltiSnips"
" open edit in vertical split
let g:UltiSnipsEditSplit="vertical"
" in select mode hit ctrl-u to delete the whole line
snoremap <C-u> <Esc>:d1<cr>i

function! s:ListSnippetsForCurrentFt() abort
    if empty(UltiSnips#SnippetsInCurrentScope(1))
        return ''
    endif
    let word_to_complete = matchstr(strpart(getline('.'), 0, col('.') - 1), '\S\+$')
    let l:Is_relevant = {i,v ->
    \      stridx(v, word_to_complete)>=0
    \&&    matchstr(g:current_ulti_dict_info[v].location, '.*/\zs.\{-}\ze\.') ==# &ft}
    let l:Build_info = { i,v -> {
    \     'word': v,
    \     'menu': '[snip] '. g:current_ulti_dict_info[v]['description'],
    \     'dup' : 1,
    \ }}
    let candidates = map(filter(keys(g:current_ulti_dict_info), l:Is_relevant), l:Build_info)
    let from_where = col('.') - len(word_to_complete)
    if !empty(candidates)
        call complete(from_where, candidates)
    endif
    return ''
endfu
" map the above to c-x c-x
inoremap <silent> <c-x><c-x> <c-r>=<sid>ListSnippetsForCurrentFt()<cr>

function! s:ExpandShortestMatchingSnippet() abort
  let the_snippets = UltiSnips#SnippetsInCurrentScope()
  let shortest_candidate = ''
  let shortest_snippet = ''
  for i in items(the_snippets)
    Decho i
    if len(shortest_candidate) == 0
      let shortest_candidate = i[0]
      " let shortest_snippet = i[2]
      continue
    endif

    if len(i[0]) < len(shortest_candidate)
      let shortest_candidate = i[0]
      " let shortest_snippet = i[2]
    endif
  endfor
  if shortest_candidate == ''
    return 0
  else
    " Decho shortest_snippet
    return shortest_snippet
  endif
endfunction
inoremap <s-cr> <c-r>=(<sid>ExpandShortestMatchingSnippet() == 0 ? '' :UltiSnips#ExpandSnippet())<cr>

let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" }}} End UltiSnips
" Fugitive, GitGutter, Vimagit {{{

nnoremap <leader>ga :Git add %:p<cr><cr>
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gd :Gvdiffsplit!<cr>
nnoremap <leader>gr :Gread<cr>
nnoremap <leader>gl :Glog<cr>
nnoremap <leader>gp :Gpush<cr>
nnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gm :Gmerge<cr>

function! QuickCommitMessage()
  if &ft == 'todo'
    execute 'Gcommit -m "Update todo"'
  elseif
    execute 'Gcommit -m "Quick update"'
  endif
endfunction

" Stage and commit the current file.
nnoremap <leader>gg :Gwrite<cr>:call QuickCommitMessage()<cr>

" disable gitgutter default keys
let g:gitgutter_map_keys = 0

" stage a hunk via gitgutter
nnoremap <leader>gh :GitGutterStageHunk<cr>

"pair mapping for hunks
nmap ]c <Plug>(GitGutterNextHunk)
nmap [c <Plug>(GitGutterPrevHunk)

"signs to use
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = ''
let g:gitgutter_sign_modified_removed = '·'
let g:gitgutter_async = 1

"merging mappings
nnoremap <c-left> :diffget //2<cr>
nnoremap <c-right> :diffget //3<cr>
nnoremap <c-up> [c
nnoremap <c-down> ]c

" }}} End Fugitive
" Tag plugins {{{

"gutentags
let g:gutentags_ctags_exclude=['*.json', '*.css', '*.html', '*.sh', '*.yml', '*.html.twig', '*.sql', '*.md', '*.xml', '*.js', '*.phar']
" let g:gutentags_file_list_command='find vendor/symfony vendor/symfony-cmf vendor/twig vendor/psr app -type f'
let g:gutentags_cache_dir = '/Users/mjw/.config/nvim/gutentags'

let g:gutentags_project_root_finder = 'projectroot#guess'

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
let g:tcomment_maps=0
" }}} tcomment "
" Polyglot {{{ "
let g:polyglot_disabled = ['yaml']
" }}} "
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

"vim-markdown stuff
let g:vim_markdown_fenced_languages = ['c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini', 'php=php']

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

let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]

let g:vista_executive_for = {
  \ 'php': 'coc',
  \ }

let g:vista#renderer#enable_icon = 1

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
set completeopt=longest,menuone

" tab to go forward
inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" shift tab to go backwards
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"

" }}} End Deoplete
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
nmap dw de
nmap cw ce

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
nnoremap <F17><F17> :TComment<cr>
nnoremap <F17>b :TCommentBlock<cr>
nnoremap <F17>i :TCommentInline<cr>
inoremap <F17><F17> <c-o>:TComment<cr>
inoremap <F17>b <c-o>:TCommentBlock<cr>
inoremap <F17>i <c-o>:TCommentInline<cr>
vnoremap <F17><F17> :TComment<cr>
vnoremap <F17>b :TCommentBlock<cr>
vnoremap <F17>i :TCommentInline<cr>

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
"dictionary completion
inoremap <c-d> <c-x><c-k>
"file path completion
inoremap <c-f> <c-x><c-f>
"line completion, conflicts with php rocket
inoremap <c-l> <c-x><c-l>

" }}} End Insert mode mappings
" Easy file opening [leader e*]{{{

"ev to edit vimrc, vv to source vimrc
nnoremap <silent> <leader>vv :so $MYVIMRC <bar>exe 'normal! zvzz'<cr>

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
let g:agriculture#fzf_extra_options='--no-bold --color=hl:7,hl+:3'

" nnoremap <leader>s :Rg<space>
nmap <leader>s <Plug>RgRawSearch
nmap <leader>S <Plug>RgRawAllSearch
xmap <leader>s <Plug>RgRawVisualSelection<cr>
nmap <silent> <leader>k <Plug>RgRawWordUnderCursor<cr>
nmap <silent> <leader>K <Plug>RgRawAllWordUnderCursor<cr>

"replace across files
nmap <silent> <leader>R <Plug>(FerretAcks)

"highlight matches in place with g*
nnoremap <silent> g* :let @/='\<'.expand('<cword>').'\>'<CR>
xnoremap <silent> g* "sy:let @/=@s<CR>

" }}} Searching and replacing [leader s*] "
" Pairs ][ {{{ "

" c-] for in to tags, c-[ for out, free up <c-t>
" set <F18>=[34~
" set <F18>=[17;2~
nnoremap <F18> <c-t>
"apparently this is f18 in tmux?
nnoremap <S-F6> <c-t>

"tools for mapping:
"- showkey
"- insert mode, then <c-v> then type the key

" }}} Pairs "

" yank to p register
vnoremap <c-y> "py

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

" switch tabs
nnoremap <c-w>n <c-pagedown>
nnoremap <c-w>p <c-pageup>

nnoremap <c-cr> za

"focus the current fold
nnoremap <s-cr> zMzAzz

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
xnoremap <leader>d "udd

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
" Statusline {{{

"@todo override filename formatting to italic.
"@todo disable stuff on the right for NERDTree
"make modified a different colour

      " \ 'colorscheme': 'gruvbox',

set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'falcon',
      \ 'active': {
      \     'left': [ [ 'mode', 'paste' ],
      \               [ 'filename' ] ],
      \     'right': [ ['linter_status', 'lineinfo'],
      \                [ 'linter_warnings', 'linter_errors', 'linter_ok', 'fileformat', 'fileencoding', 'filetype' ] ]
      \   },
      \   'inactive': {
      \     'left': [ [ 'filename' ] ],
      \     'right': [ [ 'lineinfo' ],
      \                [ 'filetype' ] ]
      \   },
      \ 'component_function': {
      \   'lineinfo': 'LightlineLineinfo',
      \   'filename': 'LightlineFilename',
      \   'fugitive': 'LightlineFugitive',
      \   'fileformat': 'LightlineFileformat',
      \   'filetype': 'LightlineFiletype',
      \   'fileencoding': 'LightlineFileencoding',
      \   'mode': 'LightlineMode',
      \ },
      \ 'component_expand': {
      \    'linter_warnings': 'LightlineLinterWarnings',
      \    'linter_errors': 'LightlineLinterErrors',
      \    'linter_ok': 'LightlineLinterOk',
      \ },
      \ 'component_type': {
      \    'linter_warnings': 'warning',
      \    'linter_errors': 'error',
      \    'linter_ok': 'ok',
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '|', 'right': '|' }
      \}
" some alternate sep glyph ideas
"  'left': '', 'right': ''
"  'left': '', 'right': ''
"  'left': '', 'right': ''
"  'left': '', 'right': ''

let g:lightline.mode_map = {
      \ 'n' : 'N',
      \ 'i' : 'I',
      \ 'R' : 'R',
      \ 'v' : 'V',
      \ 'V' : 'V-L',
      \ "\<C-v>": 'V-B',
      \ 'c' : 'C',
      \ 's' : 'S',
      \ 'S' : 'S-L',
      \ "\<C-s>": 'S-B',
      \ 't': 'T',
      \ }

function! LightlineLineinfo()
  let fname = expand('%:t')
  return fname =~ 'NERD_tree' ? '' : printf('%d:%-2d', line('.'), col('.'))
endfunction

function! LightlineLinterWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ◆', all_non_errors)
endfunction

function! LightlineLinterErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ✗', all_errors)
endfunction

function! LightlineLinterOk() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  let l:match_type=0
  for pkey in keys(g:ale_linters)
    if pkey == &ft
      let l:match_type = 1
    endif
  endfor
  if l:match_type == 0
    return ''
  endif
  return l:counts.total == 0 ? '✓' : ''
endfunction

" update status after ale finishes linting
autocmd User ALELint call lightline#update()

function! LightlineMode()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == 'ControlP' ? 'CtrlP' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! LightlineFugitive()
  try
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
      let mark = ' '  " edit here for cool mark
      let branch = fugitive#head()
      return branch !=# '' ? mark.branch : ''
    endif
  catch
  endtry
  return ''
endfunction

function! LightlineReadonly()
  return &ft !~? 'help' && &readonly ? '' : ''
endfunction

function! LightlineModified()
  return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightlineFilename()
  let fname = expand('%:t')
  return fname == 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? g:lightline.ctrlp_item :
        \ fname == '__Tagbar__' ? g:lightline.fname :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ &ft == 'unite' ? unite#get_status_string() :
        \ ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
        \ ('' != fname ? fname : '[No Name]') .
        \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction

function! LightlineFileformat()
  "return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  "return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

" }}} End Statusline
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
