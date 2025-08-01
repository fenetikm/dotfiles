return {
  {
    'lewis6991/gitsigns.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        "purarue/gitsigns-yadm.nvim",
        opts = {
            shell_timeout_ms = 1000,
        },
      },
    },
    event = 'VeryLazy',
    opts = {
      signs = {
        add = {text = '▎'},
        change = {text = '▎'},
        delete = {text = '-'},
        topdelete = {text = '-'},
        changedelete = {text = '▌'},
        untracked = {text = '┆'},
      },
      signs_staged = {
        add = {text = '▎'},
        change = {text = '▎'},
        delete = {text = '-'},
        topdelete = {text = '-'},
        changedelete = {text = '▌'},
        untracked = {text = '┆'},
      },
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = ' <author>, <author_time:%Y-%m-%d> - <summary>',
      _on_attach_pre = function(_, callback)
          require("gitsigns-yadm").yadm_signs(callback)
      end,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, {expr=true})

        map('n', '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, {expr=true})

        -- Actions
        map('n', '<leader>hs', gs.stage_hunk)
        map('n', '<leader>hr', gs.reset_hunk)
        map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
        map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
        map('n', '<leader>hS', gs.stage_buffer)
        map('n', '<leader>hu', gs.undo_stage_hunk)
        map('n', '<leader>hR', gs.reset_buffer)
        map('n', '<leader>hp', gs.preview_hunk)
        map('n', '<leader>hb', function() gs.blame_line{full=true} end)
        map('n', '<leader>tb', gs.toggle_current_line_blame)
        map('n', '<leader>hd', gs.diffthis)
        map('n', '<leader>hD', function() gs.diffthis('~') end)
        map('n', '<leader>td', gs.toggle_deleted)

        -- Text object
        map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end,
      max_file_length = 40000,
    }
  },
  {
    'kshenoy/vim-signature',
    event = 'VeryLazy',
    config = function ()
      vim.g.SignatureMap = {
        Leader = 'm',
        PlaceNextMark = '',
        ToggleMarkAtLine = 'm.',
        PurgeMarksAtLine = 'm-',
        DeleteMark = 'dm',
        PurgeMarks = 'm<Space>',
        PurgeMarkers = 'm<BS>',
        GotoNextLineAlpha = '',
        GotoPrevLineAlpha = '',
        GotoNextSpotAlpha = '',
        GotoPrevSpotAlpha = '',
        GotoNextLineByPos = '',
        GotoPrevLineByPos = '',
        GotoNextSpotByPos = '',
        GotoPrevSpotByPos = '',
        GotoNextMarker = '',
        GotoPrevMarker = '',
        GotoNextMarkerAny = '',
        GotoPrevMarkerAny = '',
        ListBufferMarks = 'm/',
        ListBufferMarkers = 'm?'
      }
    end
  }
}
