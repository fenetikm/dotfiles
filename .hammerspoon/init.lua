-- @todo:
-- https://github.com/Hammerspoon/hammerspoon/discussions/3254 using sockets to talk to yabai... but seems fast enough
-- https://github.com/FelixKratz/JankyBorders for controlling window border colours
-- https://github.com/FelixKratz/SketchyVim also looks fun
-- vivaldi browser for ricing
-- https://github.com/ClementTsang/bottom another monitor like btop
-- https://zzamboni.org/post/my-hammerspoon-configuration-with-commentary/ sendtoomnifocus looks interesting and others
--
-- how many layouts do we have for ultrawide:
-- - 1 browser, 23 kitty
-- - 1 bitbucket, 1 browser, 1 browser
-- - 1/2 bitbucket, 1/2 browser
-- - 1 x, 23 Jira
-- - 1 x, 23 tableplus
-- - 1 obsidian, 23 slack video
-- - 1 x, 23 reports
--
-- so layouts are:
-- 1 + 23
-- 1/2 + 1/2
-- 1 + 1 + 1
--
-- also I like the idea of headspace, which hides apps during a time period
--
-- like freedom I guess, maybe could just use that? or want to migrate away from that?
-- hide:
-- - slack, email... etc.

G = {}
G.log = hs.logger.new('mw', 'debug')
G.loggingEnabled = true
d = function(message)
  if G.loggingEnabled then
    G.log.d(message)
  end
end

G.alert_style = {
  textSize = 18,
  radius = 18,
  atScreenEdge = 2,
  fadeInDuration = 0.05,
  fadeOutDuration = 0.05,
  padding = 8
}

s = function(message)
  if G.loggingEnabled then
    hs.alert.show(message, G.alert_style)
  end
end

G.yabai_path = "/usr/local/bin/yabai"
G.bin_path = "/usr/local/bin"
if hs.fs.displayName(G.yabai_path) == nil then
  G.yabai_path = "/opt/homebrew/bin/yabai"
  G.bin_path = "/opt/homebrew/bin"
  hs.ipc.cliInstall("/opt/homebrew")
else
  hs.ipc.cliInstall()
end

hs.loadSpoon("URLDispatcher")
local function appID(app)
  return hs.application.infoForBundlePath(app)['CFBundleIdentifier']
end
local obsidianApp = appID('/Applications/obsidian.app')

hs.window.animationDuration = 0

local screen_mapping = {"cmd", "alt", "ctrl"}
local hyper_mapping = {"cmd", "alt", "ctrl", "shift"}

sk = {}

local reloadConfig = function(files)
  doReload = false
  for _, file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    hs.reload()
    hs.alert.show('Hammerspoon config loaded')
  end
end

-- this is faster than os.execute with the env arg
local yabai_script = function(script_name, args)
  -- s('script!')
  local task = hs.task.new(os.getenv('HOME') .. '/.config/yabai/' .. script_name, nil, args)
  local env = task:environment()
  env['PATH'] = env['PATH'] .. ':' .. G.bin_path
  task:setEnvironment(env)
  task:start()
end

-- todo: handling of windows in other spaces, sometimes doesn't work? maybe when also minimized
local launchOrFocus = function(appName, details)
  if (details.url) then
    spoon.URLDispatcher.url_patterns = {
      {'obsidian:', obsidianApp},
      -- {'https:', chromeApp},
      -- {'http:', chromeApp}
    }

    spoon.URLDispatcher:dispatchURL('', '', '', details.url)
  end

  local found = false
  for _, app in pairs(hs.application.runningApplications()) do
    if app:name() == appName then
      -- handle minimized windows
      local vis = false
      local winCount = 0
      for _, win in pairs(app:allWindows()) do
        if not win:isMinimized() then
          vis = true
        end
        winCount = winCount + 1
      end

      -- if not visible and there is only one possible window, or
      -- multiple windows
      if not vis and winCount == 1 or winCount > 1 then
        for _, win in pairs(app:allWindows()) do
          win:unminimize()
        end
      end

      app:setFrontmost(true)
      found = true
    end
  end

  if found then
    if details.yabai_script then
      yabai_script(details.yabai_script, {})
    end

    return
  end

  hs.application.launchOrFocus(appName)

  if details.yabai_script then
    yabai_script(details.yabai_script, {})
  end
