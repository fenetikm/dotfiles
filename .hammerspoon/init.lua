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
-- - 1 browser, 23 Jira
-- - 1 browser, 23 tableplus
-- - 1 obsidian, 23 slack video
--
-- order of todo:
-- window watcher with reload - done
-- toggle management - done
-- reloader - done
-- make space for sketchybar
-- only manage windows on internal display
-- opening new window, it is set to focus size
-- for global vars
G = {}
G.log = hs.logger.new('mw', 'debug')
d = G.log.d

G.managerEnabled = false

hs.loadSpoon("URLDispatcher")
local function appID(app)
  return hs.application.infoForBundlePath(app)['CFBundleIdentifier']
end
local obsidianApp = appID('/Applications/obsidian.app')

local gridWidth = 12
local gridHeight = 12
local gridMargin = 24
local barHeight = 40

local setupGrid = function()
  for _, screen in pairs(hs.screen.allScreens()) do
    local screenFrame = screen:fullFrame()
    local updatedFrame = hs.geometry.new(screenFrame.x, barHeight, screenFrame.w, screenFrame.h - barHeight)
    hs.grid.setGrid('12x12', screen, updatedFrame)
  end
end

setupGrid()

hs.grid.setGrid('12x12') -- can also specify a frame here to leave room for sketchybar
hs.grid.MARGINX = gridMargin
hs.grid.MARGINY = gridMargin

hs.window.animationDuration = 0

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
  third_twothirds = {
    leftThird,
    rightTwoThirds,
  },
  thirds = {
    leftThird,
    middleThird,
    rightThird,
  },
}

local screenState = {

}

local layoutManager = {

}

local initScreenState = function()
  for _, screen in pairs(hs.screen.allScreens()) do
    screenState[screen:name()] = layouts.full
  end
end

local handleScreenEvent = function(window)
  d('handle screen event')
  -- todo, plugging in a screen, do a thing
end

local unmanagedApps = {

}

local internalDisplay = (function()
  return hs.screen.find('Built%-in')
end)

local hideOtherApplications = function(appName)
  if not G.managerEnabled then
    return
  end
  for _, runningApp in pairs(hs.application.runningApplications()) do
    if runningApp:name() ~= appName then
      runningApp:hide()
    end
  end
end

local canManageWindow = function(window)
  local app = window:application()
  local bundleID = app:bundleID()

  -- if window:isStandard()

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

local setupChains = function(screen_mapping)
  hs.hotkey.bind(screen_mapping, 'f', chain({
    grid.fullScreen,
    grid.focus,
  }))
end

local handleApplicationEvent = function(appName, eventType, app)
  d('handle application event')
  d(appName)
  d(translateEventType(eventType))
  if not G.managerEnabled then
    return
  end

  if appName == 'loginwindow' then
    return
  end
  -- d(app:bundleID())
  -- d(app:pid())
  -- d(appName)
  -- d(eventType)
  -- hs.alert.show(translateEventType(eventType))
  if eventType == hs.application.watcher.activated then
    hs.alert.show('Activated ' .. appName)
  end

  local win = hs.window.frontmostWindow()
  if not win then
    return
  end

  local screen = win:screen()
  if screen:name() == internalDisplay():name() then
    if eventType == hs.application.watcher.activated then
      hideOtherApplications(appName, screen)
    end
  end
  -- d(id)
  -- d(screen)
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
  local screens = hs.screen.allScreens()
  local win = hs.window.focusedWindow()
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
    hideOtherApplications(appName)
    -- setGrid('fullScreen')

    return
  end

  hs.application.launchOrFocus(appName)

  hideOtherApplications(appName)

  -- hideOtherApplications(appName)
  -- hacks for now
  --
  -- note method called otherWindowsAllScreens
  -- and otherWindowsSameScreen()
  -- call application:hide() to do normal hide

  -- setGrid('fullScreen')
end

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
    hs.hotkey.bind(hyper_mapping, object.key, function() launchOrFocus(object.app, object) end)
end)

hs.hotkey.bind(screen_mapping, '1', function() moveToScreen(1) end)
hs.hotkey.bind(screen_mapping, '2', function() moveToScreen(2) end)

G.reloadWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show('Hammerspoon reloaded')

hs.hotkey.bind(hyper_mapping, 'l', function() hs.caffeinate.systemSleep() end)
hs.hotkey.bind(screen_mapping, 'return', function() toggleManager() end)

hs.hotkey.bind(screen_mapping, 'q', function() setGrid('leftHalf') end)
hs.hotkey.bind(screen_mapping, 'w', function() setGrid('rightHalf') end)
hs.hotkey.bind(screen_mapping, 'e', function() setGrid('leftHalf') end)
hs.hotkey.bind(screen_mapping, 'r', function() setGrid('rightHalf') end)

-- 1 row, thirds
hs.hotkey.bind(screen_mapping, 'a', function() setGrid('leftThird') end)
hs.hotkey.bind(screen_mapping, 's', function() setGrid('middleVertical') end)
hs.hotkey.bind(screen_mapping, 'd', function() setGrid('rightThird') end)

-- 1 row, two thirds
hs.hotkey.bind(screen_mapping, 'z', function() setGrid('leftTwoThirds') end)
hs.hotkey.bind(screen_mapping, 'x', function() setGrid('middleTwoThirds') end)
hs.hotkey.bind(screen_mapping, 'c', function() setGrid('rightTwoThirds') end)

hs.console.darkMode(false)
-- hs.console.outputBackgroundColor{ white = 0 }
-- hs.console.consoleCommandColor{ red = 1, green = 1, blue = 1 }
-- hs.console.consolePrintColor{ red = 1, green = 1, blue = 1 }
-- hs.console.consoleResultColor{ red = 1, green = 1, blue = 1 }
-- hs.console.alpha(1)
hs.console.consoleFont{name = 'Fira Code Regular', size = 16}
-- hs.console.clearConsole()

setupChains(screen_mapping)
-- startHandling()
