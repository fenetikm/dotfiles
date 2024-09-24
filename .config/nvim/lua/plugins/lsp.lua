local lsp_mappings = function(client, bufnr)
  local bufmap = function(mode, lhs, rhs, opts)
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  local opts = { noremap=true, silent=true }
  bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  bufmap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  bufmap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<cr>', opts)
  bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  -- bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts) -- never use this?
  bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
  bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev({float = { border = "rounded" }})<cr>', opts)
  bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next({float = { border = "rounded" }})<cr>', opts)
  bufmap('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  bufmap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  bufmap('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  bufmap('n', '<leader>xd', '<cmd>lua vim.diagnostic.disable()<cr>', opts)
  bufmap('n', '<leader>xe', '<cmd>lua vim.diagnostic.enable()<cr>', opts)
  bufmap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>', opts)
  bufmap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
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
  require 'lsp_signature'.on_attach({hint_enable = false}, bufnr)
end

local default_attach = function(client, bufnr)
  lsp_mappings(client, bufnr)
  lsp_highlighting(client)
  lsp_signature(client, bufnr)
  vim.diagnostic.config({
    underline = true,
    virtual_text = { prefix = '◢' },
    signs = false,
    update_in_insert = false,
  })
end

return {
  { 'onsails/lspkind-nvim', event = 'VeryLazy' },
  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'j-hui/fidget.nvim',
      'folke/neodev.nvim',
      'ray-x/lsp_signature.nvim',
      'nvim-lua/lsp-status.nvim',
    },
    config = function ()
      local lspconfig = require('lspconfig')
      local lsp_status = require('lsp-status')
      local lsp = vim.lsp
      local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

      lsp_status.config {
        current_function = true
      }
      lsp_status.register_progress()

      lspconfig.ts_ls.setup {
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
        cmd = { 'intelephense', '--stdio' },
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

      local servers = {'jsonls', 'bashls', 'html', 'vimls', 'yamlls', 'pylsp'}
      for _, ilsp in ipairs(servers) do
        lspconfig[ilsp].setup {
          flags = { debounce_text_changes = 150 },
          on_attach = default_attach,
          capabilities = capabilities
        }
      end

      lspconfig.gopls.setup {
        on_attach = default_attach,
        capabilities = capabilities,
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        cmd = {'gopls'},
        root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
        single_file_support = true,
      }

      local runtime_path = vim.split(package.path, ';')
      table.insert(runtime_path, "lua/?.lua")
      table.insert(runtime_path, "lua/?/init.lua")

      lspconfig.lua_ls.setup {
        flags = { debounce_text_changes = 150 },
        capabilities = capabilities,
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
        on_attach = function(client, bufnr)
          lsp_mappings()
          lsp_highlighting(client)
          lsp_signature(client, bufnr)
          vim.diagnostic.config({
            underline = true,
            virtual_text = { prefix = '◢' },
            signs = false,
            update_in_insert = false,
          })
        end,
      }
    end
  },
  {
    'nvimtools/none-ls.nvim',
    event = 'VeryLazy',
    config = function ()
      local null_ls = require('null-ls')
      null_ls.setup({
        sources = {
          null_ls.builtins.diagnostics.vale.with({
            filetypes = {'markdown', 'txt'},
          })
        },
        -- on_attach = default_attach,
        on_attach = function (client, bufnr)
          lsp_mappings(client, bufnr)
          lsp_highlighting(client)
          lsp_signature(client, bufnr)
          vim.diagnostic.config({
            virtual_text = false,
            signs = false,
            underline = false,
          })
        end
      })
    end,
    opts = {},
  },
  {
    'folke/trouble.nvim',
    event = 'VeryLazy',
    keys = {
      {'<leader>xx', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', silent = true, noremap = true, desc="Disagnostics (Trouble)"},
    },
    opts = {
      signs = {
        error = '',
        warning = '▲',
        information = '',
        hint = '⚑'
      },
    }
  }
}
