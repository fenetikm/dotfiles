return {
  {
    "echasnovski/mini.comment",
    lazy = false,
    event = "VimEnter",
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function()
      require("mini.comment").setup({
        options = {
          custom_commentstring = function()
            return require("ts_context_commentstring").calculate_commentstring()
                or vim.bo.commentstring
          end,
          ignore_blank_line = false,
          start_of_line = false,
          pad_comment_parts = true,
        },
        mappings = {
          -- Default mappings for commenting
          comment = "<c-/>",
          comment_line = "<c-/>",
          comment_visual = "<c-/>",
          textobject = "gc",
        },
        hooks = {
          -- Hooks that run pre and post commenting actions
          pre = function() end,
          post = function() end,
        },
      })
    end,
  }
}
