return {
  {
    -- using my fork with extras
    -- dir = '~/Documents/Personal/projects/sidekick.nvim',
    -- "folke/sidekick.nvim",
    "fenetikm/sidekick.nvim",
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
        tools = {
          claude = {
            is_proc = {
              "\\<claude\\>",
              "sbx run agent-[^ ]*",
            },
          },
        },
      },
      prompts = {
        diagnostics     = "Fix the diagnostics in {file}\n{diagnostics}",
        diagnostics_all = "Fix all these diagnostics\n{diagnostics_all}",
        document        = "Add documentation to {function|line}",
        explain         = "Explain {this}",
        optimise        = "How can {this} be optimised?",
        review          = "Can you review {file} for any issues or improvements?",
        tests           = "Can you write tests for {this}?",

        -- context prompts
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
    config = function(_, opts)
      require("sidekick").setup(opts)

      -- `vim_agent` (see ~/.config/zsh/vim_agent.sh) starts an agent in a tmux
      -- split before launching neovim, `SIDEKICK_ATTACH` holds the tool name,
      -- attach to it once the process turns up
      local agent = vim.env.SIDEKICK_ATTACH

      if agent and agent ~= "" and vim.env.TMUX then
        local Session = require("sidekick.cli.session")
        local tries = 0

        local function attach()
          tries = tries + 1
          Session.setup()
          local tmux = Session.backends.tmux
          local sessions = tmux and tmux.current_window_sessions() or {}
          local found = vim.tbl_filter(function(session)
            return session.tool.name == agent
          end, sessions)[1]

          if found then
            require("sidekick.cli").toggle({ name = agent, strategy = "auto", focus = false })
          elseif tries < 20 then
            -- the agent may still be starting up, keep looking for ~10 seconds
            vim.defer_fn(attach, 500)
          end
        end

        vim.defer_fn(attach, 200)
      end
    end,
    keys = {
      -- note `submit = true` will trigger submission (undocumented)
      {
        "<leader>aa",
        function() require("sidekick.cli").toggle({ strategy = "auto", focus = false }) end,
        desc = "Sidekick toggle CLI, auto",
      },
      {
        "<leader>ac",
        function() require("sidekick.cli").toggle({ focus = false }) end,
        desc = "Sidekick toggle CLI",
      },
      {
        "<leader>ad",
        function() require("sidekick.cli").close() end,
        desc = "Sidekick detach CLI",
      },
      {
        "<leader>at",
        function() require("sidekick.cli").send({ msg = "{this}", focus = true }) end,
        mode = { "x", "n" },
        desc = "Send `this` to Sidekick CLI",
      },
      {
        "<leader>al",
        function() require("sidekick.cli").send({ msg = "{line}", focus = true }) end,
        mode = { "x", "n" },
        desc = "Send `line` to Sidekick CLI",
      },
      {
        "<leader>af",
        function() require("sidekick.cli").send({ msg = "{file}", focus = true }) end,
        desc = "Send file reference to Sidekick CLI",
      },
      {
        "<leader>as",
        function() require("sidekick.cli").send({ msg = "", focus = true, submit = true }) end,
        desc = "Submit Sidekick CLI",
      },
      {
        "<leader>ap",
        function() require("sidekick.cli").prompt({ submit = true }) end,
        mode = { "n", "x" },
        desc = "Prompt Sidekick CLI",
      },
    },
  }
}
