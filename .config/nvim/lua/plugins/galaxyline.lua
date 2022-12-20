require('falcon')
require('plugins.utils')

local colors = vim.api.nvim_get_var('falcon.palette')
local gl = require('galaxyline')
local gls = gl.section
local condition = require('galaxyline.condition')
local vcs = require('galaxyline.providers.vcs')
local iconz = require("nvim-nonicons")
local buffer = require("galaxyline.providers.buffer")

-- change these to a table
local separator_tri_left = ''
local separator_tri_right = ''
local separator_2_tri_left = ''
local separator_2_tri_right = ''

local width_cutoff = 120;

-- TODO:
-- shortline could be better, maybe file type in there?
-- shortline, if enough space show path with filename
-- try having the mode right in the middle?! < N > or / N \ - could even just be the colour of the mode and darker background
-- or icons for the mode? pencil, pointer for select, prompt for terminal, etc.
-- or even just have a colour in the middle
-- do we even need the mode? or bar colour is the mode? filename in the middle
-- one colour version, maybe the mode is in the middle? maybe when in normal mode, don't need to indicate mode

-- GOLD PLATING:
-- Vim icon right at the start on left?
-- make some things togglable
-- change highlights to names
-- clean up any vim code in here, can it be replaced now?

local file_format = function()
  local icons = {
    dos = ' ',
    mac  = ' ',
    unix = ' '
  }
  if icons[vim.bo.fileformat] then
    return icons[vim.bo.fileformat]
  end

  return ' '
end

local is_wide = function()
  return vim.fn.winwidth(0) > width_cutoff
end

local location_stats = function()
  local line = vim.fn.line('.')
  local column = vim.fn.col('.')
  local line_column = tostring(line) .. ':' .. string.lpad(tostring(column), 2, ' ')
  local percent = require('galaxyline.providers.fileinfo').current_line_percent()

  -- Calculate padding depending on the number of lines
  local total_lines = vim.fn.line('$')
  if total_lines == nil then total_lines = 0 end
  local total_chars = string.len(tostring(total_lines))
  local line_width = total_chars + 4;
  return string.rpad(line_column, line_width, ' ') .. ' |' .. string.lpad(percent, 5, ' ')
end

local short_location_stats = function()
  return vim.fn.line('.') .. ':' .. vim.fn.col('.')
end

local git_branch = function()
  local branch_name = vcs.get_git_branch()
  if branch_name == nil then return '' end
  if (string.len(branch_name) > 19 and vim.fn.winwidth(0) < width_cutoff) then
    return string.sub(branch_name, 1, 16).."..."
  end

  return branch_name
end

local file_readonly = function()
  if vim.bo.readonly == true then return '' end

  return ''
end

local current_path = function()
  local path = vim.api.nvim_exec([[
    if winwidth(0) < 60
      echo ''
    elseif winwidth(0) > 120
      echo expand('%:h').'/'
    else
      echo pathshorten(expand('%:h') . '/')
    endif
    ]], true)
  if string.len(path) > 19 then
    path = vim.api.nvim_exec([[
      echo pathshorten(expand('%:h') . '/')
      ]], true)
  end

  return path
end

local current_file_name = function()
  local file = vim.api.nvim_exec([[
    echo expand('%:t')
    ]], true)
  if vim.fn.empty(file) == 1 then return '' end
  if string.len(file_readonly()) ~= 0 then return file .. file_readonly() end
  if vim.bo.modifiable and vim.bo.modified then return file .. '!' end
  return file
end

local file_is_modified = function()
  if vim.bo.modifiable then
    if vim.bo.modified then return true end
  end
  return false
end

local diagnostic_ok = function()
  if vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then return '-' end
  local error = require('galaxyline.providers.diagnostic').get_diagnostic_error()
  local warn = require('galaxyline.providers.diagnostic').get_diagnostic_warn()
  if error == nil then
    error = ""
  end
  if warn == nil then
    warn = ""
  end
  if error .. warn ~= "" then
    return ''
  end

  return ' '
end