end

hk = {}
hs.fnutils.each({
  { key = "f", app = "Finder" },
  { key = "s", app = "Slack" },
  { key = "g", app = "Google Chrome" },
  { key = "space", app = "kitty", yabai_script = "kitty.sh" },
  { key = "e", app = "Mail"},
  { key = "p", url = "obsidian://open?vault=personal" },
  { key = "q", app = "TablePlus"},
  { key = "n", app = "Notes"},
  { key = "c", app = "Calendar"},
  { key = "j", app = "Jira"},
  { key = "k", app = "Bitbucket"},
  { key = "o", app = "Confluence"},
  { key = "r", app = "Metabase"},
  { key = "return", app = "Omnifocus"},
  { key = "z", url = "obsidian://open?vault=zettelkasten" },
  { key = "v", url = "obsidian://open?vault=PC" },
  { key = "m", app = "Messages"},
  { key = "i", app = "Music"},
  { key = "b", app = "BoltAI" },
}, function(object)
    hk[object.key] = hs.hotkey.bind(hyper_mapping, object.key, function() launchOrFocus(object.app, object) end)
end)

G.reloadWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
s('Hammerspoon reloaded')

hk['l'] = hs.hotkey.bind(hyper_mapping, 'l', function() hs.caffeinate.systemSleep() end)

hk['='] = hs.hotkey.bind(hyper_mapping, '=', function()
  hs.reload()
  s('Hammerspoon config reloaded')
end)

-- begin yabai window management
local yabai = function(args, completion)
  local yabai_output = ""
  local yabai_error = ""
  -- Runs in background very fast
  local yabai_task = hs.task.new(G.yabai_path, function(err, stdout, stderr)
    print()
  end, function(task, stdout, stderr)
      -- print("stdout:"..stdout, "stderr:"..stderr)
      if stdout ~= nil then
        yabai_output = yabai_output .. stdout
      end
      if stderr ~= nil then
        yabai_error = yabai_error .. stderr
      end
      return true
    end, args)
  if type(completion) == "function" then
    yabai_task:setCallback(function()
      completion(yabai_output, yabai_error)
    end)
  end
  yabai_task:start()
end

local lastSeenChain = nil
local lastSeenWindow = nil

-- adapted from wincent https://github.com/wincent/wincent/blob/master/roles/dotfiles/files/.hammerspoon/init.lua
local chain_yabai = function(movements)
  local chainResetInterval = 2 -- seconds
  local cycleLength = #movements
  local sequenceNumber = 1

  return function()
    local now = hs.timer.secondsSinceEpoch()

    if
      lastSeenChain ~= movements or
      lastSeenAt < now - chainResetInterval
    then
      sequenceNumber = 1
      lastSeenChain = movements
    elseif (sequenceNumber == 1) then
      -- At end of chain, restart chain on next screen.
      -- screen = screen:next()
    end
    lastSeenAt = now

    if string.find(movements[sequenceNumber][1], ".sh") then
      yabai_script(movements[sequenceNumber][1], movements[sequenceNumber][2])
    else
      -- todo: non script call
      hs.alert.show('non script call')
    end

    sequenceNumber = sequenceNumber % cycleLength + 1
  end
end

local yabai_mode = hs.hotkey.modal.new('', 'f19')
function yabai_mode:entered() s('WM?') end
function yabai_mode:exited() s('WM!') end
yabai_mode:bind('', 'escape', function()
  yabai_mode:exit()
end)

local bindKey = function(key, fn, modifier)
  modifier = modifier or ''
  local ret
  ret = yabai_mode:bind(modifier, key, function()
    fn()
    yabai_mode:exit()
  end)

  return ret
end

-- toggle float
sk['space'] = bindKey('space', function() yabai_script('float.sh', {}) end)

