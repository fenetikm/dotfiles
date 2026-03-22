return {
  -- {
  --   "nickjvandyke/opencode.nvim",
  --   event = "VeryLazy",
  --   dependencies = {
  --     -- Recommended for `ask()` and `select()`.
  --     -- Required for `snacks` provider.
  --     ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
  --     -- { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  --   },
  --   config = function()
  --     ---@type opencode.Opts
  --     vim.g.opencode_opts = {
  --       provider = {
  --         enabled = "tmux",
  --       }
  --     }
  --
  --     -- Required for `opts.events.reload`.
  --     vim.o.autoread = true
  --
  --     vim.keymap.set({ "n", "x" }, "<leader>aa", function() require("opencode").ask("@this: ", { submit = true }) end,
  --       { desc = "Ask opencode…" })
  --     vim.keymap.set({ "n", "x" }, "<leader>as", function() require("opencode").select() end,
  --       { desc = "Execute opencode action…" })
  --     vim.keymap.set({ "n", "t" }, "<leader>at", function() require("opencode").toggle() end,
  --       { desc = "Toggle opencode" })
  --
  --     vim.keymap.set({ "n", "x" }, "go", function() return require("opencode").operator("@this ") end,
  --       { desc = "Add range to opencode", expr = true })
  --     vim.keymap.set("n", "goo", function() return require("opencode").operator("@this ") .. "_" end,
  --       { desc = "Add line to opencode", expr = true })
  --
  --     vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end,
  --       { desc = "Scroll opencode up" })
  --     vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end,
  --       { desc = "Scroll opencode down" })
  --   end,
  -- }
  {
    "folke/sidekick.nvim",
    event = "VeryLazy",
    opts = {
      nes = {
        enabled = false,
      },
      cli = {
        watch = true, -- notify Neovim of file changes done by AI CLI tools
        mux = {
          backend = "tmux",
          enabled = true,
          create = "split",
          split = {
            vertical = true, -- vertical or horizontal split
            size = 0.5,      -- size of the split (0-1 for percentage)
          },
        },
      },
      prompts = {
        -- todo: put skills into this?
        -- this doesn't work?
        question        = function(ctx)
          local input = nil
          vim.ui.input({
            prompt = 'Question:',
          }, function(i)
            input = i
          end)
          return input .. " {this}"
        end,
        changes         = "Review these changes",
        diagnostics     = "Fix the diagnostics in {file}\n{diagnostics}",
        diagnostics_all = "Fix all these diagnostics\n{diagnostics_all}",
        document        = "Add documentation to {function|line}",
        explain         = "Explain {this}",
        fix             = "Can you fix {this}?",
        optimize        = "How can {this} be optimized?",
        review          = "Can you review {file} for any issues or improvements?",
        tests           = "Can you write tests for {this}?",

        -- simple context prompts
        buffers         = "{buffers}",
        file            = "{file}",
        line            = "{line}",
        position        = "{position}",
        quickfix        = "{quickfix}",
        selection       = "{selection}",
        ["function"]    = "{function}",
        class           = "{class}",
      },
    },
    keys = {
      -- {
      --   "<tab>",
      --   function()
      --     -- if there is a next edit, jump to it, otherwise apply it if any
      --     if not require("sidekick").nes_jump_or_apply() then
      --       return "<Tab>" -- fallback to normal tab
      --     end
      --   end,
      --   expr = true,
      --   desc = "Goto/Apply Next Edit Suggestion",
      -- },
      -- {
      --   "<c-.>",
      --   function() require("sidekick.cli").focus() end,
      --   desc = "Sidekick Focus",
      --   mode = { "n", "t", "i", "x" },
      -- },
      {
        "<leader>aa",
        function() require("sidekick.cli").toggle() end,
        desc = "Sidekick Toggle CLI",
      },
      -- {
      --   "<leader>as",
      --   function() require("sidekick.cli").select() end,
      --   -- Or to select only installed tools:
      --   -- require("sidekick.cli").select({ filter = { installed = true } })
      --   desc = "Select CLI",
      -- },
      {
        "<leader>ad",
        function() require("sidekick.cli").close() end,
        desc = "Detach a CLI Session",
      },
      {
        "<leader>at",
        function() require("sidekick.cli").send({ msg = "{this}" }) end,
        mode = { "x", "n" },
        desc = "Send this to CLI",
      },
      {
        "<leader>af",
        function() require("sidekick.cli").send({ msg = "{file}" }) end,
        desc = "Send File",
      },
      {
        "<leader>av",
        function() require("sidekick.cli").send({ msg = "{selection}" }) end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function() require("sidekick.cli").prompt() end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
      -- -- Example of a keybinding to open Claude directly
      -- {
      --   "<leader>ac",
      --   function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
      --   desc = "Sidekick Toggle Claude",
      -- },
    },
  }
}
