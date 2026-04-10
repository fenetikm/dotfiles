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

