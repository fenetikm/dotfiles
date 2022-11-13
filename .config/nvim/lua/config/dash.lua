local db = require("dashboard")
db.preview_file_height = 18
db.preview_file_width = 80
db.hide_statusline = 1
db.custom_footer = { " " }
db.custom_center = {
   { icon = "  ", desc = "Find File            ", shortcut = "CTL p  ", action = "Telescope find_files" },
   { icon = "  ", desc = "Recents              ", shortcut = "SPC f h", action = "Telescope oldfiles" },
   { icon = "  ", desc = "Find Word            ", shortcut = "SPC f w" , action = "Telescope live_grep" },
   { icon = "洛 ", desc = "New File             ", shortcut = "SPC f n" , action = "DashboardNewFile" },
   { icon = "  ", desc = "Bookmarks            ", shortcut = "SPC b m" , action = "Telescope marks" },
   { icon = "  ", desc = "Load Last Session    ", shortcut = "SPC l  " , action = "SessionLoad" },
}
db.custom_header = {
"",
"                             __                     ",
"                  _ww   _a+\"D                       ",
"          y#,  _r^ # _*^  y`                        ",
"         q0 0 a\"   W*`    F   ____                  ",
"       ;  #^ Mw`  __`. .  4-~~^^`                   ",
"      _  _P   ` /'^           `www=.                ",
"    , $  +F    `                q                   ",
"    K ]                         ^K`                 ",
"  , #_                . ___ r    ],                 ",
"  _*.^            '.__dP^^~#,  ,_ *,                ",
"  ^b    / _         ``     _F   ]  ]_               ",
"   '___  '               ~~^    ]   [               ",
"   :` ]b_    ~k_               ,`  yl               ",
"     #P        `*a__       __a~   z~`               ",
"     #L     _      ^------~^`   ,/                  ",
"      ~-vww*\"v_               _/`                   ",
"              ^\"q_         _x\"                      ",
"               __#my..___p/`mma____                 ",
"           _awP\",`,^\"-_\"^`._ L L  #                 ",
"         _#0w_^_^,^r___...._ t [],\"w                ",
"        e^   ]b_x^_~^` __,  .]Wy7` x`               ",
"         '=w__^9*$P-*MF`      ^[_.=                 ",
"             ^\"y   qw/\"^_____^~9 t                  ",
"               ]_l  ,'^_`..===  x'                  ",
"                \">.ak__awwwwWW###r                  ",
"                  ##WWWWWWWWWWWWWW__                ",
"                 _WWWWWWMM#WWWW_JP^\"~-=w_           ",
"       .____awwmp_wNw#[w/`     ^#,      ~b___.      ",
"        ` ^^^~^\"W___            ]Raaaamw~`^``^^~    ",
"                  ^~\"~---~~~~~~`                    ",
"",
"",
""
}

local utils = require('telescope.utils')
local set_var = vim.api.nvim_set_var

local git_root, ret = utils.get_os_command_output({ "git", "rev-parse", "--show-toplevel" }, vim.loop.cwd())

local function get_dashboard_git_status()
  local git_cmd = {'git', 'status', '-s', '--', '.'}
  local output = utils.get_os_command_output(git_cmd)
  local db = require('dashboard')
  set_var('db.custom_footer', {'Git status', '', unpack(output)})
end

if ret ~= 0 then
  local is_worktree = utils.get_os_command_output({ "git", "rev-parse", "--is-inside-work-tree" }, vim.loop.cwd())
  local db = require('dashboard')
  if is_worktree[1] == "true" then
    get_dashboard_git_status()
  else
    set_var('db.custom_footer', {''})
  end
else
    get_dashboard_git_status()
end
