return {
  {
    'tpope/vim-fugitive',
    cmd = {
      'Gvdiffsplit',
      'Gdiffsplit'
    },
    keys = {
      { '<leader>gr', '<cmd>Gread<cr>',     noremap = true },
      { '<leader>gb', '<cmd>Git blame<cr>', noremap = true },
    }
  },
  {
    'NeogitOrg/neogit',
    keys = {
      { '<leader>gs', '<cmd>Neogit<cr>', silent = true, noremap = true },
    },
    cmd = {
      'Neogit',
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
    },
    config = function()
      local neogit = require("neogit")
      neogit.setup {
        integrations = {
          diffview = true,
        },
      }
    end,
  },
  {
    "esmuellert/codediff.nvim", -- VSCode like diffing
    cmd = "CodeDiff",
    keys = {
      { '<leader>gd', '<cmd>CodeDiff<cr>',         noremap = true },
      { '<leader>gm', '<cmd>CodeDiff main<cr>',    noremap = true },
      { '<leader>gh', '<cmd>CodeDiff history<cr>', noremap = true },
      { '<leader>gf', '<cmd>CodeDiff history<cr>', noremap = true },
    },
    opts = {
      highlights = {
        line_insert = "diffAdded",
        line_delete = "diffRemoved",
        char_insert = "diffAddedInline",
        char_delete = "diffRemovedInline",
      },
      diff = {
        layout = "inline",                         -- Diff layout: "side-by-side" (two panes) or "inline" (single pane with virtual lines)
        disable_inlay_hints = true,                -- Disable inlay hints in diff windows for cleaner view
        max_computation_time_ms = 5000,            -- Maximum time for diff computation (VSCode default)
        ignore_trim_whitespace = false,            -- Ignore leading/trailing whitespace changes (like diffopt+=iwhite)
        hide_merge_artifacts = false,              -- Hide merge tool temp files (*.orig, *.BACKUP.*, *.BASE.*, *.LOCAL.*, *.REMOTE.*)
        original_position = "left",                -- Position of original (old) content: "left" or "right"
        conflict_ours_position = "right",          -- Position of ours (:2) in conflict view: "left" or "right"
        conflict_result_position = "bottom",       -- "bottom" (default): result below diff panes or "center": result between diff panes (three columns)
        conflict_result_height = 30,               -- Height of result pane in bottom layout (% of total height)
        conflict_result_width_ratio = { 1, 1, 1 }, -- Width ratio for center layout panes {left, center, right} (e.g., {1, 2, 1} for wider result)
        cycle_next_hunk = true,                    -- Wrap around when navigating hunks (]c/[c): false to stop at first/last
        cycle_next_file = true,                    -- Wrap around when navigating files (]f/[f): false to stop at first/last
        jump_to_first_change = true,               -- Auto-scroll to first change when opening a diff: false to stay at same line
        highlight_priority = 100,                  -- Priority for line-level diff highlights (increase to override LSP highlights)
        compute_moves = false,                     -- Detect moved code blocks (opt-in, matches VSCode experimental.showMoves)
      },
      explorer = {
        position = "left", -- "left" or "bottom"
        hidden = false, -- Initial visibility state
        width = 40, -- Width when position is "left" (columns)
        height = 15, -- Height when position is "bottom" (lines)
        auto_refresh = true, -- Auto-refresh file list on focus / git index changes (set false to avoid lag in huge repos; R still refreshes manually)
        indent_markers = true, -- Show indent markers in tree view (│, ├, └)
        initial_focus = "original", -- Initial focus: "explorer", "original", or "modified"
        icons = {
          folder_closed = " ", -- Nerd Font folder icon (customize as needed)
          folder_open = " ", -- Nerd Font folder-open icon
        },
        view_mode = "tree", -- "list" or "tree"
        flatten_dirs = true, -- Flatten single-child directory chains in tree view
        file_filter = {
          ignore = { ".git/**", ".jj/**" }, -- Glob patterns to hide (e.g., {"*.lock", "dist/*"})
        },
        focus_on_select = false, -- Jump to modified pane after selecting a file (default: stay in explorer)
        status_right_margin = 1, -- Trailing cells between status symbol (M/A/D) and right edge; increase if Nerd Font icons clip it
        visible_groups = { -- Which groups to show (can be toggled at runtime)
          staged = true,
          unstaged = true,
          conflicts = true,
        },
      },
    },
  }
}
