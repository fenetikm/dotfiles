-- from: https://github.com/richardgill/nix/blob/ebdd826/modules/home-manager/dot-files/nvim/lua/plugins/git-diff_diffview.lua
-- refreshes diffview when a change is made to a file
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

vim.notify '[diffview] init'
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
  {
    'dlyongemallo/diffview.nvim',
    cmd = {
      'DiffviewOpen',
      'DiffviewFileHistory',
    },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<cr>',        noremap = true },
      { '<leader>gf', '<cmd>DiffviewOpen -uno<cr>',   noremap = true }, -- `-uno`, ignore files not addedd
      { '<leader>gc', '<cmd>DiffviewClose<cr>',       noremap = true },
      { '<leader>gh', '<cmd>DiffviewFileHistory<cr>', noremap = true },
    },
    config = function()
      -- to fix the vim-markdown problems
      -- see: https://github.com/dlyongemallo/diffview.nvim?tab=readme-ov-file#recommended
      require('diffview').setup({
        hooks = {
          diff_buf_win_enter = function(bufnr, winid, ctx)
            if ctx.layout_name == 'diff2_horizontal' then
              vim.wo[winid].foldlevel = 99
            end
          end,
        },
      })
    end,
    opts = {
      use_icons = false, --one day can we have folders without file icons?
      diff_binaries = false,
      watch_index = true,
      enhanced_diff_hl = true, -- See |diffview-config-enhanced_diff_hl|
      default_args = {
        DiffviewOpen = { "--imply-local" }
      },
      view = {
        default = {
          layout = "diff2_horizontal",
          disable_diagnostics = true,
          winbar_info = true,
        },
        merge_tool = {
          layout = "diff3_horizontal", -- diff3_horizontal | diff3_vertical | diff3_mixed | diff4_mixed
          disable_diagnostics = true,
          winbar_info = true,
        },
        file_history = {
          layout = "diff2_horizontal",
          disable_diagnostics = true,
          winbar_info = true,
        },
      },
    },
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
  }
}
