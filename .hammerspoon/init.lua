-- @todo:
-- https://github.com/Hammerspoon/hammerspoon/discussions/3254 using sockets to talk to yabai
-- https://github.com/FelixKratz/JankyBorders for controlling window border colours
-- https://github.com/FelixKratz/SketchyVim also looks fun
-- vivaldi browser for ricing
-- https://github.com/ClementTsang/bottom another monitor like btop
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

-- for global vars
-- see https://github-wiki-see.page/m/asmagill/hammerspoon/wiki/Variable-Scope-and-Garbage-Collection
G = {}
G.log = hs.logger.new('mw', 'debug')
G.loggingEnabled = true
d = function(message)
  if G.loggingEnabled then
    G.log.d(message)
  end
end

s = function(message)
  if G.loggingEnabled then
    hs.alert.show(message)
  end
end

local installed = hs.ipc.cliInstall()

hs.loadSpoon("URLDispatcher")
local function appID(app)
  return hs.application.infoForBundlePath(app)['CFBundleIdentifier']
end
local obsidianApp = appID('/Applications/obsidian.app')

hs.grid.ui.textSize = 16
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
    d('should stop handling')
    hs.reload()
    hs.alert.show('Hammerspoon config loaded')
  end
end

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
    return
  end

  hs.application.launchOrFocus(appName)
end

-- from evantravers
-- h = hs.hotkey.modal.new({}, nil)
-- function h:bindHotKeys(mapping)
-- end
-- h:bindHotKeys({})
--
--
-- bindings = {
--   {'Thunderbird', 'b', nil, nil},
--   {'Finder', 'f', nil, nil},
--   {'Slack', 's', nil, nil},
--   {'Google Chrome', 'g', nil, nil},
--   -- {'Brave Browser', 'x', nil},
--   {'kitty', 'space', nil, nil},
--   {'Mail', 'e', nil, nil},
--   {nil, 'e', nil, 'obsidian://open?vault=personal'},
--   {'TablePlus', 'q', nil, nil},
--   {'Notes', 'n', nil, nil},
--   {'Calendar', 'c', nil, nil},
--   {'Jira', 'j', nil, nil},
--   {'Bitbucket', 'k', nil, nil},
--   {'Confluence', 'o', nil, nil},
--   {'Metabase', 'r', nil, nil},
--   {'Omnifocus', 'return', {'\''}, nil},
--   {nil, 'z', nil, 'obsidian://open?vault=zettelkasten'},
--   {nil, 'v', nil, 'obsidian://open?vault=PC'},
--   {'Messages', 'm', nil, nil},
--   {'Music', 'i', nil, nil},
-- }
--
-- hs.fnutils.each(bindings, function(bindingConfig)
--   local appName, globalBind, localBins = table.unpack(bindingConfig)
--   -- if globalBind then
--   -- end
-- end)

hk = {}

hs.fnutils.each({
  { key = "b", app = "Thunderbird"},
  { key = "f", app = "Finder" },
  { key = "s", app = "Slack"},
  { key = "g", app = "Google Chrome" },
  { key = "x", app = "Brave Browser" },
  { key = "space", app = "kitty" },
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
}, function(object)
    hk[object.key] = hs.hotkey.bind(hyper_mapping, object.key, function() launchOrFocus(object.app, object) end)
end)

G.reloadWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show('Hammerspoon reloaded')

hk['l'] = hs.hotkey.bind(hyper_mapping, 'l', function() hs.caffeinate.systemSleep() end)

-- can't seem to get this to set all text font size?
-- and setting the colours to white doesn't work for all the text either?
hs.console.darkMode(false)
-- hs.console.outputBackgroundColor{ white = 0 }
-- hs.console.consoleCommandColor{ red = 1, green = 1, blue = 1 }
-- hs.console.consolePrintColor{ red = 1, green = 1, blue = 1 }
-- hs.console.consoleResultColor{ red = 1, green = 1, blue = 1 }
-- hs.console.alpha(1)
hs.console.consoleFont{name = 'Fira Code Regular', size = 16}
-- hs.console.clearConsole()

