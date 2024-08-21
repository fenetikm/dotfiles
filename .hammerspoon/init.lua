-- @todo:
-- what do we want and / or do?
-- nothing underneath so transparency works
-- a button to hide everything that isn't visible - is that possible?
-- yes with layouts
-- so keep top most windows, and focus window is
-- common layouts:
-- ultra + laptop:
-- - 1/3 browser, 2/3 terminal, slack / email / messages / omni
-- - 1/3 bitbucket, 1/3 browser, 1/3 something else
-- - 1/2 bitbucket, 1/2 browser
-- - 1/3 browser, 2/3 db or jira or metabase
-- - 1/3 obsidian, 1/3 obsidian
-- also somethings centered on top e.g. omnifocus, music
-- so want a way to specify that and that window isn't "layout managed"
-- also, on dual, change layout to 1/2, 1/2 or 2/3, 1/3 on main screen
-- sometimes have uncommon layouts - turn off hiding mechanism, go manual
-- how does it work then?
-- all windows minimized by default?
-- let's build the one screen version first
-- - open something new, it opens on top or full screen?
-- - when we alt tab, hide window underneath, but depends on which app
-- when switching to an app:
-- - single screen, either full screen or on top
-- - dual screen
--
-- think about what should happen:
-- starting: 1/3 chrome, 2/3 kitty
-- jira - 2/3, (kitty hidden)
--
-- might want to specifically say how to handle certain apps
-- yes, and have policies
-- e.g.
-- full screen only
-- left, right
-- unmanaged, centered
-- also when there is a left and right showing, can resize to go half half
-- and "force" full screen
--
-- could use f keys for layouts? instead of numbers? maybe numbers still ok
--
-- when launching an app for first time:
-- - if we use alfred then only get the app event
-- - so... just go with that
-- - can we still get the last focused window at that point? not from there, unless it is the deactivated one?
--
-- in single screen, we just have modes
-- i.e. full screen or split screen
-- when in full screen simples
-- in split, when you switch, it should swap out the focused with the next one
--
-- not sure how to handle when there are multiple windows?
--
-- ... so I think the "easiest" thing is to have layouts, per screen
-- and then the manager works with that
-- layouts are:
-- full and split 1/2
-- split 1/3, 2/3
-- split 1/3, 1/3, 1/3
--
-- you can also overlay/float windows, unmanaged
--
-- so, track the layout per screen?
-- problem is that most of the time I want the terminal open
--
-- new app start on top, centered
-- then you send them where you want them to go
-- which you would do by
--
-- ... issues though, but layouts, in general is good
--
-- need a compromise version
--
-- need a way to send an app to a location in the layout
-- check evan travers hs
--
-- another idea, changing mapping of hyper to f19 (travers)
-- and screen to f20
-- and allow modifiers to do other things e.g. open beside
--
-- Also to look at:
-- https://github.com/mogenson/PaperWM.spoon talks about swiping on trackpad... use for something?
-- https://github.com/Hammerspoon/hammerspoon/discussions/3254 using sockets to talk to yabai
-- https://github.com/FelixKratz/JankyBorders for controlling window border colours
-- https://github.com/FelixKratz/SketchyVim also looks fun
-- look at yabai, can send messages to it to do stuff, consider what it would look like if I used it
-- ... what about when I have a terminal split, it has a gap?! need to use kitty for that? see https://blog.adamchalmers.com/kitty-terminal-config/
-- can use the kitty layouts
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
-- WINNING IDEA
-- OK, latest idea:
-- - diff layouts per screen, set with a key (or two?)
-- - instead of specifying shape of window, tell it to go to a "layout position"
-- - when you swap to an app, it goes to the last position it was in
-- - can cycle app positions in the layout
--
-- - also maybe just have chains for cycling through thirds / halves etc.
--
-- also I like the idea of headspace, which hides apps during a time period
-- like freedom I guess, maybe could just use that? or want to migrate away from that?
-- hide:
-- - slack, email... etc.
--
-- snap to grid on switch, how does that work with windows? might need to do the ui element monitoring...
-- maybe that is a nice to have
--
-- order of todo:
-- window watcher with reload - done
-- toggle management - done
-- reloader - done
-- make space for sketchybar - done
-- only manage windows on internal display for now
--
-- note, if we want to have different margins around the edge vs margins between windows then would have to not use the hammerspoon grid

-- for global vars
-- see https://github-wiki-see.page/m/asmagill/hammerspoon/wiki/Variable-Scope-and-Garbage-Collection
-- NOTE
-- WE NEED TO REPLACE `local` with global for anything that we want to keep
-- or isn't referenced anywhere else e.g. callbacks are referenced in the thing that they are registered with
-- need to think about each one
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

