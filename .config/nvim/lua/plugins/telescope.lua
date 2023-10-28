local function on_load(name, fn)
  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyLoad",
    callback = function(event)
      if event.data == name then
        fn(name)
        return true
      end
    end,
  })
end

return {
  { 'nvim-lua/popup.nvim', event = 'VeryLazy'},
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.4',
    cmd = 'Telescope',
    dependencies = {
      {'nvim-lua/plenary.nvim'},
      {'nvim-telescope/telescope-fzf-native.nvim', build = 'make'},
    },
    config = function ()
      local actions = require('telescope.actions')
      local action_state = require('telescope.actions.state')
      require("telescope").load_extension("fzf")

      -- append the selected tag
      local entry_append = function(prompt_bufnr)
        local entry = {action_state.get_selected_entry().tag}
        actions.close(prompt_bufnr)
        local mode = vim.api.nvim_get_mode().mode
        if mode == 'i' then
          vim.api.nvim_put(entry, '', false, true)
          vim.api.nvim_feedkeys('a', 'n', true)
        else
          vim.api.nvim_put(entry, '', true, true)
        end
      end

      require('telescope').setup {
        defaults = {
          color_devicons = false,
          mappings = {
            i = {
              ['<c-s>'] = actions.select_horizontal,
              ['<c-cr>'] = entry_append,
            },
          },
          winblend = 5,
          -- layout_strategy = "bottom_pane",
          layout_config = {
            height = 40,
            prompt_position = "bottom",
            width = 0.8,
          },
          borderchars = {
            prompt = {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
            results = {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
            preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          },
          prompt_prefix = '=> ',
        },
        extensions = {
          fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
          }
        }
      }
    end
  }
}