local mode_info = {
  c      = { fg = colors.black, bg = colors.yellow,      label = iconz.get("vim-command-mode") },
  cv     = { fg = colors.black, bg = colors.yellow,      label = iconz.get("vim-command-mode") },
  i      = { fg = colors.black, bg = colors.red,         label = iconz.get("vim-insert-mode") },
  ic     = { fg = colors.black, bg = colors.red,         label = iconz.get("vim-insert-mode") },
  n      = { fg = colors.black, bg = colors.normal_gray, label = iconz.get("vim-normal-mode") },
  r      = { fg = colors.black, bg = colors.orange,      label = iconz.get("vim-replace-mode") },
  rm     = { fg = colors.black, bg = colors.orange,      label = iconz.get("vim-replace-mode") },
  R      = { fg = colors.black, bg = colors.orange,      label = iconz.get("vim-replace-mode") },
  Rv     = { fg = colors.black, bg = colors.orange,      label = iconz.get("vim-replace-mode") },
  ['r?'] = { fg = colors.black, bg = colors.orange,      label = iconz.get("vim-replace-mode") },
  s      = { fg = colors.black, bg = colors.blue_gray,   label = iconz.get("vim-select-mode") },
  S      = { fg = colors.black, bg = colors.blue_gray,   label = iconz.get("vim-select-mode") },
  [''] = { fg = colors.black, bg = colors.blue_gray,   label = iconz.get("vim-select-mode") },
  t      = { fg = colors.black, bg = colors.purple,      label = iconz.get("terminal") },
  v      = { fg = colors.white, bg = colors.indigo,      label = iconz.get("vim-visual-mode") },
  V      = { fg = colors.white, bg = colors.indigo,      label = iconz.get("vim-visual-mode") },
  [''] = { fg = colors.white, bg = colors.indigo,      label = iconz.get("field") },
  ['!']  = { fg = colors.black, bg = colors.indigo,      label = '!' },
  ['']   = { fg = colors.black, bg = colors.indigo,      label = '-' }
}

local get_mode_info = function()
  return mode_info[vim.fn.mode()]
end

local hide_filetypes = {'nerdtree', 'fugitive', 'startify', 'NvimTree'}
local hide_filetype = function()
  return not table.contains(hide_filetypes, vim.bo.filetype)
end

gl.short_line_list = {
  'NvimTree',
  'fugitive',
  'fugitiveblame',
  'gitcommit',
  'help',
  'nerdtree',
  'packer',
  'qf',
  'startify',
  'tagbar',
  'vista',
}

table.insert(gls.left, {
  ViMode = {
    provider = function()
      local mode = get_mode_info()
      vim.api.nvim_command('hi GalaxyViMode guifg=' .. mode.fg .. ' guibg=' .. mode.bg)

      return '  ' .. mode.label .. ' '
    end,
    highlight = {colors.red,colors.status}
  }
})

table.insert(gls.left, {
  ModeSeparator = {
    provider = function()
      local mode = get_mode_info()
      vim.api.nvim_command('hi GalaxyModeSeparator guifg=' .. mode.bg .. ' guibg=' .. colors.status_2)
      return separator_tri_left..' '
    end,
    highlight = {colors.red, colors.status}
  }
})

table.insert(gls.left, {
  FilePath = {
    provider = current_path,
    highlight = {colors.path, colors.status_2}
  }
})

table.insert(gls.left, {
  FileName = {
    provider = function()
      vim.api.nvim_command('hi GalaxyFileName gui=NONE')
      if file_is_modified() then
        vim.api.nvim_command('hi GalaxyFileName gui=Italic')
      end
      return current_file_name()
    end,
    highlight = {colors.light_gray, colors.status_2}
  }
})

table.insert(gls.left, {
  LeftSpace = {
    provider = function() return ' ' end,
    highlight = {colors.normal_gray, colors.status_2}
  }
})

table.insert(gls.left,  {
  FileSeparator = {
    provider = function() return separator_2_tri_left end,
    separator = ' ',
    separator_highlight = {'NONE', colors.status},
    highlight = {colors.status_2, colors.status}
  }
})

table.insert(gls.left, {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = iconz.get("x") .. ' ',
    separator_highlight = {'NONE', colors.status},
    highlight = {colors.error, colors.status},
  }
})

table.insert(gls.left, {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = iconz.get("alert") .. ' ',
    separator_highlight = {'NONE', colors.status},
    highlight = {colors.warning, colors.status},
  }
})

