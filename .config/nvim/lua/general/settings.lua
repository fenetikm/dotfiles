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

vim.o.splitbelow = true --horizontal split shows up below
vim.o.previewheight = 10 --preview window height

vim.g.mapleader = " "
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

vim.o.fillchars = ''
vim.o.fillchars = vim.o.fillchars .. 'vert:┃' -- vertical sep fill character
vim.o.fillchars = vim.o.fillchars .. ',fold:' -- fold fill character
vim.o.fillchars = vim.o.fillchars .. ',diff:╱' -- diff fill background character
vim.o.fillchars = vim.o.fillchars .. ',stl:┅,stlnc:┅' -- status line fill character

vim.o.ruler = true --show column/row/line number position
vim.o.number = true --show line numbers
vim.o.relativenumber = true --show numbers relative to current line number
vim.o.signcolumn = 'yes' --always have room for sign columns
vim.o.cmdheight = 2 --height of the command bar
vim.o.laststatus = 2 --always give a window a statusline
vim.o.backspace = 'eol,start,indent' --delete over end of line, autoindent, start of insert
vim.o.whichwrap = 'b,s,<,>,[,],h,l' --which keys move to the next / previous line when at end / start
vim.o.joinspaces = false -- don't insert two spaces after . or ?

vim.o.shortmess = '' -- simplify messages
vim.o.shortmess = vim.o.shortmess .. 't' -- truncate file messages that are too long
vim.o.shortmess = vim.o.shortmess .. 'T' -- truncate in the middle if too long
vim.o.shortmess = vim.o.shortmess .. 'o' -- overwrite message for writing to a file
vim.o.shortmess = vim.o.shortmess .. 'O' -- reading file message overwrites previous
vim.o.shortmess = vim.o.shortmess .. 'C' -- don't give scanning messages
vim.o.shortmess = vim.o.shortmess .. 'F' -- don't give info when editing file
vim.o.shortmess = vim.o.shortmess .. 'A' -- don't give attention messages e.g. swapfile
vim.o.shortmess = vim.o.shortmess .. 'W' -- don't give written message
vim.o.shortmess = vim.o.shortmess .. 'a' -- use all abbreviations e.g. [RO]
vim.o.shortmess = vim.o.shortmess .. 'c' -- don't give ins-completion-menu messages
vim.o.shortmess = vim.o.shortmess .. 'x' -- short versions for dos,unix,mac

vim.o.synmaxcol = 600 --maximum line length to syntax highlight

vim.o.showbreak = '↳' --when there is a break, show this character

vim.o.virtualedit = 'block' --allow cursor to go anywhere when in visual block mode

vim.o.fileformat = 'unix' --default file format for a file, affects line break character(s)

vim.o.updatetime = 200 --ms between writing swap file and for CursorHold autocommand

vim.o.pumblend = 10 --popup menu blend amount

-- Wildmenu
vim.o.wildmode = 'longest:full,full'
vim.o.wildmenu = true
vim.o.wildignorecase = true
vim.o.wildignore = '.hg,.git,.svn'
vim.o.wildignore = vim.o.wildignore .. '*.jpg,*.jpeg,*.bmp,*.gif,*.png'
vim.o.wildignore = vim.o.wildignore .. '*.sw?'
vim.o.wildignore = vim.o.wildignore .. '*.DS_Store'
vim.o.wildignore = vim.o.wildignore .. 'log/**'
vim.o.wildignore = vim.o.wildignore .. 'tmp/**'
vim.o.wildignore = vim.o.wildignore .. 'vendor/cache/**'

-- Search
vim.o.infercase = true --adjust case when searching
vim.o.ignorecase = true --ignore case when searching
vim.o.smartcase = true --use case searching if uppercase in query
vim.o.hlsearch = true --highlight search results
vim.o.incsearch = true --incremental search, doesn't required enter
vim.o.inccommand = 'nosplit' --show replacements live
vim.o.magic = true --more "normal" regex matching
vim.o.showmatch = true --show matching parens, brackets, braces when cursor is on one
vim.o.mat = 2 --tenths of a second to show match

vim.o.completeopt = 'menuone,noselect' --show popupmenu when one or more completions
                                       --don't select any completions by default

vim.o.shada = '!,\'100,<50,s10,h,%' -- shared data file settings
                                     -- save global variables with uppercase
                                     -- save buffer list
                                     -- 100 previous file marks, disable hlsearch effect
                                     -- 50 line max for registers
                                     -- 10kb max for any item
