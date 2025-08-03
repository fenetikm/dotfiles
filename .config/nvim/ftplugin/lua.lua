-- when splitting and joining
-- ignore the warning re MiniSplitjoin
local gen_hook = MiniSplitjoin.gen_hook
local curly = { brackets = { '%b{}' } }

local add_comma_curly = gen_hook.add_trailing_separator(curly)
local del_comma_curly = gen_hook.del_trailing_separator(curly)

local pad_curly = gen_hook.pad_brackets(curly)

vim.b.minisplitjoin_config = {
  split = { hooks_post = { add_comma_curly } },
  join  = { hooks_post = { del_comma_curly, pad_curly } },
}