table.insert(gls.left, {
    DiagnosticHint = {
    provider = 'DiagnosticHint',
    icon = iconz.get("light-bulb") .. ' ',
    separator_highlight = {'NONE', colors.status},
    highlight = {colors.hint, colors.status}
  }
})

table.insert(gls.left, {
  DiagnosticInfo = {
    provider = 'DiagnosticInfo',
    icon = ' ' ,
    separator_highlight = {'NONE', colors.status},
    highlight = {colors.info, colors.status},
  }
})

table.insert(gls.left, {
 DiagnosticOk = {
   provider = diagnostic_ok,
   highlight = {colors.green, colors.status}
 }
})

table.insert(gls.right, {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = condition.check_git_workspace,
    icon = iconz.get("plus") .. ' ',
    highlight = {colors.green, colors.status}
  }
})

table.insert(gls.right, {
  DiffModified = {
    provider = 'DiffModified',
    condition = condition.check_git_workspace,
    icon = iconz.get("dot-fill") .. ' ',
    highlight = {colors.orange, colors.status}
  }
})

table.insert(gls.right, {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = condition.check_git_workspace,
    icon = iconz.get("dash") .. ' ',
    highlight = {colors.red, colors.status}
  }
})

table.insert(gls.right, {
  GitBranch = {
    provider = git_branch,
    icon = '   ',
    condition = condition.buffer_not_empty and condition.check_git_workspace,
    highlight = {colors.branch, colors.status},
  }
})

table.insert(gls.right, {
  FileInfoSeparator = {
    provider = function() return '  ┊ ' end,
    condition = function()
      if is_wide() == false then return false end
      return condition.check_git_workspace() and condition.buffer_not_empty()
    end,
    highlight = {colors.mid_gray, colors.status},
  }
})

table.insert(gls.right, {
  FileSize = {
    provider = 'FileSize',
    condition = condition.buffer_not_empty and is_wide,
    highlight = {colors.path, colors.status},
  },
})

table.insert(gls.right, {
  FileType = {
    provider = function() return buffer.get_buffer_filetype():lower() .. ' ' end,
    condition = condition.buffer_not_empty and is_wide,
    highlight = {colors.path, colors.status},
  },
})

table.insert(gls.right, {
  FileFormat = {
    provider = function() return file_format() .. ' ' end,
    condition = condition.buffer_not_empty and is_wide,
    separator_highlight = {'NONE', colors.status},
    highlight = {colors.mid_gray, colors.status},
  }
})

-- table.insert(gls.right, {
--   FileEncode = {
--     provider = function() return file_encode() .. ' ' end,
--     icon = '',
--     condition = condition.buffer_not_empty and condition.hide_in_width,
--     separator_highlight = {'NONE', colors.status},
--     highlight = {colors.mid_gray, colors.status},
--   }
-- })

table.insert(gls.right, {
  LocationStats = {
    provider = location_stats,
    separator = separator_2_tri_right,
    separator_highlight = {colors.status_2, colors.status},
    highlight = {colors.normal_gray, colors.status_2},
  }
})

table.insert(gls.right, {
  RightModeSeparator = {
    provider = function()
      local mode = get_mode_info()
      vim.api.nvim_command('hi GalaxyRightModeSeparator guifg='..mode.bg..' guibg='..colors.status_2)

      return separator_tri_right
    end,
    highlight = {colors.red, colors.status}
  }
})

table.insert(gls.right, {
  RightSpace = {
    provider = function()
      local mode = get_mode_info()
      vim.api.nvim_command('hi GalaxyRightSpace guifg='..mode.fg..' guibg='..mode.bg)

      return ' '
    end,
    highlight = {colors.red, colors.status}
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
    provider = current_file_name,
    condition = hide_filetype,
    highlight = {colors.mid_dark_gray, colors.inactive_status, 'italic'}
  }
})

table.insert(gls.short_line_right, {
  ShortLineInfo = {
    provider = short_location_stats,
    condition = hide_filetype,
    highlight = {colors.mid_dark_gray, colors.inactive_status, 'italic'},
  },
});

table.insert(gls.short_line_right, {
  ShortSpace = {
    provider = function() return ' ' end,
    highlight = {colors.mid_dark_gray, colors.inactive_status}
  }
})

-- Force manual load so that nvim boots with a status line
gl.load_galaxyline()