G.managerEnabled = false
G.switchingLayouts = false

hs.loadSpoon("URLDispatcher")
local function appID(app)
  return hs.application.infoForBundlePath(app)['CFBundleIdentifier']
end
local obsidianApp = appID('/Applications/obsidian.app')

local gridWidth = 12
local gridHeight = 12
local gridMargin = 16
local barHeight = 32

-- hs.grid.setGrid('12x12') -- can also specify a frame here to leave room for sketchybar
hs.grid.ui.textSize = 20
hs.grid.setMargins({gridMargin, gridMargin})
hs.window.animationDuration = 0

-- this type of defn is fine because it is only called once
G.setupGrid = function()
  s('setup grid')
  for _, screen in pairs(hs.screen.allScreens()) do
    local screenFrame = screen:fullFrame()
    local updatedFrame = hs.geometry.new(screenFrame.x, barHeight, screenFrame.w, screenFrame.h)
    hs.grid.setGrid('12x12', screen, updatedFrame)
  end
end
G.setupGrid()

local screen_mapping = {"cmd", "alt", "ctrl"}
local hyper_mapping = {"cmd", "alt", "ctrl", "shift"}

local grid = {
  topHalf = '0,0 12x6',
  topThird = '0,0 12x4',
  topTwoThirds = '0,0 12x8',
  rightHalf = '6,0 6x12',
  rightThird = '8,0 4x12',
  rightTwoThirds = '4,0 8x12',
  bottomHalf = '0,6 12x6',
  bottomThird = '0,8 12x4',
  bottomTwoThirds = '0,4 12x8',
  leftHalf = '0,0 6x12',
  leftThird = '0,0 4x12',
  leftTwoThirds = '0,0 8x12',
  topLeft = '0,0 6x6',
  topRight = '6,0 6x6',
  bottomRight = '6,6 6x6',
  bottomLeft = '0,6 6x6',
  middleVertical = '4,0 4x12',
  middleThird = '4,0 4x12',
  middleHorizontal = '0,4 12x4',
  middleTwoThirds = '2,0 8x12',
  fullScreen = '0,0 12x12',
  centeredHuge = '2,1 8x10',
  centeredBig = '3,2 6x8',
  focus = '3,1 6x10',
  leftFocus = '3,1 3x10',
  rightFocus = '6,1 3x10',
}

local layouts = {
  full = {
    fullScreen
  },
  halves = {
    leftHalf,
    rightHalf,
  },
  -- third_twothirds = {
  --   leftThird,
  --   rightTwoThirds,
  -- },
  -- thirds = {
  --   leftThird,
  --   middleThird,
  --   rightThird,
  -- },
}

local screenState = {}
local layoutManager = {}

-- I'm thinking that the screen names would determing the initial layouts
-- work one is 'ASUS PB278'
local initScreenState = function()
  s('init screen state')
  for _, screen in pairs(hs.screen.allScreens()) do
    screenState[screen:name()] = { layout = 1, apps = {} }
  end
end

local handleScreenEvent = function(window)
  d('handle screen event')
  -- todo, plugging in a screen, do a thing
end

local unmanagedApps = {
  'org.hammerspoon.Hammerspoon'
}

local internalDisplay = (function()
  return hs.screen.find('Built%-in')
end)

local canManageWindow = function(window)
  d('check manage window')
  local app = window:application()
  for _, bundleID in ipairs(unmanagedApps) do
    if app:bundleID() == bundleID then
      return false
    end
  end

  return true
end

local translateEventType = function(eventType)
  if eventType == hs.application.watcher.activated then
    return 'Activated'
  elseif eventType == hs.application.watcher.deactivated then
    return 'Deactivated'
  elseif eventType == hs.application.watcher.hidden then
    return 'Hidden'
  elseif eventType == hs.application.watcher.launched then
    return 'Launched'
  elseif eventType == hs.application.watcher.launching then
    return 'Launching'
  elseif eventType == hs.application.watcher.unhidden then
    return 'Unhidden'
  end

  return 'Unknown'
end

-- taken from wincent https://github.com/wincent/wincent/blob/master/roles/dotfiles/files/.hammerspoon/init.lua
local lastSeenChain = nil
local lastSeenWindow = nil

