local g = vim.g
vim.cmd[[
let g:ale_javascript_eslint_use_global = 0

let g:ale_linters = {
      \   'php': ['phpcs', 'phpmd'],
      \   'javascript': ['eslint'],
      \   'javascript.jsx': ['eslint'],
      \}
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_php_phpcs_standard = 'Drupal'
let g:ale_sign_error=''
let g:ale_sign_info=''
let g:ale_sign_warning=''
]]
