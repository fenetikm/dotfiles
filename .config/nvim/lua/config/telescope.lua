local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

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

require('telescope').load_extension('fzf')

-- todo: cutoff
-- todo: position the whole thing towards the bottom PR
-- todo: highlighting on just the prompt PR

local falcon_theme = {
  theme = 'falcon',
  layout_strategy = 'horizontal',
  sorting_strategy = 'descending',
  winblend = 5,
  preview = true,
  layout_config = {
    preview_cutoff = 120,
    width = 0.8,
    height = 40,
    prompt_position = "bottom"
  },
  prompt_title = '',
  results_title = '',
  prompt_prefix = '=> ',
  border = true,
  borderchars = {
      prompt = {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
      results = {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
      preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
  },
}

_G.falcon = {}
_G.falcon.get_full_theme = function(opts)
  local theme = falcon_theme
  return vim.tbl_deep_extend('force', theme, opts)
end

_G.falcon.get_simple_theme = function(opts)
  local theme = falcon_theme
  theme = vim.tbl_deep_extend('force', theme, opts)
  theme.preview = false
  return theme
end
