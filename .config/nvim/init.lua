require ('keys.escape')

require ('plugins')
require ('plugins.lsp')

require ('general.settings')
require ('general.folding')
require ('general.filetypes')
require ('general.auto_buffers')
require ('general.commands')

require ('keys.toggle')
require ('keys.searchreplace')
require ('keys.mappings')

-- markdown
vim.cmd([[
  "highlight frontmatter
  let g:vim_markdown_frontmatter = 1

  "strikethrough support, with two tildes ~~
  let g:vim_markdown_strikethrough = 1

  " .md not required in links
  let g:vim_markdown_no_extensions_in_markdown = 1

  " bullets and indenting is covered by bullets.vim
  " disable new line bullets
  let g:vim_markdown_auto_insert_bullets = 0

  "disable the indenting
  let g:vim_markdown_new_list_item_indent = 0

  "save file when following a link
  let g:vim_markdown_autowrite = 1

  let g:vim_markdown_folding_style_pythonic = 1
]])

-- colour handling goes here

vim.opt.background = 'dark'
vim.g.colors_name = 'falcon'
vim.g.falcon_settings = {
  italic_comments = true,
  bold = true,
  undercurl = true,
  underline_for_undercurl = false,
  transparent_bg = false,
  inactive_bg = false,
  lsp_background = true,
  variation = 'zen',
}

package.loaded['falcon'] = nil
require('lush')(require('falcon').setup())

vim.cmd([[
  " set cursors depending on mode
  set t_SI=[6\ q
  set t_SR=[4\ q
  set t_SR=[2\ q
]])