local yabai = function(args, completion)
  local yabai_output = ""
  local yabai_error = ""
  -- Runs in background very fast
  local yabai_task = hs.task.new("/usr/local/bin/yabai", function(err, stdout, stderr)
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

-- this is faster than os.execute with the env arg
local yabai_script = function(script_name, args)
  local task = hs.task.new(os.getenv('HOME') .. '/.config/yabai/' .. script_name, nil, args)
  local env = task:environment()
  env['PATH'] = env['PATH'] .. ':/usr/local/bin'
  task:setEnvironment(env)
  task:start()
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
      -- todo non script call
    end

    sequenceNumber = sequenceNumber % cycleLength + 1
  end
end

-- toggle float
sk['space'] = hs.hotkey.bind(screen_mapping, 'space', function() yabai_script('float.sh', {}) end)

-- reload
sk['r'] = hs.hotkey.bind(screen_mapping, 'r', function() os.execute('/usr/local/bin/yabai --restart-service') end)

-- centre, toggle between full and smaller
sk['c'] = hs.hotkey.bind(screen_mapping, 'c', chain_yabai({
  { 'centre.sh', {'2', '2'} },
  { 'centre.sh', {'2', '1'} },
}))
sk['x'] = hs.hotkey.bind(screen_mapping, 'x', chain_yabai({
  { 'centre.sh', {'1', '2'} },
  { 'centre.sh', {'1', '1'} },
}))
sk['v'] = hs.hotkey.bind(screen_mapping, 'v', chain_yabai({
  { 'centre.sh', {'3', '2'} },
  { 'centre.sh', {'3', '1'} },
}))

sk['k'] = hs.hotkey.bind(screen_mapping, 'k', function() yabai_script('kitty.sh', {}) end)

-- send to other display
sk['comma'] = hs.hotkey.bind(screen_mapping, ',', function() yabai_script('send_display.sh', {'2'}) end)
sk['period'] = hs.hotkey.bind(screen_mapping, '.', function() yabai_script('send_display.sh', {'1'}) end)

-- space mapping
sk['1'] = hs.hotkey.bind(screen_mapping, '1', function() yabai({'-m', 'space', '--focus', '1'}) end)
sk['2'] = hs.hotkey.bind(screen_mapping, '2', function() yabai({'-m', 'space', '--focus', '2'}) end)
sk['3'] = hs.hotkey.bind(screen_mapping, '3', function() yabai({'-m', 'space', '--focus', '3'}) end)

sk['f'] = hs.hotkey.bind(screen_mapping, 'f', function() yabai({'-m', 'window', '--toggle', 'zoom-fullscreen'}, function()
  yabai({'-m', 'window', '--grid', '12:12:0:0:12:12'})
end) end)

-- these aren't right
-- should they work if in stack mode and change mode?
-- sk['q'] = hs.hotkey.bind(screen_mapping, 'q', function() yabai({'-m', 'space', '--ratio', 'abs:0.3334'}) end)
-- sk['w'] = hs.hotkey.bind(screen_mapping, 'w', function() yabai({'-m', 'space', '--balance'}) end)
-- sk['e'] = hs.hotkey.bind(screen_mapping, 'e', function() yabai({'-m', 'space', '--ratio', 'abs:0.6667'}) end)

sk['z'] = hs.hotkey.bind(screen_mapping, 'z', function() yabai_script('balance.sh', {}) end)

-- toggle what happens when dropping a window on another
sk['p'] = hs.hotkey.bind(screen_mapping, 'p', function() yabai_script('toggle_drop.sh', {}) end)

-- set mode
sk['a'] = hs.hotkey.bind(screen_mapping, 'a', function() yabai({'-m', 'space', '--layout', 'bsp'}) end)
sk['s'] = hs.hotkey.bind(screen_mapping, 's', function() yabai({'-m', 'space', '--layout', 'float'}) end)
sk['d'] = hs.hotkey.bind(screen_mapping, 'd', function() yabai({'-m', 'space', '--layout', 'stack'}) end)

-- minimize, kinda like hide
sk['h'] = hs.hotkey.bind(screen_mapping, 'h', function() yabai({'-m', 'window', '--minimize'}) end)

-- sk['f'] = hs.hotkey.bind(screen_mapping, 'f', function() yabai({'-m', 'window', '--toggle', 'zoom-fullscreen'}) end)
-- change this to something else
-- sk['space'] = hs.hotkey.bind(screen_mapping, 'space', function() yabai({'-m', 'window', '--toggle', 'float'}) end)

local yabai_mode = hs.hotkey.modal.new('command+control+option', 'm')
-- local yabai_mode = hs.hotkey.modal.new('', 'f19')
function yabai_mode:entered() hs.alert'Entered moving mode' end
function yabai_mode:exited() hs.alert'Exited moving mode'  end
yabai_mode:bind('', 'escape', function()
  yabai_mode:exit()
end)

-- focus, rarely needed
yabai_mode:bind('', 'h', function()
  yabai({'-m', 'window', '--focus', 'west'})
  yabai_mode:exit()
end)
yabai_mode:bind('', 'l', function()
  yabai({'-m', 'window', '--focus', 'east'})
  yabai_mode:exit()
end)

-- swap
yabai_mode:bind('shift', 'h', function()
  yabai({'-m', 'window', '--swap', 'west'})
  yabai_mode:exit()
end)
yabai_mode:bind('shift', 'l', function()
  yabai({'-m', 'window', '--swap', 'east'})
  yabai_mode:exit()
end)

-- warp (split at the insert)
yabai_mode:bind('control+shift', 'h', function()
  yabai({'-m', 'window', '--swap', 'west'})
  yabai_mode:exit()
end)
yabai_mode:bind('control+shift', 'l', function()
  yabai({'-m', 'window', '--swap', 'east'})
  yabai_mode:exit()
end)

-- insert, set split position
-- yabai_mode:bind('control', 'h', function()
--   yabai({'-m', 'window', '--insert', 'west'})
--   yabai_mode:exit()
-- end)
-- yabai_mode:bind('control', 'l', function()
--   yabai({'-m', 'window', '--insert', 'east'})
--   yabai_mode:exit()
-- end)

-- send to space
yabai_mode:bind('', '1', function()
  yabai({'-m', 'window', '--space', '1'})
  yabai_mode:exit()
end)
yabai_mode:bind('', '2', function()
  yabai({'-m', 'window', '--space', '2'})
  yabai_mode:exit()
end)
yabai_mode:bind('', '3', function()
  yabai({'-m', 'window', '--space', '3'})
  yabai_mode:exit()
end)

-- stack the current window with the one currently underneath the mouse?
yabai_mode:bind('', 's', function()
  yabai({'-m', 'window', '--stack', 'mouse'})
  yabai_mode:exit()
end)

-- todo:
-- - toggle padding on space for ultrawide see: https://github.com/koekeishiya/yabai/issues/975

-- yabai todo:
-- working out how to use on ultrawide
