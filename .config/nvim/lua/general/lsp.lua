-- refs, as usual:
-- https://github.com/wincent/wincent/blob/main/aspects/nvim/files/.config/nvim/lua/wincent/lsp.lua

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local bufnr = args.buf

    if client:supports_method('textDocument/documentHighlight') then
      local highlight_group = vim.api.nvim_create_augroup('mw_lsp_highlight', {})
      vim.api.nvim_create_autocmd({'CursorHold'}, {
        group = highlight_group,
        callback = function()
          vim.lsp.buf.document_highlight()
        end
      })

      vim.api.nvim_create_autocmd({'CursorMoved'}, {
        group = highlight_group,
        callback = function()
          vim.lsp.buf.clear_references()
        end
      })
    end

    require('lsp_signature').on_attach({
      hint_enable = false
    }, bufnr)

    vim.diagnostic.config({
      underline = true,
      virtual_text = { prefix = '◿' },
      signs = false,
      update_in_insert = false,
    })

    vim.keymap.set('n', 'gd', function() vim.lsp.buf.declaration()     end, { buffer = true, silent = true})
    vim.keymap.set('n', 'gD', function() vim.lsp.buf.definition()      end, { buffer = true, silent = true})

    -- defaults, for completeness
    vim.keymap.set('n', 'grn', function() vim.lsp.buf.rename()         end, { buffer = true, silent = true})
    vim.keymap.set('n', 'gra', function() vim.lsp.buf.code_action()    end, { buffer = true, silent = true})
    vim.keymap.set('n', 'gri', function() vim.lsp.buf.implementation() end, { buffer = true, silent = true})
    vim.keymap.set('n', 'grr', function() vim.lsp.buf.references()     end, { buffer = true, silent = true})
    vim.keymap.set('n', 'gO', function()  vim.lsp.buf.document_symbol() end, { buffer = true, silent = true})

    -- end defaults
    -- changed from the default ctrl-s
    vim.keymap.set('i', '<c-h>', function()
      vim.lsp.buf.signature_help()
    end, { buffer = true, silent = true})

    vim.keymap.set('n', 'grl', function()
      vim.diagnostic.open_float({ border = 'rounded' })
    end, { buffer = true, silent = true})

    vim.keymap.set('n', '[d', function()
      vim.diagnostic.jump({ count = -1, float = { border = 'rounded' } })
    end, { buffer = true, silent = true})

    vim.keymap.set('n', 'd]', function()
      vim.diagnostic.jump({ count = 1, float = { border = 'rounded' } })
    end, { buffer = true, silent = true})

    vim.keymap.set('n', 'gh', function()
      vim.lsp.buf.hover()
    end, { buffer = true, silent = true})

    vim.keymap.set('n', 'gs', function()
      vim.lsp.buf.signature_help()
    end, { buffer = true, silent = true})

    -- toggle virtual lines
    vim.keymap.set('n', 'gl', function()
      if vim.diagnostic.config().virtual_lines then
        vim.diagnostic.config({ virtual_lines = false })
      else
        vim.diagnostic.config({ virtual_lines = true })
      end
    end, { buffer = true, silent = true })

  end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()

local has_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if has_cmp_nvim_lsp then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- set default config
vim.lsp.config('*', {
  capabilities = capabilities,
})

local signs = {
  Error = '✖',
  Warn = '▲',
  Info = '',
  Hint = '⚑',
}

vim.diagnostic.config({
  float = {
    header = 'Diagnostics',
    prefix = function(diagnostic, i, total)
      if diagnostic.severity == vim.diagnostic.severity.ERROR then
        return (signs.Error .. ' '), ''
      elseif diagnostic.severity == vim.diagnostic.severity.HINT then
        return (signs.Hint .. ' '), ''
      elseif diagnostic.severity == vim.diagnostic.severity.INFO then
        return (signs.Info .. ' '), ''
      elseif diagnostic.severity == vim.diagnostic.severity.WARN then
        return (signs.Warn .. ' '), ''
      else
        return ('? '), ''
      end
    end,
  },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = signs.Error,
      [vim.diagnostic.severity.HINT] = signs.Hint,
      [vim.diagnostic.severity.INFO] = signs.Info,
      [vim.diagnostic.severity.WARN] = signs.Warn,
    },
  },
})

-- Override signs used elsewhere e.g. Trouble.nvim
local sign_types = {
  Error = signs.Error,
  Warn = signs.Warn,
  Hint = signs.Hint,
  Info = signs.Info
}
for type, icon in pairs(sign_types) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, {
    text = icon,
    texthl = hl,
    numhl = ""
  })
end

if vim.fn.executable('intelephense') == 1 then
  vim.lsp.enable('php')
end

if vim.fn.executable('lua-language-server') == 1 then
  vim.lsp.enable('lua_ls')
end

if vim.fn.executable('gopls') == 1 then
  vim.lsp.enable('gopls')
end

if vim.fn.executable('typescript-language-server') == 1 then
  vim.lsp.enable('ts_ls')
end

if vim.fn.executable('typescript-language-server') == 1 then
  vim.lsp.enable('jsonls')
end

if vim.fn.executable('typescript-language-server') == 1 then
  vim.lsp.enable('bashls')
end

if vim.fn.executable('typescript-language-server') == 1 then
  vim.lsp.enable('html')
end

if vim.fn.executable('typescript-language-server') == 1 then
  vim.lsp.enable('vimls')
end

if vim.fn.executable('typescript-language-server') == 1 then
  vim.lsp.enable('yamlls')
end

if vim.fn.executable('typescript-language-server') == 1 then
  vim.lsp.enable('cssls')
end

if vim.fn.executable('vim-language-server') == 1 then
  vim.lsp.enable('vimls')
end

