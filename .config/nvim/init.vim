" Michael Welford's vimrc
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
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=vendor/cache/**

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
set magic "regex magic, more useable
set showmatch "show matching brackets when text indicator is over them
set mat=2 "how many tenths of a second to blink when matching brackets

set noerrorbells "no annoying beeps
set novisualbell "no screen flashes on errors
set t_vb= "no screen flashes
set timeoutlen=2000 "timeout for leader key
set noshowmode "hide showing which mode we are in, the status bar is fine

set fcs=vert:│ " Solid line for vsplit separator

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

set synmaxcol=800                     " Don't try to highlight lines longer than 800 characters.

if has('linebreak')
  let &showbreak='↳ '                 " DOWNWARDS ARROW WITH TIP RIGHTWARDS (U+21B3, UTF-8: E2 86 B3)
endif

if has('virtualedit')
  set virtualedit=block               " allow cursor to move where there is no text in visual block mode
endif

set fileformat=unix "default fileformat

" Cursor settings. This makes terminal vim sooo much nicer!
" Tmux will only forward escape sequences to the terminal if surrounded by a DCS
" sequence

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
function! NeomakeSave()
  if &ft == 'php'
    Neomake phpcs
  endif
endfunction

autocmd! BufWritePost * call NeomakeSave()

" set omni for php
" au FileType php set omnifunc=phpcomplete#CompletePHP

" }}} End Drupal / PHP

au BufNewFile,BufRead *.as set filetype=actionscript

" }}} End Filetypes
" Buffer handling --------------------------------------------------- {{{

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
au FocusGained,BufEnter * :silent! !

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

" Thanks gary.
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

"Again thanks gary.
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
command! DeleteInactiveBuffers :call DeleteInactiveBufs()

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
  let command = 'vbin/drupal config:import:single --file=' . webpath
  let g:VimuxRunnerIndex = 3
  execute 'call VimuxRunCommand("' . command . '")'
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
" Plug 'jebaum/vim-tmuxify' "tmux controlling, might be a bit more powerful than vimux?
" Plug 'tpope/vim-eunuch' "Better unix commands
Plug 'tpope/vim-unimpaired' "Various dual pair commands
Plug 'tpope/vim-repeat' "Repeat plugin commands
Plug 'wincent/loupe' "nicer search highlighting


" }}} End Global, system, movement
" Interface, fuzzy handling --------------------------------------------------- {{{

" Plug 'bling/vim-airline' "improved status line
Plug 'itchyny/lightline.vim' "statusline handling
"Plug 'ctrlpvim/ctrlp.vim' "fuzzy file searching
" Plug 'Numkil/ag.nvim' "ag for nvim
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } "fuzzy finder
Plug 'junegunn/fzf.vim' "fuzzy finder stuff
" Plug 'Shougo/unite.vim' "create lists and filter them
" Plug 'Shougo/unite-outline' "outline of current buffer source
Plug 'airblade/vim-gitgutter' "place git changes in the gutter
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
Plug 'tiagofumo/vim-nerdtree-syntax-highlight' "add in colors for above icons
" Plug 'junegunn/vim-emoji' "emojis for vim
" Plug 'yuttie/comfortable-motion.vim' "Nice scrolling in vim
Plug 'ap/vim-buftabline' "Show what buffers are open at the top
Plug 'edkolev/tmuxline.vim' "Change the tmux status to be similar to vim

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

Plug 'tpope/vim-fugitive' "git management
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
Plug 'vim-scripts/todo-txt.vim' "handling of todo.txt
" Plug 'int3/vim-extradite' "Git commit browser
Plug 'junegunn/vim-easy-align' "Alignment of variables, etc.

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
" Plug 'wincent/ferret' "multi file search and replace etc.
" Plug 'w0rp/ale' "async linting engine
" Plug 'obertbasic/snipbar' "show snippets in a side bar
" Plug 'phpstan/vim-phpstan' "php static analysis plugin to call phpstan
" Plug 'https://github.com/tmux-plugins/vim-tmux-focus-events' "focus events for vim
" Plug 'kenng/vim-bettersearch' "show search results in a small window as you go?
" Plug 'mhinz/vim-sayonara'"smart closing of buffers
" Plug 'KabbAmine/vCoolor.vim' "color picker
" Plug 'nicwest/QQ.vim' "curl wrapper for in vim testing of endpoints
"

" }}} End To try plugins
" Colors --------------------------------------------------- {{{

" Plug 'flazz/vim-colorschemes' "colorscheme pack
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
Plug 'morhetz/gruvbox'
" Plug 'rakr/vim-one' "Atom dark / light one theme

" }}} End Colors

call plug#end()

" }}} End Plugins
" Plugin settings --------------------------------------------------- {{{

" FZF, CtrlP, Ag, Unite --------------------------------------------- {{{

" for some reason :Buffers is giving me something funky from elsewhere...
" nnoremap <leader>b :call fzf#vim#buffers()<cr>
" Files searches through all files (not just version controlled)
" nnoremap <leader>f :Files<cr>
" Given this up for thm testing namespace
" nnoremap <leader>t :Tags<cr>
" nnoremap <C-r> :History<cr>
" nnoremap <silent> \ :Ag<space>

nnoremap <silent> <leader>tt :Tags<cr>
" search for text in Ag
nnoremap <silent> \ :Ag<space>
nnoremap <silent> <leader>\ :AgAll<space>
" search for under cursor keyword in Ag
nnoremap <silent> <leader>a :Ag <c-r><c-w><cr>
" search for under cursor keyword in Ag in all files (ex. gitignore)
nnoremap <silent> <leader>A :AgAll <c-r><c-w><cr>
nnoremap <silent> <leader>b :call fzf#vim#buffers()<cr>

nnoremap <silent> <c-p> :DFiles<cr>
nnoremap <silent> <leader>pp :GFiles<cr>

"File searching stuff, WIP
nnoremap <silent> <leader>ff :Files<cr>
nnoremap <silent> <leader>FF :GitFiles<cr>
nnoremap <silent> <leader>fh :Helptags<cr>
nnoremap <silent> <leader>fc :Commands<cr>
nnoremap <silent> <leader>fm :Maps<cr>
nnoremap <silent> <leader>s :Snippets<cr>

" @todo maybe?
" :Colors
" :Marks
" :Filetypes
" :BLines

"@todo fix this: line completion why you no work?
imap <c-x><c-l> <plug>(fzf-complete-buffer-line)

"word completion
imap <c-x><c-k> <plug>(fzf-complete-word)

" match splitting to ctrl-w splitting
let g:fzf_action = {
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-o': '!open'}

"Default Ag command with addition of changing color
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>, '--color-path 400', fzf#vim#default_layout)

" Ag all files
command! -bang -nargs=* AgAll
  \ call fzf#vim#ag(<q-args>, '--color-path 400 -a', fzf#vim#default_layout)

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
      "Extra space for after prompt
      execute 'call VimuxPromptCommand("'.command_bin.trimmed_function[0].' ")'
    else
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
command! -bang -nargs=* MyCommands call fzf#run({'sink': function('<sid>ProcessMyCommand'), 'source': 'cat '.$HOME.'/.config/nvim/*.cmd *.cmd 2>/dev/null'})
nnoremap <c-c> :MyCommands<cr>

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

"DAg search for text in files from DrupalRoot or working directory
command! -nargs=* DAg
  \ call fzf#vim#ag(<q-args>, extend(s:DirWithDrupalRoot(''), g:fzf#vim#default_layout))

"
"DAg search for text in files from DrupalRoot or working directory but all files
command! -nargs=* DAgAll
  \ call fzf#vim#ag(<q-args>, '-a --ignore .git', extend(s:DirWithDrupalRoot(''), g:fzf#vim#default_layout))

function! s:WithDrupalRoot()
  let root = DrupalRoot()
  return v:shell_error ? '' : root
endfunction

"DFiles command, search filenames from DrupalRoot or working directory
command! -nargs=* DFiles
  \ call fzf#vim#files(s:WithDrupalRoot())

"DGFiles command, search git files from DrupalRoot
" command! -nargs=* DGFiles call fzf#run({'source': 'git ls-files', 'dir': s:WithDrupalRoot(), 'options': '-m --prompt "Drupal GitFiles> "', 'down': '~40%'})
command! -bang -nargs=* DGFiles
  \ call fzf#vim#gitfiles(s:WithDrupalRoot())

"Unite settings
" nnoremap <c-o> :<c-u>Unite -buffer-name=outline -direction=bottom -start-insert outline<cr>

" }}} End FZF, CtrlP, Ag, Unite
" Status line --------------------------------------------------- {{{

"turn on airline to use patched style fonts
let g:airline_powerline_fonts = 1

" }}} End Status line
" NERDTree --------------------------------------------------- {{{

"map ctrl-e to show nerdtree
"@todo fix this so that if no % (e.g. startify) then it still works
function! OpenNERD()
  if bufname('') == 'Startify'
    execute 'NERDTreeToggle'
  else
    echom
    execute 'NERDTreeToggle '.expand('%:p:h')
  endif
endfunction
" map <silent> <C-e> :NERDTreeToggle %<CR>
map <silent> <C-e> :call OpenNERD()<cr>

" Switch to the directory of the open buffer
nnoremap <silent> <leader>cd :NERDTreeFind<cr>

"width
let g:NERDTreeWinSize=40

" Disable display of '?' text and 'Bookmarks' label.
let g:NERDTreeMinimalUI=1

" @todo
" Check if NERDTree is open or active
function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction

" Highlight currently open buffer in NERDTree
" autocmd BufEnter * call SyncTree()

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

let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
" let g:UltiSnipsJumpForwardTrigger="<c-n>"
" let g:UltiSnipsJumpBackwardTrigger="<c-p>"
" let g:UltiSnipsExpandTrigger = "<nop>"
" let g:ulti_expand_or_jump_res = 0
" function! ExpandSnippetOrCarriageReturn()
"     let snippet = UltiSnips#ExpandSnippetOrJump()
"     if g:ulti_expand_or_jump_res > 0
"         return snippet
"     else
"         return "\<CR>"
"     endif
" endfunction
" inoremap <expr> <CR> pumvisible() ? "<C-R>=ExpandSnippetOrCarriageReturn()<CR>" : "\<CR>"

" }}} End UltiSnips
" Deoplete --------------------------------------------------- {{{

" let g:EclimCompletionMethod = 'omnifunc'
let g:deoplete#enable_at_startup = 1
" this changes the ultisnips matching to get really short ones and use fuzzy matching
call deoplete#custom#set('ultisnips', 'matchers', ['matcher_fuzzy'])
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
" deoplete tab-complete
inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

" shift tab to go backwards
inoremap <expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
" shi

" close if open
" inoremap <expr><CR> pumvisible() ? deoplete#mappings#close_popup() : "\<CR>"

" if menu is showing then hitting enter will select the items
" inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" these keeps the menu showing as you type
" inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  " \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
" inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  " \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" let g:echodoc_enable_at_startup=1

" function IniEclim()
"   if !filereadable("~/Documents/workspace/.metadata/.lock")
"     execute '!~/Eclipse.app/Contents/Eclipse/eclimd &> /dev/null &'
"     autocmd Filetype php setlocal omnifunc=eclim#php#complete#CodeComplete
"   endif
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
nnoremap <leader>gp :Gpush<cr>
nnoremap <leader>gm :Gmove<leader>
nnoremap <leader>gb :Git branch<leader>
nnoremap <leader>go :Git checkout<leader>

function! QuickCommitMessage()
  if &ft == 'todo'
    execute 'Gcommit -m "Update todo"'
  elseif
    execute 'Gcommit -m "Update"'
  endif
endfunction
" Stage and commit the current file.
nnoremap <Leader>gg :Gwrite<cr>:call QuickCommitMessage()<cr>
" nnoremap <leader>gps :Dispatch! git push<cr>
" nnoremap <leader>gpl :Dispatch! git pull<cr>

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
let g:gutentags_ctags_exclude=['*.json', '*.css', '*.html', '*.sh', '*.yml', '*.html.twig', '*.sql', '*.md', '*.xml', '*.js', '*.phar']
" let g:gutentags_file_list_command='find vendor/symfony vendor/symfony-cmf vendor/twig vendor/psr app -type f'
let g:gutentags_cache_dir = '/Users/mjw/.config/nvim/gutentags'

"tagbar
" nmap <leader>tt :TagbarToggle<cr>

" }}} End Tag plugins
" PHP plugins --------------------------------------------------- {{{
"
"padawan completion server
" command! StartPadawan call deoplete#sources#padawan#StartServer()
" command! StopPadawan call deoplete#sources#padawan#StopServer()
" command! RestartPadawan call deoplete#sources#padawan#RestartServer()

"php folding
" nnoremap <leader>pz :EnablePHPFolds<cr>
" nnoremap <leader>pzd :DisablePHPFolds<cr>

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

"percentage size
let g:VimuxHeight="32"

"set pane to open on right
let g:VimuxOrientation = 'h'

"vagrant
nnoremap <leader>vp :VimuxPromptCommand<cr>
nnoremap <leader>vx :VimuxCloseRunner<cr>
nnoremap <leader>vo :VimuxOpenPane<cr>
nnoremap <leader>vl :VimuxRunLastCommand<cr>

" let g:VimuxRunnerIndex=3

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

" codeception setup
function! test#php#codeception#executable() abort
  " use the vbin one if it is there
  if filereadable('./vbin/codecept')
    return 'vbin/codecept'
  elseif filereadable('./bin/codecept')
    return 'bin/codecept'
  else
    return 'codecept'
  endif
endfunction
let test#php#codeception#options = '--steps --env local'

" phpunit setup
" overwrite the original phpunit executable command
function! test#php#phpunit#executable() abort
  " get the full path including filename
  let path = expand('%:p')
  " position of '/Unit/'
  let unit_pos = match(path, '/Unit/')
  if unit_pos == -1
    " we are inside functional/kernel/web so use the vbin one
    return 'vbin/phpunit'
  else
    " use the original code
    if filereadable('./vendor/bin/phpunit')
      return './vendor/bin/phpunit'
    elseif filereadable('./bin/phpunit')
      return './bin/phpunit'
    else
      return 'phpunit'
    endif
  endif
endfunction

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

"overwrite the codeception test_file / check if file is a codeception one
function! test#php#codeception#test_file(file) abort
  if a:file =~# g:test#php#codeception#file_pattern
    let drupal_tests = DrupalRoot() . '/tests'
    let path = expand('%:p:h')
    if match(path, drupal_tests) == 0
      return 1
    endif
    return 0
  endif
endfunction

nnoremap <leader>tf :TestFile<cr>
nnoremap <leader>tn :TestNearest<cr>
nnoremap <leader>ts :TestSuite<cr>
nnoremap <leader>tl :TestLast<cr>

" Run the last test with control enter
inoremap <c-cr> <Esc>:TestLast<cr>i
nnoremap <c-cr> :TestLast<cr>

" }}} End Testing
" EasyAlign --------------------------------------------------- {{{

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" }}} End EasyAlign
" Buftabline --------------------------------------------------- {{{
" turn on separators
let g:buftabline_separators=1

" }}} End Buftabline
" Loupe --------------------------------------------------- {{{

let g:LoupeVeryMagic=0

" }}} End Loupe
" Webdevicons --------------------------------------------------- {{{

"enable on nerdtree
let g:webdevicons_enable_nerdtree=1
let g:WebDevIconsUnicodeDecorateFileNodes=1
" hide the brackets, not useful
let g:webdevicons_conceal_nerdtree_brackets=1
" single width for icons
let g:WebDevIconsUnicodeGlyphDoubleWidth=0

"avoid the system call to detect OS
let g:WebDevIconsOS = 'Darwin'

augroup devicons_nerdtree
    autocmd FileType nerdtree setlocal list
    autocmd FileType nerdtree setlocal nolist
augroup END

" }}} End Webdevicons

" }}} End Plugin settings
" Mappings --------------------------------------------------- {{{

" Remapping of escape sequences
" control-enter
set <F13>=[25~
map <F13> <c-cr>
map! <F13> <c-cr>

" shift-enter
set <F14>=[27~
map <F14> <s-cr>
map! <F14> <s-cr>

" control-space
set <F15>=[29~
map <F15> <c-space>
map! <F15> <c-space>

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

"return to toggle folding
function! DoFold()
  if &buftype == 'quickfix'
    return "\<cr>"
  else
    return 'za'
  endif
endfunction
nnoremap <expr> <cr> DoFold()

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

"format in block
nnoremap <c-=> =iB

"jump to end when inserting
inoremap <c-e> <c-o>$

" move cursor left
inoremap <c-f> <Left>

" move cursor right
silent! iunmap <c-g>s
silent! iunmap <c-g>S
inoremap <c-g> <Right>

inoremap <c-l> <space>=><space>

"map alternate file switching to leader leader
nnoremap <leader><leader> <c-^>

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
nmap <silent> <leader>sv :so $MYVIMRC <bar>exe 'normal! zvzz'<cr>

"quick editing straight open or split
function! OpenOrSplit(filename)
  if bufname('') == 'Startify'
    execute 'edit' a:filename | exe 'normal! zvzz'
  else
    execute 'vsplit' a:filename | exe 'normal! zvzz'
  endif
endfunction
nnoremap <leader>ev :call OpenOrSplit($MYVIMRC)<cr>
nnoremap <leader>ed :call OpenOrSplit("~/.drush/aliases.drushrc.php")<cr>
" nnoremap <leader>ed :vsplit ~/.drush/aliases.drushrc.php<cr>
nnoremap <leader>et :call OpenOrSplit("~/.tmux.conf")<cr>
nnoremap <leader>ek :call OpenOrSplit("~/.config/karabiner/karabiner.json")<cr>
nnoremap <leader>eh :call OpenOrSplit("~/.hammerspoon/init.lua")<cr>
nnoremap <leader>ez :call OpenOrSplit("~/.zshrc")<cr>
nnoremap <leader>eu :UltiSnipsEdit<cr>

"move lines up and down
" nnoremap <leader>k :m-2<cr>==
" nnoremap <leader>j :m+<cr>==
" xnoremap <leader>k :m-2<cr>gv=gv
" xnoremap <leader>j :m'>+<cr>gv=gv

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

"fast quit, fast write
noremap <C-q> :quit<cr>
nnoremap <c-x> :wq!<cr>

"disable accidental Ex mode
nnoremap Q <nop>

"region expanding
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

"fast escape
inoremap jk <Esc>

"refresh chrome
nnoremap <silent> <leader>r :!chrome-cli reload<cr><cr>

" }}} End Mappings
" Statusline --------------------------------------------------- {{{

"@todo override filename formatting to italic.
"@todo disable stuff on the right for NERDTree
"get rid of percent?
"make modified a different colour
"something to do with number of errors from neomake
"change mode to short form
" let g:lightline#colorscheme#gruvbox

set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \     'left': [ [ 'mode', 'paste' ],
      \               [ 'fugitive', 'filename' ] ],
      \     'right': [ [ 'lineinfo' ], 
      \                [ 'fileformat', 'fileencoding', 'filetype' ] ]
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
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '|', 'right': '|' }
      \}
" some alternate sep glyph ideas
" 
" 

function! LightlineLineinfo()
  let fname = expand('%:t')
  return fname =~ 'NERD_tree' ? '' : printf('%d:%-2d', line('.'), col('.'))
endfunction

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
  return &ft !~? 'help' && &readonly ? '' : ''
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
  return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

" }}} End Statusline
" Colors --------------------------------------------------- {{{

"24bit color
set termguicolors
"dark
set background=dark
" colorscheme mustang
" colorscheme lucius
" LuciusBlack
let g:airline_theme='tomorrow'
let g:gruvbox_italic=1
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox

"colorscheme customisation
hi NeomakeWarningSignAlt ctermfg=255 gui=none guifg=#ffffff guibg=#202020
let g:neomake_warning_sign={'text': '⚠', 'texthl': 'NeomakeWarningSignAlt'}

" doesn't work yet :(
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1

" }}} End Colors