local chain = (function(movements)
  s('chain')
  local chainResetInterval = 2 -- seconds
  local cycleLength = #movements
  local sequenceNumber = 1

  return function()
    local win = hs.window.frontmostWindow()
    local id = win:id()
    local now = hs.timer.secondsSinceEpoch()
    local screen = win:screen()

    if
      lastSeenChain ~= movements or
      lastSeenAt < now - chainResetInterval or
      lastSeenWindow ~= id
    then
      sequenceNumber = 1
      lastSeenChain = movements
    elseif (sequenceNumber == 1) then
      -- At end of chain, restart chain on next screen.
      screen = screen:next()
    end
    lastSeenAt = now
    lastSeenWindow = id

    hs.grid.set(win, movements[sequenceNumber], screen)
    sequenceNumber = sequenceNumber % cycleLength + 1
  end
end)

shk = {}

local setupChains = function(screen_mapping)
  shk['f'] = hs.hotkey.bind(screen_mapping, 'f', chain({
    grid.fullScreen,
    grid.focus,
  }))
end

local chooseSpace = function(choice)
  s(choice.uuid)
end

local setSpace = function()
  local chooser = hs.chooser.new(chooseSpace)
  -- todo fill with possible apps
  chooser:choices({
    {
      ['text'] = 'First choice',
      ['uuid'] = 1,
    },
    {
      ['text'] = 'Second choice',
      ['uuid'] = 2,
    }
  })
  chooser:rows(5)
  chooser:width(30)
  chooser:show()
end

-- assumption is that ALL windows for an app will get hidden at once
-- todo: change layouts for a screen
local changeLayout = function()
  local frontmostApp = hs.application.frontmostApplication()
  -- s(frontmostApp)
  local appScreen = frontmostApp:mainWindow():screen()
  -- s(screenState[appScreen:name()].layout)
end

local appPositions = {}
local setAppPositions = function()
  for _, app in pairs(hs.application.runningApplications()) do
    -- set all apps to layout position 1
    appPositions[app:pid()] = 1
  end
end
setAppPositions()

local hideAll = function()
  for _, app in pairs(hs.application.runningApplications()) do
    app:hide()
  end
end

local hideOtherApps = function(screenName)
  d('hide other apps')
  -- for _, app in pairs(hs.application.runningApplications()) do
  --   app:hide()
  --   local found = false
  --   local appPid = app:pid()
  --   if not found then
  --     if not app:isHidden() then
  --       app:hide()
  --     end
  --   end
  -- end
  -- for _, layoutPid in pairs(screenState[screenName].apps) do
  --   local layoutApp = hs.application.applicationForPID(layoutPid)
  --   layoutApp:unhide()
  -- end
end

-- hide all first, then can swap

-- what does this do with multiple windows?!
local sendAppLayoutPosition = function(position, app)
  -- s(app)
  local frontmostApp = hs.application.frontmostApplication()
  s('send app' .. frontmostApp:name())
  local appScreen = frontmostApp:mainWindow():screen()

  -- local previousAppPid = screenState[appScreen:name()].apps[1]
  -- previousApp:hide()

  screenState[appScreen:name()].apps[1] = frontmostApp:pid()

  hideOtherApps(appScreen:name())
end

local handleApplicationEvent = function(appName, eventType, app)
  -- s('handle application event')
  -- d(appName)
  -- d(app)
  -- d(app:bundleID())
  -- s(translateEventType(eventType))
  -- s(appName)

  if not G.managerEnabled then
    -- d('manager not enabled')
    return
  end

  if appName == 'loginwindow' then
    return
  end

  if eventType == hs.application.watcher.activated then
    -- s('Activated ' .. appName)
    -- s(screenState[internalDisplay():name()].apps[1])
    local appWindow = app:focusedWindow()
    if canManageWindow(appWindow) then
      local previousAppPid = screenState[appWindow:screen():name()].apps[1]
      if previousAppPid ~= nil then
        local previousApp = hs.application.applicationForPID(previousAppPid)
        -- previousApp:hide()
      end
      -- do something when one has multiple windows, might have to store them instead in the layout? and minimize?
      -- ignore for now
      -- if screenState[appWindow:screen():name()].apps[1] ~= nil then
      screenState[appWindow:screen():name()].apps[1] = app:pid()
      -- else

      -- end
      -- snap to screen layout
    end

    return
  end

  if eventType == hs.application.watcher.deactivated then
  end
end

local startHandling = function()
  d('start handler')
  G.screenWatcher = hs.screen.watcher.new(handleScreenEvent)
  G.screenWatcher:start()

  G.applicationWatcher = hs.application.watcher.new(handleApplicationEvent)
  G.applicationWatcher:start()
end

local stopHandling = function()
  if not G.screenWatcher then
    return
  end

  d('stop handler')
  G.screenWatcher:stop()
  G.screenWatcher = nil

  G.applicationWatcher:stop()
  G.applicationWatcher = nil
end

local reloadConfig = function(files)
  doReload = false
  for _, file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    d('should stop handling')
    stopHandling()
    hs.reload()
    hs.alert.show('Hammerspoon config loaded')
  end
