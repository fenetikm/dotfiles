require('disable_builtin')
require('bootstrap_lazy')

-- haven't yet worked out where to put these but here works
-- todo: replace with exrc
vim.g.localvimrc_ask = 0
vim.g.localvimrc_sandbox = 0

require('settings')
require('plugin_setup')
require('general')
require('keys')

-- todo: what are these, push to falcon?
-- vim.api.nvim_set_hl(0, "TextInfo", { fg = "#e0def4" })
-- vim.api.nvim_set_hl(0, "TextMuted", { fg = "#6e6a86" })
