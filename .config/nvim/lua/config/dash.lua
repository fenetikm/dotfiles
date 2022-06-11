local g = vim.g
-- g.dashboard_preview_command = 'cat'
-- g.dashboard_preview_pipeline = 'lolcat -S 80 -p 10'
-- g.dashboard_preview_file = '~/.config/nvim/dashboard.txt'
g.dashboard_preview_file_height = 17
g.dashboard_preview_file_width = 80
g.dashboard_disable_statusline = 1
g.dashboard_custom_footer = { " " }
g.dashboard_custom_section = {
   a = { description = { "  Find File                 CTL p  " }, command = "Telescope find_files" },
   b = { description = { "  Recents                   SPC f h" }, command = "Telescope oldfiles" },
   c = { description = { "  Find Word                 SPC f w" }, command = "Telescope live_grep" },
   d = { description = { "洛 New File                  SPC f n" }, command = "DashboardNewFile" },
   e = { description = { "  Bookmarks                 SPC b m" }, command = "Telescope marks" },
   f = { description = { "  Load Last Session         SPC l  " }, command = "SessionLoad" },
}

g.dashboard_custom_header = {
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
}

local utils = require('telescope.utils')
local set_var = vim.api.nvim_set_var

local git_root, ret = utils.get_os_command_output({ "git", "rev-parse", "--show-toplevel" }, vim.loop.cwd())

local function get_dashboard_git_status()
  local git_cmd = {'git', 'status', '-s', '--', '.'}
  local output = utils.get_os_command_output(git_cmd)
  set_var('dashboard_custom_footer', {'Git status', '', unpack(output)})
end

if ret ~= 0 then
  local is_worktree = utils.get_os_command_output({ "git", "rev-parse", "--is-inside-work-tree" }, vim.loop.cwd())
  if is_worktree[1] == "true" then
    get_dashboard_git_status()
  else
    set_var('dashboard_custom_footer', {''})
  end
else
    get_dashboard_git_status()
end
