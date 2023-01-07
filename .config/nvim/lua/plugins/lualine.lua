local colours = require('falcon.colours')
local width_threshold = 120

local config = {
  options = {
    icons_enabled = true,
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {
        'NvimTree',
        'fugitive',
        'startify',
        'nerdtree',
        'fugitiveblame',
        'qf',
      },
      winbar = {},
    },
    theme = {
      normal = {
        a = { fg = colours.mid_gray.hex, bg = colours.status.hex },
        x = { fg = colours.mid_gray.hex, bg = colours.status.hex },
      },
      inactive = {
        a = { fg = colours.mid_dark_gray.hex, bg = colours.inactive_status.hex, gui = 'italic' },
        x = { fg = colours.mid_dark_gray.hex, bg = colours.inactive_status.hex, gui = 'italic' },
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
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

local function ins_a(component)
  table.insert(config.sections.lualine_a, component)
end

local function ins_x(component)
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
  return last_search .. '(' .. searchcount.current .. '/' .. searchcount.total .. ')'
end

local location_progress = function()
  local line = vim.fn.line('.')
  local total_lines = vim.fn.line('$')
  if total_lines == nil then total_lines = 0 end
  local column = vim.fn.col('.')
  local line_column = tostring(line) .. ':' .. lpad(tostring(column), 2, ' ')
  local perc = ''
  if line == 1 then
    perc = ' Top'
  elseif line == total_lines then
    perc = ' End'
  else
    perc = string.format(' %2d', math.floor(line / total_lines * 100)) .. '%%'
  end

  perc = perc .. ' '

  local total_chars = string.len(tostring(total_lines))
  local line_width = total_chars + 4
  return rpad(line_column, line_width, ' ') .. perc
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

local file_readonly = function()
  if vim.bo.readonly == true then return ' ' end

  return ''
end

local current_file_name = function()
  local file = vim.fn.expand('%:t')
  if vim.fn.empty(file) == 1 then return '' end
  if string.len(file_readonly()) ~= 0 then return file .. file_readonly() end
  if vim.bo.modifiable and vim.bo.modified then return file .. ' +' end

  return file
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

  return ' ' .. branch_name .. ' ┊'
end

local mode_info = {
  c      = { fg = colours.yellow,      label = 'C'},
  cv     = { fg = colours.yellow,      label = 'C'},
  i      = { fg = colours.red,         label = 'I'},
  ic     = { fg = colours.red,         label = 'I'},
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
}

ins_a {
  function ()
    return '|'
  end,
  color = { fg = colours.mid_dark_gray.hex },
  padding = { 0 },
}

ins_a {
  current_path,
  color = { fg = colours.mid_gray.hex },
  padding = { left = 1 },
}

-- ins_a {
--   current_file_name,
--   color = { fg = colours.mid_gray_alt2.hex },
--   padding = { 0 },
-- }
ins_a {
  'filename',
  symbols = {
    readonly = ' ',
  },
  color = { fg = colours.mid_gray_alt2.hex },
  padding = { 0 },
}

ins_a {
  function ()
    return '┊'
  end,
  color = { fg = colours.mid_dark_gray.hex },
  padding = { left = 1 }
}

ins_a {
  'diagnostics',
  sources = { 'nvim_diagnostic' },
  symbols = { error = 'x', warn = '!', info = 'i', hint = '?' },
  padding = { left = 1 },
}

ins_a {
  diagnostic_ok,
  color = { fg = colours.green.hex },
}

ins_x {
  'diff',
}

ins_x {
  git_branch,
  cond = conditions.check_git_workspace,
}

ins_x {
  'filesize',
  padding = { 0 },
  cond = conditions.buffer_not_empty
}

ins_x {
  'fileformat',
  cond = conditions.buffer_not_empty
}

ins_x {
  'filetype',
  colored = false,
  cond = conditions.buffer_not_empty
}

ins_x {
  function ()
    return '|'
  end,
  color = { fg = colours.mid_dark_gray.hex },
  padding = {0},
}

ins_x {
  location_progress,
  padding = {0},
}

table.insert(config.inactive_sections.lualine_a, {
  'filename',
  symbols = {
    readonly = ' ',
  },
})

table.insert(config.inactive_sections.lualine_x, {
  'location',
  padding = { right = 0 }
})

require'lualine'.setup(config)