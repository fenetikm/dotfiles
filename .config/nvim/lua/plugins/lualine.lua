local colours = require('falcon.colours')
local width_threshold = 120
local width_secondary_threshold = 90

local line_only = {
  'fugitiveblame',
  'qf',
  'fugitive',
  'NvimTree',
}

local config = {
  options = {
    icons_enabled = true,
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {
        'startify',
        'alpha'
      },
      winbar = {},
    },
    theme = {
      normal = {
        a = { fg = colours.mid_gray.hex, bg = colours.status.hex },
        x = { fg = colours.mid_gray.hex, bg = colours.status.hex },
      },
      inactive = {
        a = { fg = colours.mid_dark_gray.hex, bg = colours.bg.hex, gui = 'italic' },
        x = { fg = colours.mid_dark_gray.hex, bg = colours.bg.hex, gui = 'italic' },
      },
    },
    ignore_focus = {
      'help',
      'packer',
    },
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > width_threshold
  end,
  hide_in_secondary_width = function()
    return vim.fn.winwidth(0) > width_secondary_threshold
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
  check_line_filetype = function()
    local ft = vim.bo.filetype
    for _, value in ipairs(line_only) do
      if ft == value then
        return false
      end
    end

    return true
  end
}

local fill_line = function ()
    local width = vim.fn.winwidth(0)
  local fill = ''
  for i = 1, width, 1 do
    fill = fill .. '—'
  end

  return fill
end

local ins_a = function (component)
  table.insert(config.sections.lualine_a, component)
end

local ins_x = function (component)
  table.insert(config.sections.lualine_x, component)
end

