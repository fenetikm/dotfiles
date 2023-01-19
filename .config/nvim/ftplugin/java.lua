local home = os.getenv('HOME')

local lsp_mappings = function(client, bufnr)
  local bufmap = function(mode, lhs, rhs, opts)
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  local opts = { noremap=true, silent=true }
  bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  bufmap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  bufmap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
  bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
  bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev({float = { border = "rounded" }})<CR>', opts)
  bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next({float = { border = "rounded" }})<CR>', opts)
  bufmap('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  bufmap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  bufmap('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  bufmap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  -- buf_keymap(0, 'n', 'gTD', '<cmd>lua vim.lsp.buf.type_definition()<CR>', keymap_opts)
  -- buf_keymap(0, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', keymap_opts)
  -- buf_keymap(0, 'n', 'gA', '<cmd>lua vim.lsp.buf.code_action()<CR>', keymap_opts)
  -- buf_keymap(0, 'n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', keymap_opts)
  -- buf_keymap(0, 'n', '<leader>E', '<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>', keymap_opts)

  -- what to set this to?
  -- buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  -- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
end
local my_attach = function(client, bufnr)
    lsp_mappings(client, bufnr)
    require('jdtls').setup_dap({hotcodereplace = 'auto'})
    require'jdtls.dap'.setup_dap_main_class_configs()
end
local config = {
    cmd = {'/usr/local/Cellar/jdtls/1.19.0/bin/jdtls'},
    root_dir = vim.fs.dirname(vim.fs.find({'.gradlew', '.git', 'mvnw'}, { upward = true })[1]),
    on_attach = my_attach,
    init_options = {
        bundles = {
            vim.fn.glob(home .. "/tmp/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar", 1)
        },
    },
}
require('jdtls').start_or_attach(config)
