local ts_configs = require('nvim-treesitter.configs')
ts_configs.setup {
  ensure_installed = {
    'bash', 'c', 'cpp', 'css', 'go', 'html',
    'javascript', 'json', 'lua', 'python',
    'rust', 'toml', 'typescript', 'elixir', 'php', 'java'
  },
  highlight = {
    enable = true,
    -- enable = true,
    -- disable = {'php', 'css', 'javascript'},
  },
  indent = { enable = true },
  incremental_selection = {
    enable = false,
    -- keymaps = {
    --   init_selection = '<c-space>',
    --   node_incremental = '<c-space>',
    --   scope_incremental = 'gns',
    --   node_decremental = '<c-backspace>',
    -- }
  },
  move = {
    enable = true,
    set_jumps = true, -- whether to set jumps in the jumplist
    goto_next_start = {
      [']m'] = '@function.outer',
      [']]'] = '@class.outer',
    },
    goto_next_end = {
      [']M'] = '@function.outer',
      [']['] = '@class.outer',
    },
    goto_previous_start = {
      ['[m'] = '@function.outer',
      ['[['] = '@class.outer',
    },
    goto_previous_end = {
      ['[M'] = '@function.outer',
      ['[]'] = '@class.outer',
    },
  },
  -- refactor = {
  --   smart_rename = {enable = true, keymaps = {smart_rename = "grr"}},
  --   highlight_definitions = {enable = true}
  --   -- highlight_current_scope = { enable = true }
  -- },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ['iF'] = {
          python = '(function_definition) @function',
          cpp = '(function_definition) @function',
          c = '(function_definition) @function',
          java = '(method_declaration) @function'
        },
        -- or you use the queries from supported languages with textobjects.scm
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
      }
    }
  }
}
