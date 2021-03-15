local g = vim.g

-- enable for NERDTree
g.webdevicons_enable_nerdtree = 1
g.WebDevIconsUnicodeDecorateFileNodes = 0

-- hide the ugly brackets
g.webdevicons_conceal_nerdtree_brackets = 1

-- single width for icons
g.WebDevIconsUnicodeGlyphDoubleWidth = 0

-- show the folder glyph
g.WebDevIconsUnicodeDecorateFolderNodes = 1
g.DevIconsEnableFoldersOpenClose = 1
g.WebDevIconsOS = 'Darwin'

vim.cmd [[autocmd FileType nerdtree setlocal list]]
vim.cmd [[autocmd FileType nerdtree setlocal nolist]]
vim.cmd[[
" after a re-source, fix syntax matching issues (concealing brackets):
if exists('g:loaded_webdevicons')
  "check for nerdtree loaded
  if exists('g:NERTTreeIgnore')
    call webdevicons#refresh()
  endif
endif
]]