-- hide all floats on current space
sk['shift_space'] = bindKey('space', function() yabai_script('hide_floats.sh', {}) end, 'shift')

-- reload yabai
sk['r'] = bindKey('r', function() os.execute(G.yabai_path .. ' --restart-service') end)

-- todo: new idea:
-- - more explicit, ok to be multi key
-- - <key> <space> <position>
-- could have keys instead of numbers for spaces, home row even?
-- where position can be 1,2,3
-- if currently only one app visible, then puts the new window to the left or right (1 = left, 2 = right)
-- when more than one app then insert accordingly
-- e.g. put this app on space two, in position 1
--
--another one re sending something to space 6 and in the middle etc.
--"present"
-- todo2:
-- - balancing/layout keys to set it to 1/3, 2/3 vs 1/2, 1/2 vs 2/3, 1/3
-- - asd? home row probs better here, also could use wasd for doing the things instead of hjkl for ease
-- ... or put everything under hjkl for ease?! could be nice!
-- so hjkl for move
-- shift hjkl for layout
-- ctrl hjkl for insert
-- meta hjkl for ?

-- ok, if we did spacefn, what would be the mapping?
-- probs don't have enough things to require shft/ctrl to do things, also can chain things
-- prefer home row where possible
-- another idea: long hold , triggers hs mode? maybe too fiddly
-- or can we do space, double tap the thing? good for send to space
-- how about: spacefn+<key> or spacefn+<key><key> is mapped to f19 (go into hammerspoon mode, then sends either key or shift_key?!)
-- hjkl - select window? we're not going up or down, leave that for mouse
-- things that I want to do regularly:
-- - move window left/right
-- - move window to next display (can we do that with left/right?)
-- - change layout / window sizes: 1/3,1/2,1/4,2/3
-- - center window
-- - full screen, or focus size
-- - put window on another space
-- - present
-- - toggle float
-- - reload yabai
-- - preset sizes
-- - minimise / hide
-- less often:
-- - go from stack to split easily
-- - change space mode: bsp,stack,float
-- - balance - useless if layout works?
-- - send to display (remove, instead left/right or send to space)

-- move / swap
sk['h'] = bindKey('h', function() yabai({'-m', 'window', '--swap', 'west'}) end)
sk['j'] = bindKey('j', function() yabai({'-m', 'window', '--swap', 'south'}) end)
sk['k'] = bindKey('k', function() yabai({'-m', 'window', '--swap', 'north'}) end)
sk['l'] = bindKey('l', function() yabai({'-m', 'window', '--swap', 'east'}) end)

-- layout sizing
-- maybe change layout to something else besides hkjl
sk['shift_h'] = bindKey('h', function() yabai_script('resize.sh', {'x', '13', '0', '1'}) end, 'shift')
sk['shift_j'] = bindKey('j', function() yabai_script('resize.sh', {'x', '12', '0', '1'}) end, 'shift')
sk['shift_k'] = bindKey('k', function() yabai_script('resize.sh', {'x', '23', '0', '1'}) end, 'shift')

-- insert current window into position and balance
sk['ctrl_h'] = bindKey('h', function() yabai_script('insert.sh', {'1'}) end, 'control')
sk['ctrl_j'] = bindKey('j', function() yabai_script('insert.sh', {'2'}) end, 'control')
sk['ctrl_k'] = bindKey('k', function() yabai_script('insert.sh', {'3'}) end, 'control')

-- todo3:
-- - when we have two floated things, want to put them side by side, keeping the size they are currently at
--
-- todo4:
-- - easy way to go from one app to split screen with two apps, in case of just on laptop
--
-- todo5:
-- - when dragging a window, how to float whilst dragging? some other hot key, or double tap f19?!

-- send to other display
sk['comma'] = bindKey(',', function() yabai_script('send_display.sh', {'2'}) end)
sk['period'] = bindKey('.', function() yabai_script('send_display.sh', {'1'}) end)

