vim.cmd([[
    " from https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
    set grepprg=rg\ --vimgrep\ -uu\ --smart-case

    function! Grep(...)
      return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
    endfunction

    command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<f-args>)
    command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr Grep(<f-args>)

    cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
    cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() ==# 'lgrep') ? 'LGrep' : 'lgrep'

    augroup quickfix
      autocmd!
      autocmd QuickFixCmdPost cgetexpr cwindow
      autocmd QuickFixCmdPost lgetexpr lwindow
    augroup END

    "replace
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

    " let g:FerretMap=0

    " let g:agriculture#rg_options='--colors "path:fg:239" --colors "match:fg:252" --colors "line:fg:254"'
    " let g:agriculture#fzf_extra_options='--no-bold --color=hl:7,hl+:3 --prompt="=> "'

    " nnoremap <leader>s :Rg<space>
    " nnoremap <silent> <leader>fg <cmd>lua require'telescope.builtin'.live_grep(_G.falcon_telescope.get_full_theme({}))<cr>
    " nmap <silent> <leader>s <cmd>lua require'telescope.builtin'.grep_string(_G.falcon_telescope.get_full_theme({ search = vim.fn.input('Search > ') }))<cr>
    " todo get the full ignore working
    " nmap <silent> <leader>S <cmd>lua require'telescope.builtin'.grep_string(_G.falcon_telescope.get_full_theme({ search = vim.fn.input('Search all > '), no_ignore = true, hidden = true}))<cr>
    " :lua require('telescope.builtin').grep_string{ search = vim.fn.input('Grep for > ' ) })
    " nmap <leader>s <Plug>RgRawSearch
    " nmap <leader>S <Plug>RgRawAllSearch
    " xmap <leader>s <Plug>RgRawVisualSelection<cr>
    " nmap <silent> <leader>k <cmd>lua require'telescope.builtin'.grep_string(_G.falcon_telescope.get_full_theme({}))<cr>
    " nmap <silent> <leader>k <Plug>RgRawWordUnderCursor<cr>
    " nmap <silent> <leader>K <Plug>RgRawAllWordUnderCursor<cr>

    "replace across files
    " nmap <silent> <leader>R <Plug>(FerretAcks)
    " nmap <silent> <leader>

    "highlight matches in place with g*, doesn't work?
    " nnoremap <silent> g* :let @/='\<'.expand('<cword>').'\>'<CR>
    " xnoremap <silent> g* "sy:let @/=@s<CR>

    " }}} Searching and replacing [leader s*] "
]])
