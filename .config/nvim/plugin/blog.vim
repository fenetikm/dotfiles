let g:blog_api_key = $BLOGAPIKEY
let g:blog_url = $BLOGURL
let g:blog_path = $BLOGPATH

function! s:BlogLoad(l)
  if a:l =~ '\[\d\+\]'
    let id = split(a:l, '\[')
    let id = split(id[1], '\]')
    let id = id[0]
  elseif a:l =~ '^\d\+$'
    let id = a:l
  else
    echoe "Can't load blog post with that ID"
    return
  endif
  execute 'new | only'
  execute 'r ! wget --header="api-key: '.g:blog_api_key.'" -q -O - '.g:blog_url.'/front-matter/fetch/id/'.id. ' | tr -d "\r"'
  execute 'set ft=markdown'
endfunction

command! -bang -nargs=* BlogLoad call fzf#run({'sink': function('<sid>BlogLoad'), 'source': 'wget --header="api-key: '.g:blog_api_key.'" -q -O - '.g:blog_url.'/front-matter/list'})

" Load directly by id
command! -nargs=* BlogId call <sid>BlogLoad(<f-args>)

function! s:BlogLoadReplace(l)
  let id = a:l
  let output = systemlist('wget --header="api-key: '.g:blog_api_key.'" -q -O - '.g:blog_url.'/front-matter/fetch/id/'.id)
  execute 'set ft=markdown'
  normal! ggVGd
  call append(0, output)
endfunction

function! s:BlogPostAsync()
  let g:asyncrun_exit = 'call BlogPostAsyncFinish()'
  execute '%AsyncRun curl -s -X POST -H "api-key: '.g:blog_api_key.'" --data-binary @- '.g:blog_url.'/front-matter/post'
endfunction
command! BlogPostAsync call <sid>BlogPostAsync()

function! BlogPostAsyncFinish()
  let g:asyncrun_exit = ''
  let qf = getqflist()
  let output = qf[1].text
  if output =~ '^Error.\+$'
    " Do nothing, can read quickfix
  elseif output =~ '^Success.\+$'
    " Close quickfix? maybe that could be a configuration option
    let pid = split(output, '\[')
    let pid = pid[1]
    let id = split(pid, '\]')
    let id = id[0]
    call <sid>BlogLoadReplace(id)
  endif
endfunction

" This works but replaces, a bit destructive
function! s:BlogPost()
  let buff=join(getline(1, '$'), "\n")
  let output = system('curl -s -X POST -H "api-key: '.g:blog_api_key.'" --data-binary @- '.g:blog_url.'/front-matter/post', buff)
  if output =~ 'Success.\+'
    let pid = split(output, '\[')
    let pid = pid[1]
    let id = split(pid, '\]')
    let id = id[0]
    call <sid>BlogLoadReplace(id)
  else
    echoe output
  endif
endfunction
command! BlogPost call <sid>BlogPost()

function s:BlogNew(...)
  let arg = get(a:, 1, '')
  if arg == ''
    call inputsave()
    let s:FileName = input('File name for post (.md): ')
    call inputrestore()
    let arg = s:FileName
  endif
  let s:FullFile = g:blog_path . arg
  if !empty(glob(s:FullFile))
    echoe "\nFile exists."
    return
  endif
  execute 'new | only'
  execute 'w ' . s:FullFile
  normal! gg
  execute 'set filetype=markdown'
  " Maybe the template should be part of the plugin instead...
  call feedkeys('ifb')
  call feedkeys("\<c-j>", 'x')
endfunction
command! -nargs=* BlogNew call <sid>BlogNew(<f-args>)

" Tag completion
inoremap <expr> <c-x><c-t> fzf#vim#complete('wget --header="api-key: '.g:blog_api_key.'" -q -O - '.g:blog_url.'/front-matter/tags')
