return {
  {
    'numToStr/Comment.nvim',
    event = 'VimEnter',
    keys = {
      {'<c-/>', function () require('Comment.api').toggle.linewise.current() end, desc = 'Toggle comment for line'},
      {'<c-/>', function ()
         local esc = vim.api.nvim_replace_termcodes(
              '<ESC>', true, false, true
          )
        vim.api.nvim_feedkeys(esc, 'nx', false)
        require('Comment.api').toggle.linewise(vim.fn.visualmode())
      end, mode = 'x', desc = 'Toggle comments visual mode'},
      {'gb', function ()
         local esc = vim.api.nvim_replace_termcodes(
              '<ESC>', true, false, true
          )
        vim.api.nvim_feedkeys(esc, 'nx', false)
        require('Comment.api').toggle.blockwise(vim.fn.visualmode())
      end, mode = 'x', desc = 'Toggle comments visual mode, block'}
    },
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function ()
      return {
        padding = true, ---Add a space b/w comment and the line
        sticky = true, ---Whether the cursor should stay at its position
        ignore = nil, ---Lines to be ignored while (un)comment
        toggler = { ---LHS of toggle mappings in NORMAL mode
          line = '<c-/>', ---Line-comment toggle keymap
          block = 'gbc', ---Block-comment toggle keymap
        },
        opleader = { ---LHS of operator-pending mappings in NORMAL and VISUAL mode
          line = '<c-/>', ---Line-comment keymap
          block = 'gb', ---Block-comment keymap
        },
        extra = { ---LHS of extra mappings
          above = 'gcO', ---Add comment on the line above
          below = 'gco', ---Add comment on the line below
          eol = 'gcA', ---Add comment at the end of line
        },
        ---Enable keybindings
        ---NOTE: If given `false` then the plugin won't create any mappings
        mappings = {
          basic = true, ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
          extra = false, ---Extra mapping; `gco`, `gcO`, `gcA`
        },
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
        post_hook = nil, ---Function to call after (un)comment
      }
    end
  }
}
