local lspconfig = require('lspconfig')
local lspkind = require('lspkind')
local lsp = vim.lsp
local buf_keymap = vim.api.nvim_buf_set_keymap
local cmd = vim.cmd

local sign_define = vim.fn.sign_define
sign_define('LspDiagnosticsSignError', {text = '✗'})
sign_define('LspDiagnosticsSignWarning', {text = '‼'})
sign_define('LspDiagnosticsSignInformation', {text = '?'})
sign_define('LspDiagnosticsSignHint', {text = 'ℹ'})

lspkind.init {symbol_map = kind_symbols}
lsp.handlers['textDocument/publishDiagnostics'] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  underline = true
})

local keymap_opts = {noremap = true, silent = true}
local function on_attach(client)
  buf_keymap(0, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', keymap_opts)
  buf_keymap(0, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', keymap_opts)
  -- buf_keymap(0, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', keymap_opts)
  buf_keymap(0, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', keymap_opts)
  -- buf_keymap(0, 'n', '<c-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', keymap_opts)
  buf_keymap(0, 'n', 'gTD', '<cmd>lua vim.lsp.buf.type_definition()<CR>', keymap_opts)
  -- buf_keymap(0, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', keymap_opts)
  buf_keymap(0, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', keymap_opts)
  buf_keymap(0, 'n', 'gA', '<cmd>lua vim.lsp.buf.code_action()<CR>', keymap_opts)
  buf_keymap(0, 'n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', keymap_opts)
  -- buf_keymap(0, 'n', '<leader>E', '<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>', keymap_opts)
  -- buf_keymap(0, 'n', ']e', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>', keymap_opts)
  -- buf_keymap(0, 'n', '[e', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>', keymap_opts)

  if client.resolved_capabilities.document_formatting then
    buf_keymap(0, 'n', '<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<cr>', keymap_opts)
  end

  if client.resolved_capabilities.document_highlight == true then
    cmd('augroup lsp_aucmds')
    cmd('au CursorHold <buffer> lua vim.lsp.buf.document_highlight()')
    cmd('au CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics()')
    cmd('au CursorMoved <buffer> lua vim.lsp.buf.clear_references()')
    cmd('augroup END')
  end
end

local servers = {
  bashls = {},
  cssls = {
    filetypes = {"css", "scss", "less", "sass"},
    root_dir = lspconfig.util.root_pattern("package.json", ".git")
  },
  html = {},
  jsonls = {cmd = {'json-languageserver', '--stdio'}},
  sumneko_lua = {
    cmd = {'lua-language-server'},
    settings = {
      Lua = {
        diagnostics = {globals = {'vim'}},
        runtime = {version = 'LuaJIT', path = vim.split(package.path, ';')},
        workspace = {
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
          }
        }
      }
    }
  },
  tsserver = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
    root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git")
  },
  vimls = {}
}

local snippet_capabilities = {
  textDocument = {completion = {completionItem = {snippetSupport = true}}}
}

local lsp_mappings = function()
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)

  -- what to set this to?
  -- buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  -- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
end

local lsp_highlighting = function(client)
  -- Set autocommands conditional on server_capabilities
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

local default_attach = function(client, bufnr)
  lsp_mappings()
  lsp_highlighting(client)
end

local test_attach = function(client, bufnr)
  lsp_mappings()
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)

  -- what to set this to?
  -- buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  -- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
end

lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(
  lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = {
      prefix = '樂'
    },
    signs = true,
    update_in_insert = false,
  }
)

-- Use a loop to conveniently both setup defined servers 
-- and map buffer local keybindings when the language server attaches
lspconfig.tsserver.setup {
  on_attach = default_attach,
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git", ".projectroot", "composer.json", ".git/")
}

lspconfig.intelephense.setup {
  on_attach = function(client)
    lsp_mappings()
    lsp_highlighting(client)

    -- client.server_capabilities.completionProvider.triggerCharacters = {
    --   '>', ':', '\\', '/', '*'
    -- }
  end,
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
          "**/_ci_phpunit_test/**"
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
  on_attach = test_attach,
  root_dir = lspconfig.util.root_pattern(".projectroot", ".git", "composer.json")
}

lspconfig.jsonls.setup {
  on_attach = test_attach
}

lspconfig.bashls.setup {
  on_attach = test_attach
}

lspconfig.html.setup {
  on_attach = test_attach
}

lspconfig.yamlls.setup {
  on_attach = test_attach
}

lspconfig.vimls.setup {
  on_attach = test_attach
}

local sumneko_root_path = vim.fn.stdpath('cache')..'/lspconfig/sumneko_lua/lua-language-server'

lspconfig.sumneko_lua.setup {
  cmd = {"/Users/mjw/tmp/lua-language-server/bin/macOS/lua-language-server", "-E", "/Users/mjw/tmp/lua-language-server/main.lua"},
  settings = {
    Lua = {
      diagnostics = {globals = {'vim'}},
      runtime = {version = 'LuaJIT', path = vim.split(package.path, ';')},
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
        }
      }
    }
  },
  root_dir = lspconfig.util.root_pattern(".git/"),
  on_attach = test_attach
}