local lpad = function(str, len, char)
  if char == nil then char = ' ' end
  return str .. string.rep(char, len - #str)
end

local rpad = function(str, len, char)
  if char == nil then char = ' ' end
  return string.rep(char, len - #str) .. str
end

local search_result = function()
  if vim.v.hlsearch == 0 then
    return ''
  end
  local last_search = vim.fn.getreg('/')
  if not last_search or last_search == '' then
    return ''
  end
  local searchcount = vim.fn.searchcount { maxcount = 9999 }
  if searchcount.total == 0 then
    return ''
  end
  return ' ' .. '(' .. searchcount.current .. '/' .. searchcount.total .. ')'
end

local location_short = function()
  local line = vim.fn.line('.')
  local column = vim.fn.col('.')

  return line .. ':' .. column
end

local location_progress = function()
  local line = vim.fn.line('.')
  local total_lines = vim.fn.line('$')
  if total_lines == nil then total_lines = 0 end
  local column = vim.fn.col('.')
  local line_column = tostring(line) .. ':' .. lpad(tostring(column), 2, ' ')
  local perc = ''
  if line == 1 then
    perc = ' BoF'
  elseif line == total_lines then
    perc = ' EoF'
  else
    perc = string.format(' %2d', math.floor(line / total_lines * 100)) .. '%%'
  end

  perc = perc .. ' '

  local total_chars = string.len(tostring(total_lines))
  local line_width = total_chars + 4
  return rpad(line_column, line_width, ' ') .. perc
end

local check_encoding = function()
  local encoding = vim.opt.fileencoding:get()
  if encoding == 'utf-8' then
    return ''
  end

  return encoding
end

local check_fileformat = function()
  local format = vim.bo.fileformat
  if format == 'unix' then
    return ''
  end

  return format
end

local current_path = function()
  local path = ''
  if vim.fn.winwidth(0) < 60 then
    path = ''
  elseif vim.fn.winwidth(0) > width_threshold then
    path = vim.fn.expand('%:h') .. '/'
  else
    path = vim.fn.pathshorten(vim.fn.expand('%:h') .. '/')
  end
  if string.len(path) > 19 then
    path = vim.fn.pathshorten(vim.fn.expand('%:h') .. '/')
  end

  return path
end

local diagnostic_ok = function()
  if (#vim.lsp.get_active_clients()) == 0 then return '-' end
  local diagnostics = vim.diagnostic.get(0)
  local error_count, warning_count
  local count = { 0, 0, 0, 0 }
  for _, diagnostic in ipairs(diagnostics) do
    if vim.startswith(vim.diagnostic.get_namespace(diagnostic.namespace).name, 'vim.lsp') then
      count[diagnostic.severity] = count[diagnostic.severity] + 1
    end
  end
  error_count = count[vim.diagnostic.severity.ERROR]
  warning_count = count[vim.diagnostic.severity.WARN]
  if error_count == 0 and warning_count == 0 then
    return ' '
  end

  return ''
end

local git_branch = function()
  local branch_name = vim.b.gitsigns_head
  if branch_name == nil then return '' end
  if (string.len(branch_name) > 19 and vim.fn.winwidth(0) < width_threshold) then
    return ' ' .. string.sub(branch_name, 1, 16).."..."
  end

  return ' ' .. branch_name .. ' '
end

local mode_info = {
  c      = { fg = colours.yellow,      label = 'C'},
  cv     = { fg = colours.yellow,      label = 'C'},
  i      = { fg = colours.mid_green,     label = 'I'},
  ic     = { fg = colours.mid_green,     label = 'I'},
  n      = { fg = colours.normal_gray, label = 'N'},
  r      = { fg = colours.orange,      label = 'R'},
  rm     = { fg = colours.orange,      label = 'R'},
  R      = { fg = colours.orange,      label = 'R'},
  Rv     = { fg = colours.orange,      label = 'R'},
  ['r?'] = { fg = colours.orange,      label = 'R'},
  s      = { fg = colours.blue_gray,   label = 'S'},
  S      = { fg = colours.blue_gray,   label = 'S'},
  [''] = { fg = colours.blue_gray,   label = 'S'},
  t      = { fg = colours.purple,      label = 'T'},
  v      = { fg = colours.br_indigo,      label = 'V'},
  V      = { fg = colours.br_indigo,      label = 'V'},
  [''] = { fg = colours.br_indigo,      label = 'V'},
  ['!']  = { fg = colours.br_indigo,      label = '!'},
  ['']   = { fg = colours.br_indigo,      label = '-'}
}

ins_a {
  function ()
    local mode = mode_info[vim.fn.mode()]

    return '' .. mode.label
  end,
  color = function ()
    return { fg = mode_info[vim.fn.mode()].fg.hex, gui = 'bold' }
  end,
  cond = conditions.check_line_filetype,
}

ins_a {
  function ()
    return '|'
  end,
  color = { fg = colours.mid_dark_gray.hex },
  padding = { 0 },
  cond = conditions.check_line_filetype,
}

ins_a {
  current_path,
  color = { fg = colours.mid_gray.hex },
  padding = { left = 1 },
  cond = conditions.check_line_filetype,
}

ins_a {
  'filename',
  symbols = {
    readonly = ' ',
  },
  color = { fg = colours.mid_gray_alt2.hex },
  padding = { 0 },
  cond = conditions.check_line_filetype,
}

ins_a {
  function ()
    return ''
  end,
  color = { fg = colours.mid_dark_gray.hex },
  padding = { left = 1 },
  cond = conditions.check_line_filetype,
}

ins_a {
  'diagnostics',
  sources = { 'nvim_diagnostic' },
  symbols = { error = '', warn = '▲', info = '', hint = '⚑' },
  symbol_position = 'right',
  diagnostics_color = {
    error = { fg = colours.mid_red.hex },
    warn = { fg = colours.mid_gray.hex },
    info = { fg = colours.mid_gray.hex },
    hint = { fg = colours.mid_gray.hex },
  },
  padding = { left = 1 },
  cond = conditions.check_line_filetype,
}

ins_a {
  diagnostic_ok,
  color = { fg = colours.green.hex },
  cond = conditions.check_line_filetype,
}

ins_a {
  search_result,
  color = { fg = colours.mid_gray.hex },
  cond = conditions.check_line_filetype and conditions.hide_in_secondary_width,
}

ins_a {
  fill_line,
  color = { fg = colours.mid_dark_gray.hex, bg = colours.bg.hex },
  padding = {0},
  cond = function ()
    local in_line_list = conditions.check_line_filetype()
    return not in_line_list
  end
}

ins_x {
  'diff',
  symbol_position = 'right',
  cond = conditions.check_line_filetype,
}

ins_x {
  git_branch,
  cond = conditions.check_git_workspace and conditions.hide_in_secondary_width and conditions.check_line_filetype,
}

ins_x {
  check_encoding,
  padding = { 0 },
  cond = conditions.buffer_not_empty and conditions.check_line_filetype,
}

ins_x {
  check_fileformat,
  padding = { 0 },
  cond = conditions.buffer_not_empty and conditions.check_line_filetype,
}

ins_x {
  'filetype',
  icons_enabled = false,
  colored = false,
  padding = { left = 0, right = 1 },
  cond = conditions.buffer_not_empty and conditions.check_line_filetype,
}

ins_x {
  function ()
    return '|'
  end,
  color = { fg = colours.mid_dark_gray.hex },
  padding = {0},
  cond = conditions.check_line_filetype,
}

ins_x {
  location_progress,
  padding = {0},
  cond = conditions.check_line_filetype,
}

table.insert(config.inactive_sections.lualine_a, {
  function ()
    return '——'
  end,
  color = { fg = colours.mid_dark_gray.hex },
  padding = {0},
  cond = conditions.check_line_filetype,
})

table.insert(config.inactive_sections.lualine_a, {
  'filename',
  color = { fg = colours.mid_gray.hex, gui = 'italic' },
  padding = {0},
  cond = conditions.check_line_filetype,
})

table.insert(config.inactive_sections.lualine_a, {
  function ()
    local width = vim.fn.winwidth(0)
    local filename = vim.fn.expand('%:t')
    if filename == '' then
      filename = '[No Name]'
    end
    local location = location_short()
    local fill = ''
    local adj = 0
    if vim.bo.modified then
      adj = adj + 4
    end
    if vim.bo.modifiable == false or vim.bo.readonly then
      adj = adj + 4
    end

    for i = 1, (width - string.len(filename) - string.len(location) - 4 - adj) , 1 do
      fill = fill .. '—'
    end

    return fill
  end,
  color = { fg = colours.mid_dark_gray.hex },
  padding = {0},
  cond = conditions.check_line_filetype,
})

table.insert(config.inactive_sections.lualine_a, {
  function ()
    return location_short()
  end,
  color = { fg = colours.mid_gray.hex, gui = 'italic' },
  padding = {0},
  cond = conditions.check_line_filetype,
})

table.insert(config.inactive_sections.lualine_a, {
  function ()
    return '——'
  end,
  color = { fg = colours.mid_dark_gray.hex },
  padding = {0},
  cond = conditions.check_line_filetype,
})

table.insert(config.inactive_sections.lualine_a, {
  fill_line,
  color = { fg = colours.mid_dark_gray.hex },
  padding = {0},
  cond = function ()
    local in_line_list = conditions.check_line_filetype()
    return not in_line_list
  end
})

require'lualine'.setup(config)
