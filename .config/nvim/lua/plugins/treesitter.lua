return {
  {
    'nvim-treesitter/nvim-treesitter',
    version = false,
    build = ':TSUpdate',
    event = {'VeryLazy'},
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treeitter** module to be loaded in time.
      -- Luckily, the only thins that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = function()
          -- When in diff mode, we want to use the default
          -- vim text objects c & C instead of the treesitter ones.
          local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
          local configs = require("nvim-treesitter.configs")
          for name, fn in pairs(move) do
            if name:find("goto") == 1 then
              move[name] = function(q, ...)
                if vim.wo.diff then
                  local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
                  for key, query in pairs(config or {}) do
                    if q == query and key:find("[%]%[][cC]") then
                      vim.cmd("normal! " .. key)
                      return
                    end
                  end
                end
                return fn(q, ...)
              end
            end
          end
        end,
      },
      -- {
      --   'JoosepAlviste/nvim-ts-context-commentstring',
      -- },
    },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
    },
    config = function ()
      local ts_configs = require('nvim-treesitter.configs')
      ts_configs.setup {
        ensure_installed = {
          'bash', 'c', 'cpp', 'css', 'go', 'html',
          'javascript', 'json', 'lua', 'python',
          'rust', 'toml', 'typescript', 'elixir', 'php', 'java',
          'ruby', 'twig'
        },
        -- context_commentstring = { enable = true, enable_autocmd = false },
        highlight = {
          enable = true,
          disable = {'markdown'},
        },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
        textobjects = {
          move = {
            enable = true,
            goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
            goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
            goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
            goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
          },
        },
        -- refactor = {
        --   smart_rename = {enable = true, keymaps = {smart_rename = "grr"}},
        --   highlight_definitions = {enable = true}
        --   -- highlight_current_scope = { enable = true }
        -- },
      }
    end
  },
  {
    'nvim-treesitter/playground',
    keys = {
      {'<c-b>', '<cmd>TSHighlightCapturesUnderCursor<cr>', silent = false, noremap = true}
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
    opts = { mode = "cursor", max_lines = 3 },
  }
}
