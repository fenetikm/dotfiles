require('falcon')
local colors = vim.api.nvim_get_var('falcon.palette')
local gl = require('galaxyline')
local gls = gl.section
local condition = require('galaxyline.condition')
local lsp_status = require('lsp-status')

local separator_tri_left = ''
local separator_tri_right = ''

string.lpad = function(str, len, char)
  if char == nil then char = ' ' end
  return str .. string.rep(char, len - #str)
end

string.rpad = function(str, len, char)
  if char == nil then char = ' ' end
  return string.rep(char, len - #str) .. str
end

table.contains = function(table, val)
  for index, value in ipairs(table) do
    if value == val then
      return true
    end
  end
  return false
end

local check_width = function()
  local squeeze_width  = vim.fn.winwidth(0) / 2
  if squeeze_width > 30 then
    return true
  end
  return false
end

local file_readonly = function()
    if vim.bo.filetype == 'help' then return '' end
    if vim.bo.readonly == true then return '  ' end
    return ''
end

local function is_buffer_empty()
  return vim.fn.empty(vim.fn.expand('%:t')) == 1
end

local buffer_not_empty = function()
  return not is_buffer_empty()
end

local file_encode = function()
  return require('galaxyline.provider_fileinfo').get_file_encode():lower()
end

local file_format = function()
  return require('galaxyline.provider_fileinfo').get_file_format():lower()
end

local stats = function()
  local line_column = require('galaxyline.provider_fileinfo').line_column()
  local percent = require('galaxyline.provider_fileinfo').current_line_percent()
  return string.rpad(line_column, 7, ' ')..' |'..string.lpad(percent, 5, ' ')
end

local diagnostic_ok = function()
  if vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then return '' end
  local result = require('galaxyline.provider_diagnostic').get_diagnostic_error()
  if result then
    return ''
  end

  return ' '
end

local mode_info = {
  c = { color = colors.yellow, label = 'C' },
  cv = { color = colors.yellow, label = 'C-V' },
  i = { color = colors.red, label = 'I' },
  ic = { color = colors.red, label = 'I-C' },
  n = { color = colors.normal_gray, label = 'N' },
  r = { color = colors.orange, label = 'N' },
  rm = { color = colors.orange, label = 'R-M' },
  R = { color = colors.orange, label = 'N' },
  Rv = { color = colors.orange, label = 'N' },
  ['r?'] = { color = colors.orange, label = 'R?' },
  s = { color = colors.blue_gray, label = 'S' },
  S = { color = colors.blue_gray, label = 'S-L' },
  [''] = { color = colors.blue_gray, label = 'S-B' },
  t = { color = colors.purple, label = 'T' },
  v = { color = colors.indigo, label = 'V' },
  V = { color = colors.indigo, label = 'V-L' },
  [''] = { color = colors.indigo, label = 'V-B' },
  ['!'] = { color = colors.indigo, label = '!' }
}

local mode_label = function()
  return mode_info[vim.fn.mode()].label
end

local mode_color = function()
  return mode_info[vim.fn.mode()].color
end

local hide_filetypes = {'nerdtree', 'fugitive'}
local hide_filetype = function()
  return not table.contains(hide_filetypes, vim.bo.filetype)
end

gl.short_line_list = {'NvimTree', 'vista', 'dbui', 'packer', 'nerdtree', 'fugitive'}
table.insert(gls.left, {
  ViMode = {
    provider = function()
      vim.api.nvim_command('hi GalaxyViMode guifg='..colors.black..' guibg='..mode_color())

      return '  '..mode_label()..' '
    end,
    highlight = {colors.red,colors.status}
  }
})

table.insert(gls.left, {
  ModeSeparator = {
    provider = function()
      vim.api.nvim_command('hi GalaxyModeSeparator guifg='..mode_color()..' guibg='..colors.status)
      return separator_tri_left..' '
    end,
    highlight = {colors.red, colors.status}
  }
})

table.insert(gls.left, {
  FileIcon = {
    provider = 'FileIcon',
    condition = condition.buffer_not_empty,
    highlight = {colors.normal_gray,colors.status},
  },
})

table.insert(gls.left, {
  FileName = {
    provider = 'FileName',
    separator = ' ',
    separator_highlight = {'NONE',colors.status},
    highlight = {colors.normal_gray, colors.status}
  }
})

table.insert(gls.left, {
  GitBranch = {
    provider = function()
      local vcs = require('galaxyline.provider_vcs')
      local branch_name = vcs.get_git_branch()
      if (string.len(branch_name) > 28) then
        return string.sub(branch_name, 1, 25).."..."
      end
      return branch_name
    end,
    icon = ' ',
    condition = buffer_not_empty,
    highlight = {colors.mid_gray, colors.status},
  }
})

table.insert(gls.left, {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = check_width,
    icon = '+',
    highlight = { colors.mid_gray, colors.status },
  }
})

table.insert(gls.left, {
  DiffModified = {
    provider = 'DiffModified',
    condition = check_width,
    icon = '~',
    highlight = { colors.mid_gray, colors.status},
  }
})

table.insert(gls.left, {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = check_width,
    icon = '-',
    highlight = { colors.mid_gray, colors.status},
  }
})

table.insert(gls.right, {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = ' ',
    highlight = {colors.error, colors.status},
  }
})

table.insert(gls.right, {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = ' ',
    highlight = {colors.warning, colors.status},
  }
})

table.insert(gls.right, {
  DiagnosticInfo = {
    provider = 'DiagnosticInfo',
    icon = ' ',
    highlight = {colors.info, colors.status},
  }
})

--table.insert(gls.right, {
--  DiagnosticOk = {
--    provider = diagnostic_ok,
--    highlight = {colors.green, colors.status}
--  }
--})


table.insert(gls.right, {
  Stats = {
    provider = stats,
    separator = separator_tri_right,
    separator_highlight = {colors.dark_gray, colors.status},
    highlight = {colors.normal_gray,colors.dark_gray},
  }
})

table.insert(gls.right, {
  RightModeSeparator = {
    provider = function() 
      vim.api.nvim_command('hi GalaxyRightModeSeparator guifg='..mode_color()..' guibg='..colors.dark_gray)
      return '' 
    end,
    highlight = {colors.red, colors.status}
  }
})

table.insert(gls.right, {
  RightSpace = {
    provider = function()
      vim.api.nvim_command('hi GalaxyRightSpace guifg='..colors.black..' guibg='..mode_color())
      return ' '
    end,
    highlight = {colors.red,colors.status}
  }
})

table.insert(gls.short_line_left, {
  ShortSpace = {
    provider = function() return ' ' end,
    highlight = {colors.mid_dark_gray, colors.inactive_status}
  }
})

table.insert(gls.short_line_left, {
  ShortFileName = {
    provider = 'FileName',
    condition = hide_filetype,
    highlight = {colors.mid_dark_gray, colors.inactive_status, 'italic'}
  }
})

table.insert(gls.short_line_right, {
  ShortLineInfo = {
    provider = function() return require('galaxyline.provider_fileinfo').line_column()..' ' end,
    condition = hide_filetype,
    highlight = {colors.mid_dark_gray, colors.inactive_status, 'italic'},
  },
});

-- Force manual load so that nvim boots with a status line
gl.load_galaxyline()
