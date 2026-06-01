-- the following looks to refresh diffview via watching for changes
-- from: https://github.com/richardgill/nix/blob/ebdd826/modules/home-manager/dot-files/nvim/lua/plugins/git-diff_diffview.lua

-- whether a path is ignored by git
local is_git_ignored = function(filepath)
  vim.fn.system('git check-ignore -q ' .. vim.fn.shellescape(filepath))
  return vim.v.shell_error == 0
end

local update_left_pane = function()
  pcall(function()
    local lib = require 'diffview.lib'
    local view = lib.get_current_view()
    if view then
      -- This updates the left panel with all the files, but doesn't update the buffers
      view:update_files()
    end
  end)
end

-- Register handler for file changes in watched directory
require('custom.directory-watcher').registerOnChangeHandler('diffview', function(filepath, events)
  local is_in_dot_git_dir = filepath:match '/%.git/' or filepath:match '^%.git/'

  if is_in_dot_git_dir or not is_git_ignored(filepath) then
    vim.notify('[diffview] File changed: ' .. vim.fn.fnamemodify(filepath, ':t'), vim.log.levels.INFO)
    update_left_pane()
  end
end)

vim.api.nvim_create_autocmd('FocusGained', {
  callback = update_left_pane,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'DiffviewViewLeave',
  callback = function()
    vim.cmd ':DiffviewClose'
  end,
})

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
  -- {
  --   'dlyongemallo/diffview.nvim',
  --   cmd = {
  --     'DiffviewOpen',
  --     'DiffviewFileHistory',
  --   },
  --   keys = {
  --     { '<leader>gd', '<cmd>DiffviewOpen<cr>',        noremap = true },
  --     { '<leader>gm', '<cmd>DiffviewOpen main<cr>',   noremap = true }, -- diff against main
  --     { '<leader>gf', '<cmd>DiffviewOpen -uno<cr>',   noremap = true }, -- `-uno`, ignore files not addedd
  --     { '<leader>gc', '<cmd>DiffviewClose<cr>',       noremap = true },
  --     { '<leader>gh', '<cmd>DiffviewFileHistory<cr>', noremap = true },
  --   },
  --   config = function()
  --     -- to fix the vim-markdown problems, folding at load
  --     -- see: https://github.com/dlyongemallo/diffview.nvim?tab=readme-ov-file#recommended
  --     require('diffview').setup({
  --       hooks = {
  --         diff_buf_win_enter = function(bufnr, winid, ctx)
  --           if ctx.layout_name == 'diff2_horizontal' then
  --             vim.wo[winid].foldlevel = 99
  --           end
  --         end,
  --       },
  --     })
  --   end,
  --   opts = {
  --     use_icons = false, --one day can we have folders without file icons?
  --     diff_binaries = false,
  --     watch_index = true,
  --     enhanced_diff_hl = true, -- See |diffview-config-enhanced_diff_hl|
  --     default_args = {
  --       DiffviewOpen = { "--imply-local" }
  --     },
  --     view = {
  --       default = {
  --         layout = "diff2_horizontal",
  --         disable_diagnostics = true,
  --         winbar_info = true,
  --       },
  --       merge_tool = {
  --         layout = "diff3_horizontal", -- diff3_horizontal | diff3_vertical | diff3_mixed | diff4_mixed
  --         disable_diagnostics = true,
  --         winbar_info = true,
  --       },
  --       file_history = {
  --         layout = "diff2_horizontal",
  --         disable_diagnostics = true,
  --         winbar_info = true,
  --       },
  --     },
  --   },
  -- },
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
        position = "bottom", -- "left" or "bottom"
        hidden = false, -- Initial visibility state
        width = 50, -- Width when position is "left" (columns)
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