-- space mapping
sk['1'] = bindKey('1', function() yabai({'-m', 'space', '--focus', '1'}) end)
sk['2'] = bindKey('2', function() yabai({'-m', 'space', '--focus', '2'}) end)
sk['3'] = bindKey('3', function() yabai({'-m', 'space', '--focus', '3'}) end)
sk['4'] = bindKey('4', function() yabai({'-m', 'space', '--focus', '4'}) end)
sk['5'] = bindKey('5', function() yabai({'-m', 'space', '--focus', '5'}) end)
sk['6'] = bindKey('6', function() yabai({'-m', 'space', '--focus', '6'}) end)

-- float and full screen, then 1600x1200, then 1400x900
sk['f'] = bindKey('f', chain_yabai({
  { 'resize.sh', {'c', 'full', '1'} },
  { 'resize.sh', {'c', '1600,1200', '1'} },
  { 'resize.sh', {'c', '1400,900', '1'} },
}))

-- full screen but over the top bar
sk['shift_f'] = bindKey('f', function() yabai_script('resize.sh', {'c', 'fullwindow', '1'}) end, 'shift')

-- todo: hjkl to select a window, shift to move
-- - then another for layout I think... above hjkl? yui?

-- todo: be able to do the below with a browser tab
sk['p'] = bindKey('p', function() yabai_script('resize.sh', {'c', '1600,1200', '1', '0', '6'}) end)

-- screen recording sizes, todo: something better here re which keys
sk['0'] = bindKey('0', function() yabai_script('resize.sh', {'c', '1400,900', '1'}) end)
-- gif recording
sk['9'] = bindKey('9', function() yabai_script('resize.sh', {'c', '700,450', '1'}) end)

-- balance widths of the things
sk['b'] = bindKey('b', function() yabai({'-m', 'space', '--balance'}) end)

-- set mode, todo: better here, maybe one key and cycle? or a selector
-- also reset transparency stuff after mode change
sk['z'] = bindKey('z', function() yabai({'-m', 'space', '--layout', 'bsp'}) end)
sk['x'] = bindKey('x', function() yabai({'-m', 'space', '--layout', 'float'}) end)
sk['c'] = bindKey('c', function() yabai({'-m', 'space', '--layout', 'stack'}) end)

-- center
sk['g'] = bindKey('g', function() yabai_script('resize.sh', {'c', 'x'}) end)
 
-- "smart" minimise
-- if there is more than one window then use the minimise action
-- otherwise use "hide"
sk['m'] = bindKey('m', function()
  local frontmost = hs.application.frontmostApplication()
  local frontmost_windows = frontmost:allWindows()
  if (#frontmost_windows > 1) then
    yabai({'-m', 'window', '--minimize'})
  else
    frontmost:hide()
  end
end)

-- todo: update to the bindKey style
-- send to space and focus
yabai_mode:bind('shift', '1', function()
  yabai({'-m', 'window', '--space', '1'}, function()
    yabai({'-m', 'space', '--focus', '1'})
    yabai_mode:exit()
  end)
end)
yabai_mode:bind('shift', '2', function()
  yabai({'-m', 'window', '--space', '2'}, function()
    yabai({'-m', 'space', '--focus', '2'})
    yabai_mode:exit()
  end)
end)
yabai_mode:bind('shift', '3', function()
  yabai({'-m', 'window', '--space', '3'}, function()
    yabai({'-m', 'space', '--focus', '3'})
    yabai_mode:exit()
  end)
end)
yabai_mode:bind('shift', '4', function()
  yabai({'-m', 'window', '--space', '4'}, function()
    yabai({'-m', 'space', '--focus', '4'})
    yabai_mode:exit()
  end)
end)
yabai_mode:bind('shift', '5', function()
  yabai({'-m', 'window', '--space', '5'}, function()
    yabai({'-m', 'space', '--focus', '5'})
    yabai_mode:exit()
  end)
end)
yabai_mode:bind('shift', '6', function()
  yabai({'-m', 'window', '--space', '6'}, function()
    yabai({'-m', 'space', '--focus', '6'})
    yabai_mode:exit()
  end)
end)
