local colours = require('falcon.colours')

local config = {
  options = {
    icons_enabled = true,
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {'NvimTree', 'fugitive', 'startify', 'nerdtree'},
      winbar = {},
    },
    theme = {
      normal = { a = { fg = colours.mid_gray.hex, bg = colours.status.hex } },
      inactive = { a = { fg = colours.mid_dark_gray.hex, bg = colours.inactive_status.hex } },
    },
    ignore_focus = {},
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
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {'filename'},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

local function ins_a(component)
  table.insert(config.sections.lualine_a, component)
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

local file_readonly = function()
  if vim.bo.readonly == true then return '' end

  return ''
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

ins_a {
  current_path,
  color = { fg = colours.mid_gray.hex },
  padding = { 0 },
}

ins_a {
  current_file_name,
  color = { fg = colours.light_gray.hex },
  padding = { 0 },
}

require('lualine').setup(config)