end

local toggleManager = function()
  G.managerEnabled = not G.managerEnabled
  if G.managerEnabled then
    hs.alert.show('Window management enabled')
  else
    hs.alert.show('Window management disabled')
  end
end

local hideAll = function()
  for _, app in pairs(hs.application.runningApplications()) do
    for _, win in pairs(app:allWindows()) do
      win:minimize()
    end
  end
end

local moveToScreen = function(screenIndex)
  -- s('move to screen')
  local screens = hs.screen.allScreens()
  local win = hs.window.focusedWindow()
  local frontmostApp = hs.application.frontmostApplication()
  -- s(frontmostApp)

  -- s(screens[screenIndex]:name())
  -- 2 should always be the builtin
  if (screenIndex == 2 and screens[screenIndex]:name() ~= internalDisplay():name()) then
    screenIndex = 1
  elseif (screenIndex == 1 and screens[screenIndex]:name() == internalDisplay():name()) then
    screenIndex = 2
  end

  win:moveToScreen(screens[screenIndex], false, true);
end

local setGrid = function(key)
  local win = hs.window.focusedWindow()
  hs.grid.set(win, grid[key])
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

      -- if not visible and there is only one possible window
      if not vis and winCount == 1 then
        for _, win in pairs(app:allWindows()) do
          win:unminimize()
        end
      end

      app:setFrontmost(true)
      found = true
    end
  end

  if found then
    -- hideOtherApplications(appName)
    -- setGrid('fullScreen')

    return
  end

  hs.application.launchOrFocus(appName)

  -- hideOtherApplications(appName)
  -- hacks for now
  --
  -- note method called otherWindowsAllScreens
  -- and otherWindowsSameScreen()
  -- call application:hide() to do normal hide

  -- setGrid('fullScreen')
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
--
--
-- how to fix thunderbird issue:
-- - install yabai, use that for the window stuff?

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

-- hk['stop'] = hs.hotkey.bind(hyper_mapping, 'u', function()
--   s('hello')
--   s(hs.application.frontmostApplication():bundleID())
-- end)

shk['1'] = hs.hotkey.bind(screen_mapping, '1', function() moveToScreen(1) end)
shk['2'] = hs.hotkey.bind(screen_mapping, '2', function() moveToScreen(2) end)

-- shk['fullstop'] = hs.hotkey.bind(screen_mapping, '.', function() changeLayout() end)
-- shk['comma'] = hs.hotkey.bind(screen_mapping, ',', function() setSpace(1) end)
--
-- shk['j'] = hs.hotkey.bind(screen_mapping, 'j', function() hs.grid.toggleShow() end)

G.reloadWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show('Hammerspoon reloaded')

shk['l'] = hs.hotkey.bind(hyper_mapping, 'l', function() hs.caffeinate.systemSleep() end)
shk['return'] = hs.hotkey.bind(screen_mapping, 'return', function() toggleManager() end)

shk['q'] = hs.hotkey.bind(screen_mapping, 'q', function() setGrid('leftHalf') end)
shk['w'] = hs.hotkey.bind(screen_mapping, 'w', function() setGrid('rightHalf') end)
shk['e'] = hs.hotkey.bind(screen_mapping, 'e', function() setGrid('leftHalf') end)
shk['r'] = hs.hotkey.bind(screen_mapping, 'r', function() setGrid('rightHalf') end)

-- 1 row, thirds
shk['a'] = hs.hotkey.bind(screen_mapping, 'a', function() setGrid('leftThird') end)
shk['s'] = hs.hotkey.bind(screen_mapping, 's', function() setGrid('middleVertical') end)
shk['d'] = hs.hotkey.bind(screen_mapping, 'd', function() setGrid('rightThird') end)

-- 1 row, two thirds
shk['z'] = hs.hotkey.bind(screen_mapping, 'z', function() setGrid('leftTwoThirds') end)
shk['x'] = hs.hotkey.bind(screen_mapping, 'x', function() setGrid('middleTwoThirds') end)
shk['c'] = hs.hotkey.bind(screen_mapping, 'c', function() setGrid('rightTwoThirds') end)

shk['t'] = hs.hotkey.bind(screen_mapping, 't', function() sendAppLayoutPosition(1) end)
shk['h'] = hs.hotkey.bind(screen_mapping, 'h', function() hideAll() end)
-- hs.hotkey.bind(screen_mapping, 'i', function()
--   local win = hs.window.focusedWindow()
--   local currentScreen = win:screen()
--   hs.alert.show(currentScreen:name())
-- end)

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

setupChains(screen_mapping)
initScreenState()
startHandling()
