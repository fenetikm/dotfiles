return {
  {
    'ibhagwan/fzf-lua',
    cmd = 'FzfLua',
    keys = {
      {
        '<c-p>',
        function() require('fzf-lua').files() end,
        desc = 'Find files (fzf-lua)',
      },
      {
        '<c-s-p>',
        function() require('fzf-lua').files({ no_ignore = true }) end,
        desc = 'Find files (fzf-lua)',
      },
      {
        '<leader>fm',
        function() require('fzf-lua').keymaps() end,
        desc = 'Search keymaps (fzf-lua)',
      },
      {
        '<leader>fc',
        function() require('fzf-lua').commands() end,
        desc = 'Search commands (fzf-lua)',
      },
      {
        '<leader>fs',
        function() require('fzf-lua').highlights() end,
        desc = 'Search highlights (fzf-lua)',
      },
      {
        '<leader>fr',
        function() require('fzf-lua').registers() end,
        desc = 'Show registers (fzf-lua)',
      },
      {
        '<leader>fh',
        function() require('fzf-lua').oldfiles() end,
        desc = 'Search recent files (fzf-lua)',
      },
      {
        '<leader>:',
        function() require('fzf-lua').command_history() end,
        desc = 'Search command history (fzf-lua)',
      },
      {
        '<c-t>',
        function() require('fzf-lua').tags() end,
        desc = 'Search tags (fzf-lua)',
      },
      {
        '<leader>?',
        function() require('fzf-lua').helptags() end,
        desc = 'Help tags (fzf-lua)',
      },
      {
        '<leader>T',
        function() require('fzf-lua').lsp_document_symbols() end,
        desc = 'Help tags (fzf-lua)',
      },
      {
        '//',
        function() require('fzf-lua').blines() end,
        desc = 'Current bufffer lines (fzf-lua)',
      },
      {
        '<leader>s',
        function() require('fzf-lua').grep({ input_prompt = "Search ❯ " }) end,
        desc = 'Search for pattern (fzf-lua)',
      },
      {
        '<leader>S',
        function() require('fzf-lua').grep({ input_prompt = "Search all ❯ ", no_ignore = true }) end,
        desc = 'Search for pattern, all files (fzf-lua)',
      },
      {
        '<leader>w',
        function() require('fzf-lua').grep_cword() end,
        desc = 'Search for word under cursor (fzf-lua)',
      },
      {
        '<leader>W',
        function() require('fzf-lua').grep_cword({ no_ignore = true }) end,
        desc = 'Search for word under cursor, all files (fzf-lua)',
      },
    },
    opts = {
      -- todo: see telescope config, can we make it not so big?
      -- - no preview when not much room / cutoff
      -- ... remove telescope config completely
      defaults = {
        prompt = "=> ",
        file_icons = false,
      },
      fzf_opts = {
        ["--layout"] = "default",
      },
      hls = {
        border = "TelescopeBorder",
        title = "TelescopeTitle",
        normal = "TelescopeNormal",
        preview_border = "TelescopeBorder",
        preview_title = "TelescopeTitle",
        preview_normal = "TelescopeNormal",
        match = "TelescopeMatch",
      },
      fzf_colors = {
        ["bg+"] = { "bg", "CursorLine" },
      },
      files = {
        cwd_prompt = false,
      },
      grep = {
        -- todo: colors still need tweaking
        rg_opts      =
        "--colors=match:fg:15 --colors=line:fg:244 --colors=path:fg:244 --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
        input_prompt = 'Search ❯ ',
      },
    },
  },
}
