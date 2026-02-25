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
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '-' },
        topdelete = { text = '-' },
        changedelete = { text = '▌' },
        untracked = { text = '┆' },
      },
      signs_staged = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '-' },
        topdelete = { text = '-' },
        changedelete = { text = '▌' },
        untracked = { text = '┆' },
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
        local gitsigns = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']h', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [h]unk' })

        map('n', '[h', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [h]unk' })

        -- Actions
        map('n', '<leader>hs', gitsigns.stage_hunk)
        map('n', '<leader>hr', gitsigns.reset_hunk)
        map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
        map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)

        map('n', '<leader>hS', gitsigns.stage_buffer)
        map('n', '<leader>hu', gitsigns.undo_stage_hunk)
        map('n', '<leader>hR', gitsigns.reset_buffer)
        map('n', '<leader>hp', gitsigns.preview_hunk)

        map('n', '<leader>hb', function() gitsigns.blame_line { full = true } end)
        map('n', '<leader>hd', gitsigns.toggle_deleted)
        -- map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
        -- map('n', '<leader>hd', gitsigns.diffthis)
        -- map('n', '<leader>hD', function() gitsigns.diffthis('~') end)

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end,
      max_file_length = 40000,
    }
  },
  {
    'kshenoy/vim-signature',
    event = 'VeryLazy',
    config = function()
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
