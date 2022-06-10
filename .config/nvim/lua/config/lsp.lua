local lspconfig = require('lspconfig')
-- local lspkind = require('lspkind')
local lsp_status = require('lsp-status')
local lsp = vim.lsp
local buf_keymap = vim.api.nvim_buf_set_keymap
local cmd = vim.cmd
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local iconz = require("nvim-nonicons")

lsp_status.config {
  current_function = true
}
lsp_status.register_progress()

local sign_define = vim.fn.sign_define
sign_define('DiagnosticSignError', {text = iconz.get("x"), texthl = 'DiagnosticError'})
sign_define('DiagnosticSignWarn', {text = iconz.get("alert"), texthl = 'DiagnosticWarn'})
sign_define('DiagnosticSignInfo', {text = ' ', texthl = 'DiagnosticInfo'})
sign_define('DiagnosticSignHint', {text = iconz.get("light-bulb"), texthl = 'DiagnosticHint'})

-- lspkind.init {symbol_map = kind_symbols}
lsp.handlers['textDocument/publishDiagnostics'] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  underline = true
})

local keymap_opts = {noremap = true, silent = true}

local snippet_capabilities = {
  textDocument = {completion = {completionItem = {snippetSupport = true}}}
}

local lsp_mappings = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev({popup_opts = { border = "rounded" }})<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next({popup_opts = { border = "rounded" }})<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  -- buf_keymap(0, 'n', 'gTD', '<cmd>lua vim.lsp.buf.type_definition()<CR>', keymap_opts)
  -- buf_keymap(0, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', keymap_opts)
  -- buf_keymap(0, 'n', 'gA', '<cmd>lua vim.lsp.buf.code_action()<CR>', keymap_opts)
  -- buf_keymap(0, 'n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', keymap_opts)
  -- buf_keymap(0, 'n', '<leader>E', '<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>', keymap_opts)

  -- what to set this to?
  -- buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  -- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
end

local lsp_highlighting = function(client)
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

local lsp_signature = function(client, bufnr)
  require 'lsp_signature'.on_attach({
      bind = true,
      transparency = 5,
      hint_enable = false,
    }, bufnr)
end

local default_attach = function(client, bufnr)
  lsp_mappings(client, bufnr)
  lsp_highlighting(client)
  lsp_signature(client, bufnr)
end

local mapping_attach = function(client, bufnr)
  lsp_mappings(client, bufnr)
end

lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(
  lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = { prefix = '樂' },
    signs = true,
    update_in_insert = false,
  }
)

lspconfig.tsserver.setup {
  on_attach = default_attach,
  capabilities = capabilities,
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git", ".projectroot", "composer.json", ".git/")
}

lspconfig.intelephense.setup {
  on_attach = default_attach,
  capabilities = capabilities,
  filetypes = { "php" },
  root_dir = lspconfig.util.root_pattern(".git/", "composer.json"),
  settings = {
      files = {
        exclude = {
          "**/.git/**",
          "**/.svn/**",
          "**/.hg/**",
          "**/CVS/**",
          "**/.DS_Store/**",
          "**/node_modules/**",
          "**/bower_components/**",
          "**/vendor/**/{Tests,tests}/**",
          "**/_ci_phpunit_test/**",
        }
      },
      completion = {
        insertUseDeclaration = true,
        fullyQualifyGlobalConstantsAndFunctions = true,
        triggerParameterHints = true,
        maxItems = 100
      },
      phpdoc = {
        returnVoid = false
      },
      stubs = {
        "apache",
        "bcmath",
        "bz2",
        "calendar",
        "com_dotnet",
        "Core",
        "ctype",
        "curl",
        "date",
        "dba",
        "dom",
        "enchant",
        "exif",
        "FFI",
        "fileinfo",
        "filter",
        "fpm",
        "ftp",
        "gd",
        "gettext",
        "gmp",
        "hash",
        "iconv",
        "imap",
        "intl",
        "json",
        "ldap",
        "libxml",
        "mbstring",
        "meta",
        "mysqli",
        "oci8",
        "odbc",
        "openssl",
        "pcntl",
        "pcre",
        "PDO",
        "pdo_ibm",
        "pdo_mysql",
        "pdo_pgsql",
        "pdo_sqlite",
        "pgsql",
        "Phar",
        "posix",
        "pspell",
        "readline",
        "Reflection",
        "session",
        "shmop",
        "SimpleXML",
        "snmp",
        "soap",
        "sockets",
        "sodium",
        "SPL",
        "sqlite3",
        "standard",
        "superglobals",
        "sysvmsg",
        "sysvsem",
        "sysvshm",
        "tidy",
        "tokenizer",
        "xml",
        "xmlreader",
        "xmlrpc",
        "xmlwriter",
        "xsl",
        "Zend OPcache",
        "zip",
        "zlib",
        "redis"
      }
  }
}

lspconfig.cssls.setup {
  capabilities = capabilities,
  on_attach = default_attach,
  root_dir = lspconfig.util.root_pattern(".projectroot", ".git", "composer.json")
}

local servers = {'jsonls', 'bashls', 'html', 'vimls', 'yamlls'}
for _, ilsp in ipairs(servers) do
  lspconfig[ilsp].setup {
    on_attach = default_attach,
    capabilities = capabilities
  }
end


local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.sumneko_lua.setup {
  capabilities = capabilities,
  cmd = {
    '/Users/mjw/tmp/lua-language-server/bin/macOS/lua-language-server', '-E', '/Users/mjw/tmp/lua-language-server/main.lua'
  },
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file('', true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
  -- root_dir = lspconfig.util.root_pattern(".git/"),
  on_attach = function(client, bufnr)
    lsp_mappings()
    lsp_highlighting(client)
    lsp_signature(client, bufnr)
  end,
}
