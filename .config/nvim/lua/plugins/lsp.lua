return {
  { 'onsails/lspkind-nvim', event = 'VeryLazy' },
  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
    config = function ()
      local lspconfig = require('lspconfig')
      local lsp_status = require('lsp-status')
      local lsp = vim.lsp
      local buf_keymap = vim.api.nvim_buf_set_keymap
      local cmd = vim.cmd
      local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

      lsp_status.config {
        current_function = true
      }
      lsp_status.register_progress()

      local keymap_opts = {noremap = true, silent = true}

      local snippet_capabilities = {
        textDocument = {completion = {completionItem = {snippetSupport = true}}}
      }

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
        bufmap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
      end

      local lsp_highlighting = function(client)
        if client.server_capabilities.documentHighlightProvider then
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
          virtual_text = { prefix = '◢' },
          signs = false,
          update_in_insert = false,
        }
      )

      lspconfig.tsserver.setup {
        flags = { debounce_text_changes = 150 },
        on_attach = default_attach,
        capabilities = capabilities,
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
        root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git", ".projectroot", "composer.json", ".git/")
      }

      lspconfig.intelephense.setup {
        flags = { debounce_text_changes = 150 },
        on_attach = default_attach,
        capabilities = capabilities,
        init_options = {
          licenceKey = os.getenv('HOME') .. '/.config/intelephense.txt'
        },
        filetypes = { "php" },
        root_dir = lspconfig.util.root_pattern(".git/", "composer.json"),
        settings = {
          intelephense = {
            files = {
              exclude = {
                "**/.git/**",
                "**/.svn/**",
                "**/.hg/**",
                "**/CVS/**",
                "**/.DS_Store/**",
                "**/node_modules/**",
                "**/bower_components/**",
                "**/_ci_phpunit_test/**",
                "**/vendor/**/{Tests,tests}/**",
                "**/tmp/**"
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
      }

      lspconfig.cssls.setup {
        flags = { debounce_text_changes = 150 },
        capabilities = capabilities,
        on_attach = default_attach,
        root_dir = lspconfig.util.root_pattern(".projectroot", ".git", "composer.json")
      }

      local servers = {'jsonls', 'bashls', 'html', 'vimls', 'yamlls', 'gopls', 'pylsp'}
      for _, ilsp in ipairs(servers) do
        lspconfig[ilsp].setup {
          flags = { debounce_text_changes = 150 },
          on_attach = default_attach,
          capabilities = capabilities
        }
      end

      local runtime_path = vim.split(package.path, ';')
      table.insert(runtime_path, "lua/?.lua")
      table.insert(runtime_path, "lua/?/init.lua")

      lspconfig.lua_ls.setup {
        flags = { debounce_text_changes = 150 },
        capabilities = capabilities,
        -- cmd = {
        --   '../tmp/lua-language-server/bin/lua-language-server', '-E', '../tmp/lua-language-server/main.lua'
        -- },
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
              checkThirdParty = false,
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
    end
  },
  {
    'nvim-lua/lsp-status.nvim',
    event = 'VeryLazy',
  },
  {
    'ray-x/lsp_signature.nvim',
    event = 'VeryLazy',
  },
}
