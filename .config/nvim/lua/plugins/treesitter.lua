return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    -- event = { 'VeryLazy' },
    init = function()
      -- use treesitter on these
      vim.api.nvim_create_autocmd('FileType', {
        pattern = {
          'bash', 'c', 'cpp', 'css', 'go', 'html',
          'javascript', 'json', 'lua', 'python',
          'rust', 'toml', 'typescript', 'elixir', 'php', 'java',
          'ruby', 'twig',
          'http',
        },
        callback = function()
          -- Enable treesitter highlighting and disable regex syntax
          pcall(vim.treesitter.start)
          -- Enable treesitter-based indentation
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })

      -- use regex matching on these
      vim.api.nvim_create_autocmd('FileType', {
        pattern = {
          'markdown', 'markdown_inline',
        },
        callback = function()
          -- Disable treesitter highlighting
          pcall(vim.treesitter.stop)
          -- Enable treesitter-based indentation
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })

      local ensureInstalled = {
        'bash', 'c', 'cpp', 'css', 'go', 'html',
        'javascript', 'json', 'lua', 'python',
        'rust', 'toml', 'typescript', 'elixir', 'php', 'java',
        'ruby', 'twig',
        'http',
        'markdown', 'markdown_inline'
      }
      local alreadyInstalled = require('nvim-treesitter.config').get_installed()
      local parsersToInstall = vim.iter(ensureInstalled)
          :filter(function(parser)
            return not vim.tbl_contains(alreadyInstalled, parser)
          end)
          :totable()
      require('nvim-treesitter').install(parsersToInstall)
    end,
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = 'main',
        config = function()
        end,
      },
    },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>",      desc = "Decrement selection", mode = "x" },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
    opts = {
      mode = "cursor",
      max_lines = 3,
      separator = ' ',
    },
  }
}
