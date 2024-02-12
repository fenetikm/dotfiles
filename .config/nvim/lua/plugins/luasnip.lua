return {
  'L3MON4D3/LuaSnip',
  version = 'v2.*',
  event = 'VeryLazy',
  config = function ()
    local ls = require'luasnip'
    local types = require'luasnip.util.types'

    require('luasnip').setup({
      store_selection_keys = '<c-s-j>', --to store a visual selection to use in a snippet
      update_events = 'TextChanged,TextChangedI', -- for repeated placeholders to update
      -- enable_autosnippets = true,
      ext_opts = {
        [types.choiceNode] = {
          active = {
            virt_text = { { "<-", "Error"} }
          }
        }
      }
    })

    require('luasnip.loaders.from_snipmate').lazy_load({paths = {'~/.config/nvim/snippets/snipmate'}})
    require('luasnip.loaders.from_lua').lazy_load({paths = {'~/.config/nvim/snippets/LuaSnip'}})

    vim.keymap.set({'i', 's'}, '<c-j>',
      function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end, {silent = true, desc = 'Expand or jump'})
    vim.keymap.set({'i', 's'}, '<c-k>', function() ls.jump(-1) end, {silent = true, desc = 'LuaSnip backward jump'})
    vim.keymap.set({'i'}, '<c-l>',
      function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, {desc = 'Change choice'})
  end,
}
