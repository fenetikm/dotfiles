# To-do
- Better folding visuals, see: https://github.com/wincent/wincent/blob/main/aspects/nvim/files/.config/nvim/lua/wincent/foldtext.lua
    - with this, remove the phpfolding plugin
- More transparency support of all the things, start with top "what you are inside of thing"
- Trouble background not transparent
- Looking into LSP handlers
- Lualine:
- - don't need colour re git modifications
- Can we use ftplugin for lsp enablement? e.g. https://dev.to/vonheikemen/a-guide-on-neovims-lsp-client-mn0
- Finish setting up markview.
- Treesitter mappings for textobjects if not somewhere else? expand / contract
- When commenting, keep selection in visual mode

## Done
- Integrate exrc instead of vimrclocal plugin https://neovim.io/doc/user/options.html#'exrc'

## Refs
- Decent overview of modern LSP config: https://dev.to/vonheikemen/a-guide-on-neovims-lsp-client-mn0
- Fixing treesitter in 0.12: https://www.qu8n.com/posts/treesitter-migration-guide-for-nvim-0-12, also had to use the `cargo` tree-sitter

## Folding notes
- https://github.com/fenetikm/phpfolding.vim/blob/master/ftplugin/php/phpfolding.vim
- https://github.com/bbjornstad/pretty-fold.nvim seems unmaintained?
- https://neovim.io/doc/user/fold.html
- Try out the intelephense one and LSP folding
- This one looks interesting, nifty: https://github.com/kevinhwang91/nvim-ufo
- https://github.com/chrisgrieser/nvim-origami Chris Geiser one

## CC reviews

Here are my suggestions, organized by impact:

---

## High Impact

### 1. Replace `nvim-cmp` with `blink.cmp`
`nvim-cmp` is essentially in maintenance mode. `blink.cmp` is faster, has better defaults, native fuzzy matching, and drops the need for `cmp-nvim-lsp`, `cmp-buffer`, `cmp-path`, `cmp_luasnip`, and `lsp_signature.nvim` (it has built-in signature help). That's 5 plugins → 1.

### 2. Replace `lsp-format.nvim` + `none-ls.nvim` with `conform.nvim` + `nvim-lint`
- `lsp-format.nvim` predates native formatter control — `conform.nvim` gives you per-language formatter fallback chains with finer control.
- `none-ls.nvim` is community-maintained and slowing down; you're using it only for `vale` (markdown linting). `nvim-lint` is lighter, purpose-built, and simpler.

### 3. Reduce text object plugins from 3 to 2
You have `mini.ai`, `nvim-various-textobjs`, and `nvim-treesitter-textobjects` all adding text objects. There's likely significant overlap. `mini.ai` + `nvim-treesitter-textobjects` covers almost everything; auditing `nvim-various-textobjs` for what you actually use would likely show it's redundant.

---

## Medium Impact

### 4. `plugins/init.lua` is 600+ lines — split it
You've already done this well for LSP, cmp, telescope, etc. The remaining bulk in `init.lua` would benefit from being split into topic files (ui.lua, editing.lua, navigation.lua, etc.) matching your existing pattern.

### 5. Add `fidget.nvim` for LSP progress
You have `lsp-status.nvim` feeding into lualine, but there's no in-editor progress notification for long LSP operations (indexing, etc.). `fidget.nvim` is minimal and works with the native LSP progress API.

### 6. The `.vim` files in `plugin/` and `ftplugin/` are legacy noise
`plugin/custom.vim`, `plugin/listtoggle.vim`, `plugin/vimux.vim`, and the `.vim` ftplugins are old-style. Either convert them to Lua or, for `listtoggle.vim`/`vimux.vim`, check if you still actually use those features — they may be dead code.

### 7. `snacks.nvim` picker vs Telescope
You have both loaded. `snacks.picker` is a full Telescope replacement — using both means two fuzzy-finder backends in memory. Pick one; if you're not actively migrating to snacks picker, consider disabling it in the snacks config.

---

## Low Impact / Nice-to-Have

### 8. `lsp-status.nvim` can be replaced by native progress
Since Neovim 0.10, `vim.lsp.get_progress_messages()` / `LspProgress` autocmd is built-in. You can drive lualine's LSP component natively and drop the plugin.

