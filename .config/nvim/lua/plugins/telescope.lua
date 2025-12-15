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

local simple_falcon_theme = vim.tbl_deep_extend('force', falcon_theme, {preview = false})

_G.get_falcon_theme = function(opts)
  local theme = falcon_theme
  theme = vim.tbl_deep_extend('force', theme, opts)

  return theme
end

return {
  { 'nvim-lua/popup.nvim', event = 'VeryLazy'},
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    cmd = 'Telescope',
    dependencies = {
      {'nvim-lua/plenary.nvim'},
      {'nvim-telescope/telescope-fzf-native.nvim', build = 'make'},
      {'nvim-telescope/telescope-symbols.nvim'}
    },
    keys = {
      {'<leader>,', '<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>', desc = 'Switch buffer'},
      {'<c-p>', "<cmd>lua require'telescope.builtin'.find_files(falcon_theme)<cr>", noremap = true, desc = 'Find files' },
      {'<c-s-p>', "<cmd>lua require'telescope.builtin'.find_files(get_falcon_theme({hidden = true, no_ignore=true}))<cr>", noremap = true, desc = 'Find all files' },
      {'<leader>fh', "<cmd>lua require'telescope.builtin'.oldfiles(falcon_theme)<cr>", silent = true, noremap = true, desc = 'Find old files'},
      {'<leader>fc', "<cmd>lua require'telescope.builtin'.commands(falcon_theme)<cr>", silent = true, noremap = true, desc = 'Find commands'},
      {'<leader>fm', "<cmd>lua require'telescope.builtin'.keymaps(simple_falcon_theme)<cr>", silent = true, noremap = true, desc = 'Find key maps'},
      {'<leader>T', "<cmd>Telescope lsp_document_symbols<cr>", silent = true, noremap = true, desc = 'Find symbols'},
      {'<c-t>', "<cmd>lua require'telescope.builtin'.tags(get_falcon_theme({show_line = true}))<cr>", silent = true, noremap = true, desc = 'Find tags'},
      {'<leader>fr', "<cmd>lua require'telescope.builtin'.registers(falcon_theme)<cr>", silent = true, noremap = true, desc = 'Show registers'},
      {'<leader>fs', "<cmd>lua require'telescope.builtin'.symbols{ sources = {'emoji', 'kaomoji', 'gitmoji'} }<cr>", silent = true, noremap = true, desc = 'Find symbols'},
      {'<leader>fq', "<cmd>lua require'telescope.builtin'.quickfixhistory<cr>", silent = true, noremap = true, desc = 'Find in quickfix history'},
      {'<leader>fb', "<cmd>lua require'telescope.builtin'.buffers(simple_falcon_theme)<cr>", silent = true, noremap = true, desc = 'Find in buffers'},
      {'//', "<cmd>lua require'telescope.builtin'.current_buffer_fuzzy_find(simple_falcon_theme)<cr>", silent = true, noremap = true, desc = 'Find buffer'},
      {'<leader>?', "<cmd>lua require'telescope.builtin'.help_tags(simple_falcon_theme)<cr>", silent = true, noremap = true, desc = 'Find in help'},
      {'<leader>:', "<cmd>lua require'telescope.builtin'.command_history(simple_falcon_theme)<cr>", silent = true, noremap = true, desc = 'Find in comand history'},
      {'<leader>/', "<cmd>lua require'telescope.builtin'.search_history(simple_falcon_theme)<cr>", silent = true, noremap = true, desc = 'Find in comand history'},
      {'<leader>s', "<cmd>lua require'telescope.builtin'.grep_string(get_falcon_theme({search = vim.fn.input('Search > ')}))<cr>", silent = true, desc = 'Search in files'},
      {'<leader>S', "<cmd>lua require'telescope.builtin'.grep_string(get_falcon_theme({search = vim.fn.input('Search all > '), additional_args = { '--hidden', '--no-ignore', '--glob', '!.git' }}))<cr>", silent = true, desc = 'Search in all files'},
      {'<leader>w', "<cmd>lua require'telescope.builtin'.grep_string(falcon_theme)<cr>", silent = true, desc = 'Search word in files'},
      {'<leader>W', "<cmd>lua require'telescope.builtin'.grep_string(get_falcon_theme({additional_args = {'--hidden', '--no-ignore', '--glob', '!.git'}}))<cr>", silent = true, desc = 'Search word in all files'},
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
              ['<esc>'] = actions.close,
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
