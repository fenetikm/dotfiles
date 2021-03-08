if !exists('g:test#php#phpunit#test_patterns')
  " Description for the tests:
  " 1: Look for a public method which name starts with "test"
  " 2: Look for a phpdoc tag "@test" (on a line by itself)
  " 3: Look for a phpdoc block on one line containg the "@test" tag
  let g:test#php#phpunit#test_patterns = {
    \ 'test': [
      \ '\v^\s*public function (test\w+)\(',
      \ '\v^\s*\*\s*(\@test)',
      \ '\v^\s*\/\*\*\s*(\@test)\s*\*\/',
    \],
    \ 'namespace': [],
  \}
endif

" Returns true if the given file belongs to your test runner
function! test#php#megarunner#test_file(file) abort
  if exists('g:php_test_runner_file')
    return g:php_test_runner_file
  endif
  " fallback
  return a:file =~# g:test#php#phpunit#file_pattern
endfunction

" Returns test runner's arguments which will run the current file and/or line
function! test#php#megarunner#build_position(type, position) abort
  if !exists('g:php_test_runner_type')
    let g:php_test_runner_type = 'unit'
  endif

  if a:type ==# 'nearest'
    let testname = s:nearest_test(a:position)
    let filename = a:position['file']
    if g:php_test_runner_type ==? 'unit'
      if !empty(testname) | let filename = '--method ' . shellescape(':' . testname, 1) . ' ' . filename | endif
    else
      if !empty(testname) | let filename .= ':' . testname | endif
    endif
    return [filename]
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

" Returns processed args (if you need to do any processing)
function! test#php#megarunner#build_args(args) abort
  let args = a:args

  " if !test#base#no_colors()
  "   let args = ['--colors'] + args
  " endif

  return args
endfunction

" Returns the executable of your test runner
function! test#php#megarunner#executable() abort
  let l:exe_name = ''
  try
    let l:exe_name = PHPTestRunnerExecutable()
  catch
    " doesn't exist
    if exists('g:php_test_runner_executable')
      return g:php_test_runner_executable
    endif
    return ''
  endtry
  return l:exe_name
endfunction

" Taken from phpunit.vim
function! s:nearest_test(position) abort
  if !exists('g:php_test_runner_type')
    let g:php_test_runner_type = 'unit'
  endif

  if g:php_test_runner_type ==? 'unit'
    " Search backward for the first public method starting with 'test' or the first '@test'
    let name = test#base#nearest_test(a:position, g:test#php#phpunit#test_patterns)

    " If we found the '@test' docblock
    if !empty(name['test']) && '@test' == name['test'][0]
      " Search forward for the first declared public method
      let name = test#base#nearest_test_in_lines(
        \ a:position['file'],
        \ name['test_line'],
        \ a:position['line'],
        \ g:test#php#patterns
      \ )
    endif

    return join(name['test'])
  elseif g:php_test_runner_type ==? 'acceptance'
    let name = test#base#nearest_test(a:position, g:test#php#patterns)
    return join(name['test'])
  endif
endfunction
