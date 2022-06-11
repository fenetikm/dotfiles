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
" inoremap <silent> <c-x><c-x> <c-r>=<sid>ListSnippetsForCurrentFt()<cr>
" not that handy?

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
" inoremap <s-cr> <c-r>=(<sid>ExpandShortestMatchingSnippet() == 0 ? '' :UltiSnips#ExpandSnippet())<cr>

let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
