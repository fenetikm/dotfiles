local g = vim.g
-- g['tcomment#blank_lines'] = 0
-- g['tcomment#strip_on_uncomment'] = 2
-- g.tcomment_mapleader1 = '<F17>'
--
require('Comment').setup({
      ---Add a space b/w comment and the line
      padding = true,
      ---Whether the cursor should stay at its position
      sticky = true,
      ---Lines to be ignored while (un)comment
      ignore = nil,
      ---LHS of toggle mappings in NORMAL mode
      toggler = {
            ---Line-comment toggle keymap
            line = '<F17>',
            ---Block-comment toggle keymap
            block = 'gbc',
      },
      ---LHS of operator-pending mappings in NORMAL and VISUAL mode
      opleader = {
            ---Line-comment keymap
            line = '<F17>',
            ---Block-comment keymap
            block = 'gb',
      },
      ---LHS of extra mappings
      extra = {
            ---Add comment on the line above
            above = 'gcO',
            ---Add comment on the line below
            below = 'gco',
            ---Add comment at the end of line
            eol = 'gcA',
      },
      ---Enable keybindings
      ---NOTE: If given `false` then the plugin won't create any mappings
      mappings = {
            ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
            basic = true,
            ---Extra mapping; `gco`, `gcO`, `gcA`
            extra = true,
      },
      ---Function to call before (un)comment
      pre_hook = nil,
      ---Function to call after (un)comment
      post_hook = nil,
})
