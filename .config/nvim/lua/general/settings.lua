vim.o.compatible = false --disable compatibility with vi
vim.o.scrolloff = 5 --set number of lines to show above and below cursor
vim.o.sidescrolloff=5 -- same as scrolloff, but for columns
vim.o.history = 999 --number of lines of history
vim.o.cursorline = true --highlight the line the cursor is on
vim.o.clipboard = 'unnamed' --for copy and paste, anonymous register aliased to * register
vim.o.autoread = true --set to auto read when a file is changed from the outside
vim.o.report = 0 --Always report line changes
vim.o.mouse = 'nv' -- mouse only enabled in normal and visual
vim.o.showcmd = false --hide the command showing in the status
vim.o.nrformats = "" --force decimal-based arithmetic
vim.o.termguicolors = true --24bitcolors
vim.o.errorbells = false --no annoying beeps
vim.o.visualbell = false --no screen flashes on errors
vim.o.timeoutlen = 1000 --timeout for leader key
vim.o.ttimeoutlen = 5 --timeout for key code delays
vim.o.showmode = false --hide showing which mode we are in, the status bar is fine

vim.o.fcs = "vert:│" -- Solid line for vsplit separator

vim.o.splitbelow = true --horizontal split shows up below
vim.o.previewheight = 10 --preview window height

vim.g.mapleader = "<Space>"
vim.g.maplocalleader = ","

vim.o.encoding = "utf-8" -- standard encoding
vim.o.hidden = true -- hide buffers instead of closing them
vim.o.expandtab = true --substitute tabs with spaces
vim.o.smarttab = true --delete spaces when appropriate
vim.o.shiftwidth = 2 --how far to shift when indenting
vim.o.tabstop = 2 --how many columns does a tab count for
vim.o.lbr = true --enable linebreaking
vim.o.breakindent = true --indent lines that are broken
vim.o.breakindentopt = "shift:1" --when breaking, shift by 1 column to emphasise the break
vim.o.tw = 0 --max width of text being inserted, a lower number will be broken by this number
vim.o.autoindent = true --copy indent from current line when starting new line
vim.o.wrap = true --wrap visually, don't actually change file

vim.o.list = true
vim.o.listchars = ''
vim.o.listchars = vim.o.listchars .. 'nbsp:⦸'
vim.o.listchars = vim.o.listchars .. ',tab:▷┅'
vim.o.listchars = vim.o.listchars .. ',extends:»'
vim.o.listchars = vim.o.listchars .. ',precedes:«'
vim.o.listchars = vim.o.listchars .. ',trail:•'

vim.cmd([[
    filetype plugin indent on "use indentation scripts per filetype

    " syntax enable "enable syntax highlighting

    " set guifont=FiraCode-Regular:h14

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

    " set encoding=utf-8 "set utf8 as standard encoding

    " set hidden "hide buffers instead of closing them

    " set expandtab "substitute tabs with spaces
    " set smarttab "be smart about using tabs, delete that many spaces when appropriate
    " set shiftwidth=2 "how far to shift with <,>
    " set tabstop=2 "how many columns does a tab count for
    " set lbr "enable linebreaking
    " set breakindent "indent lines that are broken
    " set breakindentopt=shift:1 "set the indent shift to one space
    " set tw=500 "set textwidth to 500 to auto linebreak with really long lines
    " set autoindent "copy indentation from line above
    "set smartindent "indent if not handled by plugins, disabled since plugins!
    " set wrap "wrap visually, don't actually change the file
    " set list                              " show whitespace
    " set listchars=nbsp:⦸                  " CIRCLED REVERSE SOLIDUS (U+29B8, UTF-8: E2 A6 B8)
    " set listchars+=tab:▷┅                 " WHITE RIGHT-POINTING TRIANGLE (U+25B7, UTF-8: E2 96 B7)
    " + BOX DRAWINGS HEAVY TRIPLE DASH HORIZONTAL (U+2505, UTF-8: E2 94 85)
    " set listchars+=extends:»              " RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00BB, UTF-8: C2 BB)
    " set listchars+=precedes:«             " LEFT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00AB, UTF-8: C2 AB)
    " set listchars+=trail:•                " BULLET (U+2022, UTF-8: E2 80 A2)

    set fillchars=vert:┃
    set fillchars+=fold:
    set fillchars+=diff:╱
    " set fillchars+=fold:<space>

    set ruler "show column/row/line number position
    set number "show line numbers
    set relativenumber "set to relative number mode
    set signcolumn=yes "always have room for a sign by default
    set cmdheight=2 "height of the command bar
    set laststatus=2 "always show status line
    set backspace=eol,start,indent "delete over end of line, autoindent, start of insert
    set whichwrap+=<,>,h,l,[,] "wrap with cursor keys and h and l
    " set nowrapscan "don't wrap search scanning

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
    set shortmess+=c                      " don't echo completion messages
    set shortmess+=x                      " short versions for dos,unix and mac

    set synmaxcol=600                     " Don't try to highlight lines longer than 600 characters.

    if has('linebreak')
      let &showbreak='↳'                 " DOWNWARDS ARROW WITH TIP RIGHTWARDS (U+21B3, UTF-8: E2 86 B3)
    endif

    if has('virtualedit')
      set virtualedit=block               " allow cursor to move where there is no text in visual block mode
    endif

    set fileformat=unix                   "default fileformat

    set updatetime=200                    "set the max time to update 200ms, gitgutter mainly

    set pumblend=5                        "make the pop up menu slightly transparent

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

    set completeopt=menuone,noselect
]])