### 9. `_old/` directory
The `_old/UltiSnips/` directory is dead weight in your config repo. If you've migrated fully to LuaSnip, remove it.

### 10. `lazydev.nvim` workspace library setting
In your `lsp/lua_ls.lua`, verify you're not also configuring `workspace.library` manually — `lazydev.nvim` manages this, and manual entries conflict with it.


## Changing the picker / telescope
From CC:
The research agent returned a comprehensive report. Here's the summary:

---

## Neovim Fuzzy Finder Plugins (2026)

### The Main Players

| Plugin | Stars | Requires binary | Age | Active? |
|---|---|---|---|---|
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | ~19.3k | No | 2020 | Yes (slowing) |
| [fzf-lua](https://github.com/ibhagwan/fzf-lua) | ~4.2k | Yes (`fzf`) | 2021 | Yes (LazyVim default since Dec 2024) |
| [snacks.nvim](https://github.com/folke/snacks.nvim) | ~7.4k | No | Nov 2024 | Yes (very active, v2.31 Mar 2026) |
| [mini.pick](https://github.com/echasnovski/mini.nvim) | ~9k (mono) | No | Oct 2023 | Yes |

---

### Key Technical Differences

**telescope.nvim** — pure Lua, in-process. Highly composable (Pickers / Sorters / Previewers as separate concepts). Extension ecosystem is enormous (~200+ community plugins). Requires `telescope-fzf-native.nvim` (C extension, `make` build step) for competitive performance. Depends on `plenary.nvim`.

**fzf-lua** — wraps the `fzf` binary. Spawns a headless `nvim --clean` subprocess for heavy work piped into `fzf` in a terminal buffer. UI never blocks. Fastest on very large repos. No in-process blocking. Downside: UI lives in a `:terminal`, Normal-mode input is awkward.

**snacks.nvim picker** — pure Lua, fully async. Explicitly aims to combine fzf-lua's speed with Telescope's features. Has first-class Normal-mode input, built-in frecency (SQLite3 optional), `vim.ui.select` replacement. Part of a larger "batteries included" plugin by folke.

**mini.pick** — pure Lua, async (yields every 10ms). Deliberately minimal single-window design. No external deps. Designed to pair with the rest of `mini.nvim`. Fewer built-ins than the others.

---

### Example Configs

**fzf-lua** (LazyVim default):
```lua
{
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    fzf_opts = { ["--layout"] = "reverse", ["--info"] = "inline" },
  },
  config = function(_, opts)
    local fzf = require("fzf-lua")
    fzf.setup(opts)
    fzf.register_ui_select()
    vim.keymap.set("n", "<leader>ff", fzf.files)
    vim.keymap.set("n", "<leader>fg", fzf.live_grep)
    vim.keymap.set("n", "<leader>fb", fzf.buffers)
  end,
}
```

**snacks.nvim picker**:
```lua
{
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    picker = {
      matcher = { frecency = true },
      layout  = { preset = "telescope" },
    },
  },
  keys = {
    { "<leader>ff", function() Snacks.picker.files()   end },
    { "<leader>fg", function() Snacks.picker.grep()    end },
    { "<leader>fb", function() Snacks.picker.buffers() end },
    { "<leader>fr", function() Snacks.picker.recent()  end },
  },
}
```

**telescope.nvim** (with native sorter):
```lua
{
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    require("telescope").setup({ ... })
    require("telescope").load_extension("fzf")
    local b = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ff", b.find_files)
    vim.keymap.set("n", "<leader>fg", b.live_grep)
  end,
}
```

---

### Recommendation Matrix

| Need | Pick |
|---|---|
| Extension ecosystem / plugins | **telescope.nvim** |
| Raw speed, proven, large codebases | **fzf-lua** |
| Speed + Normal mode + frecency + no binary | **snacks.nvim picker** |
| Minimalism, mini.nvim user | **mini.pick** |

**2026 trend:** fzf-lua has the "distro default" crown (LazyVim), snacks.nvim is the fastest-growing, and telescope is still unmatched for extensions but no longer the default recommendation. There is also an open neovim/neovim#35943 discussing a built-in picker.
