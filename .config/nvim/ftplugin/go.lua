-- Go loves da tab, hide showing something for it
vim.opt_local.listchars = vim.o.listchars .. ',tab:  '

-- when splitting and joining
-- ignore the warning re MiniSplitjoin
local gen_hook = MiniSplitjoin.gen_hook
local curly = { brackets = { '%b{}' } }
local parens = { brackets = { '%b()' } }

local add_comma_curly = gen_hook.add_trailing_separator(curly)
local del_comma_curly = gen_hook.del_trailing_separator(curly)

local add_comma_parens = gen_hook.add_trailing_separator(parens)
local del_comma_parens = gen_hook.del_trailing_separator(parens)

vim.b.minisplitjoin_config = {
  split = { hooks_post = { add_comma_curly, add_comma_parens } },
  join  = { hooks_post = { del_comma_curly, del_comma_parens } },
}
