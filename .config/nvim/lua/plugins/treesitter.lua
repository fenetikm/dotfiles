return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    -- event = { 'VeryLazy' },
    init = function()
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treeitter** module to be loaded in time.
      -- Luckily, the only thins that those plugins need are the custom queries, which we make available
      -- during startup.
      -- require("lazy.core.loader").add_to_rtp(plugin)
      -- require("nvim-treesitter.query_predicates")
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          -- Enable treesitter highlighting and disable regex syntax
          pcall(vim.treesitter.start)
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
    config = function()
      local ts_configs = require('nvim-treesitter')
      ts_configs.setup {
        -- context_commentstring = { enable = true, enable_autocmd = false },
        -- incremental_selection = {
        --   enable = true,
        --   keymaps = {
        --     init_selection = "<C-space>",
        --     node_incremental = "<C-space>",
        --     scope_incremental = false,
        --     node_decremental = "<bs>",
        --   },
        -- },
        -- textobjects = {
        --   move = {
        --     enable = true,
        --     goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
        --     goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
        --     goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
        --     goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
        --   },
        -- },
      }
    end
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
