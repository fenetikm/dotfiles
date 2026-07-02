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
        '<c-s-o>',
        function() require('fzf-lua').files({ cwd = vim.fn.expand('~z') }) end,
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
      winopts = {
        height      = 0.7,
        width       = 0.85,
        row         = 0.85,
        col         = 0.5,
        title_flags = false,
        treesitter  = {
          enabled = true,
          -- treesitter can knock out the fzf_colors below, so need these here
          -- without this, will get "reverse" style on matches
          fzf_colors = {
            ["hl"] = { "fg", "Normal" },
            ["hl+"] = { "fg", "TelescopeMatching" },
          },
        },
      },
      fzf_opts = {
        ["--layout"] = "default",
      },
      -- note: the way to set highlights:
      -- - try via `hls` override, if fail then
      -- - try via `fzf_colors`
      -- - check if it needs to be added to the treesitter settings above
      hls = {
        border = "TelescopeBorder",
        title = "TelescopeTitle",
        normal = "TelescopeNormal",
        preview_border = "TelescopeBorder",
        preview_title = "TelescopeTitle",
        preview_normal = "TelescopeNormal",
      },
      fzf_colors = {
        ["bg+"] = { "bg", "CursorLine" },
        ["pointer"] = { "fg", "FzfLuaPointer" },
        ["prompt"] = { "fg", "FzfLuaPrompt" },
        ["hl"] = { "fg", "Normal" },
        ["hl+"] = { "fg", "TelescopeMatching" },
      },
      files = {
        cwd_prompt = false,
      },
      grep = {
        rg_opts      =
        "--colors=match:fg:15 --colors=line:fg:120,120,130 --colors=column:fg:120,120,130 --colors=path:fg:120,120,130 --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
        input_prompt = 'Search ❯ ',
      },
    },
  },
}
