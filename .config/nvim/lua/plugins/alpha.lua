local path_ok, plenary_path = pcall(require, "plenary.path")
if not path_ok then
    return
end

local dashboard = require("alpha.themes.dashboard")
local cdir = vim.fn.getcwd()
local if_nil = vim.F.if_nil

local alpha = require'alpha'
local fortune = require'alpha.fortune'

local calvin_array = {
  [[                             __                     ]],
  [[                  _ww   _a+"D                       ]],
  [[          y#,  _r^ # _*^  y`                        ]],
  [[         q0 0 a"   W*`    F   ____                  ]],
  [[       ;  #^ Mw`  __`. .  4-~~^^`                   ]],
  [[      _  _P   ` /'^           `www=.                ]],
  [[    , $  +F    `                q                   ]],
  [[    K ]                         ^K`                 ]],
  [[  , #_                . ___ r    ],                 ]],
  [[  _*.^            '.__dP^^~#,  ,_ *,                ]],
  [[  ^b    / _         ``     _F   ]  ]_               ]],
  [[   '___  '               ~~^    ]   [               ]],
  [[   :` ]b_    ~k_               ,`  yl               ]],
  [[     #P        `*a__       __a~   z~`               ]],
  [[     #L     _      ^------~^`   ,/                  ]],
  [[      ~-vww*"v_               _/`                   ]],
  [[              ^"q_         _x"                      ]],
  [[               __#my..___p/`mma____                 ]],
  [[           _awP",`,^"-_"^`._ L L  #                 ]],
  [[         _#0w_^_^,^r___...._ t [],"w                ]],
  [[        e^   ]b_x^_~^` __,  .]Wy7` x`               ]],
  [[         '=w__^9*$P-*MF`      ^[_.=                 ]],
  [[             ^"y   qw/"^_____^~9 t                  ]],
  [[               ]_l  ,'^_`..===  x'                  ]],
  [[                ">.ak__awwwwWW###r                  ]],
  [[                  ##WWWWWWWWWWWWWW__                ]],
  [[                 _WWWWWWMM#WWWW_JP^"~-=w_           ]],
  [[       .____awwmp_wNw#[w/`     ^#,      ~b___.      ]],
  [[        ` ^^^~^"W___            ]Raaaamw~`^``^^~    ]],
  [[                  ^~"~---~~~~~~`                    ]],
}

local function lineToStartGradient(lines)
  local out = {}
  for i, line in ipairs(lines) do
    table.insert(out, { hi = "StartLogo"..i, line = line})
  end
  return out
end

local calvin_gradient = lineToStartGradient(calvin_array)

local function coloured_header()
  local lines = {}
  for _, lineConfig in pairs(calvin_gradient) do
    local hi = lineConfig.hi
    local line_chars = lineConfig.line
    local line = {
      type = "text",
      val = line_chars,
      opts = {
        hl = hi,
        shrink_margin = false,
        position = "center",
      },
    }
    table.insert(lines, line)
  end

  local output = {
    type = "group",
    val = lines,
    opts = { position = "center", },
  }

  return output
end

local function file_button(fn, sc, short_fn, autocd)
    short_fn = short_fn or fn
    local ico_txt = ""
    local fb_hl = {}

    local cd_cmd = (autocd and " | cd %:p:h" or "")
    local file_button_el = dashboard.button(sc, ico_txt .. short_fn, "<cmd>e " .. fn .. cd_cmd .." <CR>")
    local fn_start = short_fn:match(".*[/\\]")
    if fn_start ~= nil then
        table.insert(fb_hl, { "Comment", #ico_txt - 2, #fn_start + #ico_txt })
    end
    file_button_el.opts.hl = fb_hl
    file_button_el.opts.width = 58

    return file_button_el
end

local default_mru_ignore = { "gitcommit" }

local mru_opts = {
    ignore = function(path, ext)
        return (string.find(path, "COMMIT_EDITMSG")) or (vim.tbl_contains(default_mru_ignore, ext))
    end,
    autocd = false
}

local function get_extension(fn)
    local match = fn:match("^.+(%..+)$")
    local ext = ""
    if match ~= nil then
        ext = match:sub(2)
    end
    return ext
end

local function mru(start, cwd, items_number, opts)
    opts = opts or mru_opts
    items_number = if_nil(items_number, 10)

    local oldfiles = {}
    for _, v in pairs(vim.v.oldfiles) do
        if #oldfiles == items_number then
            break
        end
        local cwd_cond
        if not cwd then
            cwd_cond = true
        else
            cwd_cond = vim.startswith(v, cwd)
        end
        local ignore = (opts.ignore and opts.ignore(v, get_extension(v))) or false
        if (vim.fn.filereadable(v) == 1) and cwd_cond and not ignore then
            oldfiles[#oldfiles + 1] = v
        end
    end
    local target_width = 55

    local tbl = {}
    for i, fn in ipairs(oldfiles) do
        local short_fn
        if cwd then
            short_fn = vim.fn.fnamemodify(fn, ":.")
        else
            short_fn = vim.fn.fnamemodify(fn, ":~")
        end

        if #short_fn > target_width then
            short_fn = plenary_path.new(short_fn):shorten(1, { -2, -1 })
            if #short_fn > target_width then
                short_fn = plenary_path.new(short_fn):shorten(1, { -1 })
            end
        end

        local shortcut = tostring(i + start - 1)

        local file_button_el = file_button(fn, shortcut, short_fn,opts.autocd)
        tbl[i] = file_button_el
    end
    return {
        type = "group",
        val = tbl,
        opts = {},
    }
end

local mru_section = {
  type = 'group',
  val = {
        {
            type = 'text',
            val = "Recent files",
            opts = {
                hl = 'Bold',
                shrink_margin = false,
                position = "center",
            },
        },
        { type = 'padding', val = 1 },
        {
            type = 'group',
            val = function()
                return { mru(0, cdir, 7) }
            end,
            opts = { shrink_margin = false },
        },
    },
}

local message = {
  type = 'text',
  val = fortune({ max_width = 63 }),
  opts = {
    position = 'center',
    hl = 'Comment',
  },
}

local config = {
  layout = {
    coloured_header(),
    { type = 'padding', val = 1 },
    mru_section,
    { type = 'padding', val = 1 },
    message,
  },
  opts = {
    setup = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'AlphaReady',
        desc = 'disable status, tabline and cmdline for alpha',
        callback = function()
          vim.go.laststatus = 0
          vim.opt.showtabline = 0
          vim.opt.cmdheight = 0
        end,
      })
      vim.api.nvim_create_autocmd('BufUnload', {
        buffer = 0,
        desc = 'enable status, tabline and cmdline after alpha',
        callback = function()
          vim.go.laststatus = 3
          vim.opt.showtabline = 2
          vim.opt.cmdheight = 1
        end,
      })
    end,
    margin = 5,
  },
}

alpha.setup(config)
