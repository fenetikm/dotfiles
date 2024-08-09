local ext = {
  app = {},
}

hs.loadSpoon("URLDispatcher")

local screen_mapping = {"cmd", "alt", "ctrl"}

local hyper_mapping = {"cmd", "alt", "ctrl", "shift"}

-- initial settings
hs.grid.setGrid('12x12') -- allows us to place on quarters, thirds and halves
hs.grid.MARGINX = 30
hs.grid.MARGINY = 30
hs.window.animationDuration = 0 -- disable animations

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
  middleHorizontal = '0,4 12x4',
  middleTwoThirds = '2,0 8x12',
  fullScreen = '0,0 12x12',
  centeredHuge = '2,1 8x10',
  centeredBig = '3,2 6x8',
  focus = '3,1 6x10',
  leftFocus = '3,1 3x10',
  rightFocus = '6,1 3x10',
}

local layoutMetrics = {
  leftThird = {x=0, y=0, w=0.333, h=1},
  leftHalf = {x=0, y=0, w=0.5, h=1},
  rightTwoThirds = {x=0.333, y=0, w=0.667, h=1},
  rightHalf = {x=0.5, y=0, w=0.5, h=1},
  middleThird = {x=0.333, y=0, w=0.333, h=1},
  screenshot1 = {x=1280, y=320, w=1280, h=960}
}

local glog = hs.logger.new('mylog', 'debug')

-- taken from wincent https://github.com/wincent/wincent/blob/master/roles/dotfiles/files/.hammerspoon/init.lua
local lastSeenChain = nil
local lastSeenWindow = nil

-- Chain the specified movement commands.
--
-- This is like the "chain" feature in Slate, but with a couple of enhancements:
--
--  - Chains always start on the screen the window is currently on.
--  - A chain will be reset after 2 seconds of inactivity, or on switching from
--    one chain to another, or on switching from one app to another, or from one
--    window to another.
--
chain = (function(movements)
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

-- get reference to internal display screen object
local internalDisplay = (function()
  return hs.screen.find('Built%-in')
end)

local setupChains = function(screen_mapping)
  hs.hotkey.bind(screen_mapping, 'up', chain({
    grid.topHalf,
    grid.topThird,
    grid.topTwoThirds,
  }))

  hs.hotkey.bind(screen_mapping, 'right', chain({
    grid.rightHalf,
    grid.rightThird,
    grid.rightTwoThirds,
  }))

  hs.hotkey.bind(screen_mapping, 'down', chain({
    grid.bottomHalf,
    grid.bottomThird,
    grid.bottomTwoThirds,
  }))

  hs.hotkey.bind(screen_mapping, 'left', chain({
    grid.leftHalf,
    grid.leftThird,
    grid.leftTwoThirds,
  }))

  hs.hotkey.bind(screen_mapping, 'f', chain({
    grid.fullScreen,
    grid.focus,
  }))
end

function ext.app.setGrid(key)
  local win = hs.window.focusedWindow()
  hs.grid.set(win, grid[key])
end

-- screen names
function ext.app.setPositionSize(settings)
  local win = hs.window.focusedWindow()
  local currentScreen = win:screen()
  local currentScreenName = currentScreen:name()
  local screenDimensions = currentScreen:fullFrame()

  -- convert pixels to units
  local layout = settings[currentScreenName]
  local rect = {
    layout[1] / screenDimensions.x2,
    layout[2] / screenDimensions.y2,
    layout[3] / screenDimensions.x2,
    layout[4] / screenDimensions.y2,
  }

  -- center if it exists
  if layout[5] then
    rect[1] = ((screenDimensions.x2 - layout[3]) * 0.5) / screenDimensions.x2
    rect[2] = ((screenDimensions.y2 - layout[4]) * 0.5) / screenDimensions.y2
  end

  win:moveToUnit(rect)
end

function ext.app.setCentre()
  local win = hs.window.focusedWindow()
  win:centerOnScreen()
end

function ext.app.moveToDisplay(screenIndex)
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

-- 1 row, halves
hs.hotkey.bind(screen_mapping, 'q', function() ext.app.setGrid('leftHalf') end)
hs.hotkey.bind(screen_mapping, 'w', function() ext.app.setGrid('rightHalf') end)
hs.hotkey.bind(screen_mapping, 'e', function() ext.app.setGrid('leftHalf') end)
hs.hotkey.bind(screen_mapping, 'r', function() ext.app.setGrid('rightHalf') end)

-- 1 row, thirds
hs.hotkey.bind(screen_mapping, 'a', function() ext.app.setGrid('leftThird') end)
hs.hotkey.bind(screen_mapping, 's', function() ext.app.setGrid('middleVertical') end)
hs.hotkey.bind(screen_mapping, 'd', function() ext.app.setGrid('rightThird') end)

-- 1 row, two thirds
hs.hotkey.bind(screen_mapping, 'z', function() ext.app.setGrid('leftTwoThirds') end)
hs.hotkey.bind(screen_mapping, 'x', function() ext.app.setGrid('middleTwoThirds') end)
hs.hotkey.bind(screen_mapping, 'c', function() ext.app.setGrid('rightTwoThirds') end)

-- for screen recording
hs.hotkey.bind(screen_mapping, '0', function() ext.app.setPositionSize({['LG ULTRAWIDE'] = {0, 0, 1400, 900, true}, ['Built-in Retina Display'] = {0, 0, 1400, 900, true}}) end)
-- half size, for gifs
hs.hotkey.bind(screen_mapping, '9', function() ext.app.setPositionSize({['LG ULTRAWIDE'] = {0, 0, 700, 450, true}, ['Built-in Retina Display'] = {0, 0, 700, 450, true}}) end)
-- 3840, 1920
-- margin is 30px
-- so
-- 30 + 1240 + 30 + 1240 + 30 + 1240 + 30
-- or
-- 30 + 1240 + 30 + 2510 + 30
-- rounded 2512 x 1413
-- for OBS
hs.hotkey.bind(screen_mapping, '8', function() ext.app.setPositionSize({['LG ULTRAWIDE'] = {0, 0, 2512, 1413, true}, ['Built-in Retina Display'] = {0, 0, 700, 450, true}}) end)

-- for OBS
-- TODO: put at the top, keep it on the LG screen
-- hs.hotkey.bind(screen_mapping, '9', function() ext.app.setLayout({x=0, y=0, w=1400, h=1440}) end)

hs.hotkey.bind(screen_mapping, 'space', function() ext.app.setGrid('focus') end)

-- send to other display
hs.hotkey.bind(screen_mapping, '1', function() ext.app.moveToDisplay(1) end)
hs.hotkey.bind(screen_mapping, '2', function() ext.app.moveToDisplay(2) end)

hs.hotkey.bind(screen_mapping, 'g', function() ext.app.setCentre() end)

-- normal minimize doesn't work in every app
hs.hotkey.bind(screen_mapping, 'm', function() hs.window.focusedWindow():minimize() end)

-- global operations
-- hs.hotkey.bind(screen_mapping, ';', function() hs.grid.snap(hs.window.focusedWindow()) end)
-- hs.hotkey.bind(screen_mapping, "'", function() hs.fnutil.map(hs.window.visibleWindows(), hs.grid.snap) end)

local homeDir = '/Users/michael'
local dirAtt = hs.fs.attributes(homeDir)
if (dirAtt == nil) then
  homeDir = '/Users/mjw'
end

-- https://github.com/digitalbase/hammerspoon/blob/master/init.lua
hs.fnutils.each({
  { key = "b", app = "Thunderbird", display = 2, size = 'fullScreen' },
  { key = "f", app = "Finder" },
  { key = "s", app = "Slack", display = 2, size = 'fullScreen' },
  { key = "g", app = "Google Chrome" },
  { key = "x", app = "Brave Browser" },
  { key = "space", app = "/Applications/kitty.app/Contents/MacOS/kitty" },
  { key = "e", app = "Mail", display = 2, size = 'fullScreen' },
  { key = "p", url = "obsidian://open?vault=personal" },
  -- { key = "d", app = homeDir .. "/.config/kitty/blog.sh", title = "blog", name = "kitty" },
  { key = "q", app = "TablePlus", display = 2, size = 'fullScreen' },
  { key = "n", app = "Notes", display = 2, size = 'fullScreen' },
  { key = "c", app = "Calendar"},
  { key = "j", app = "Jira"},
  { key = "k", app = "Bitbucket"},
  { key = "o", app = "Confluence"},
  { key = "r", app = "Metabase"},
  { key = "return", app = "Omnifocus", display = 1, size = 'focus' },
  { key = "z", url = "obsidian://open?vault=zettelkasten" },
  { key = "v", url = "obsidian://open?vault=PC" },
  { key = "m", app = "Messages", display = 2, size = 'fullScreen' },
  { key = "i", app = "Music", display = 2, size = 'fullScreen' },
  -- h is taken by hammerspoon reload, but do we need that?
}, function(object)
    hs.hotkey.bind(hyper_mapping, object.key, function() ext.app.forceLaunchOrFocus(object.app, object) end)
end)

function appID(app)
  return hs.application.infoForBundlePath(app)['CFBundleIdentifier']
end

-- apps for URL dispatching
local obsidianApp = appID('/Applications/obsidian.app')
local chromeApp = appID('/Applications/Google Chrome.app')

-- map mash+l to lock screen
hs.hotkey.bind(hyper_mapping, 'l', function() hs.caffeinate.systemSleep() end)

function ext.app.forceLaunchOrFocus(appName, object)
  local log = hs.logger.new('mylog', 'debug')
  local screenCount = #hs.screen.allScreens()

  -- allow using urls to open specific apps
  if (object.url) then
    spoon.URLDispatcher.url_patterns = {
      {'obsidian:', obsidianApp},
      {'https:', chromeApp},
      {'http:', chromeApp}
    }

    spoon.URLDispatcher:dispatchURL('', '', '', object.url)
  end

  -- only one thing had a title, blog, removed for now
  -- in the case of something having a title, need to see if it's running and switch via activate
  -- if (object.title) then
  --   for _, app in pairs(hs.application.runningApplications()) do
  --     if app:name() == object.name then
  --       for _, wins in pairs(app:allWindows()) do
  --         if wins:title() == object.title then
  --           app:activate()
  --
  --           return
  --         end
  --       end
  --     end
  --   end
  -- end

  -- first try to just swap to it, useful for coherence fake apps
  local found = false
  for _, app in pairs(hs.application.runningApplications()) do
    if app:name() == object.app then
      -- handle minimized windows
      local vis = false
      local winCount = 0
      for _, win in pairs(app:allWindows()) do
        if not win:isMinimized() then
          vis = true
        end
        winCount = winCount + 1
      end
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
   return
  end

  hs.application.launchOrFocus(appName)

  -- check display, turned off, not smart enough
  -- if (object.display and screenCount == 2) then
  --   local win = hs.window.focusedWindow()
  --   local winScreen = win:screen():name()
  --   local builtinScreen = hs.screen.find('Built%-in'):name()
  --   if (object.display == 2 and winScreen ~= builtinScreen) then
  --     ext.app.moveToDisplay(2)
  --     ext.moveTimer = hs.timer.doAfter(0.1, function()
  --       ext.app.setGrid(object.size)
  --     end)
  --
  --     return
  --   elseif (object.display == 1 and winScreen == builtinScreen) then
  --     ext.app.moveToDisplay(1)
  --     ext.moveTimer = hs.timer.doAfter(0.1, function()
  --       ext.app.setGrid(object.size)
  --     end)
  --
  --     return
  --   end
  -- end
end

function ext.app.showBundleID()
  local frontmostApp = hs.application.frontmostApplication()
  hs.alert.show(frontmostApp:title())
end

function ext.app.showScreenID()
  local ms = hs.screen.primaryScreen()
  hs.alert.show(ms:name())
end

function ext.app.showInfo()
  local win = hs.window.focusedWindow()
  local currentScreen = win:screen()
  -- 'Built-in Retina Display'
  -- 0.0, 0.0, 1792.0, 1120.0
  hs.alert.show(currentScreen:fullFrame())
  hs.alert.show(currentScreen:name())
end

hs.hotkey.bind(screen_mapping, 'b', function() ext.app.showInfo() end)

-- Reload Configuration
--- http://www.hammerspoon.org/go/#fancyreload
local function reloadConfig(files)
    doReload = false
    for _, file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
        hs.alert.show("Hammerspoon config loaded")
    end
end

-- https://stackoverflow.com/questions/19326368/iterate-over-lines-including-blank-lines
function magiclines(s)
  if s:sub(-1)~="\n" then s=s.."\n" end
  return s:gmatch("(.-)\n")
end

-- Snip current highlight
hs.hotkey.bind(screen_mapping, 'y', function()
  local win = hs.window.focusedWindow()

  -- get the window title
  local title = win:title()
  -- get the highlighted item
  hs.eventtap.keyStroke('command', 'c')
  local highlight = hs.pasteboard.readString()
  local quote = ""
  for line in magiclines(highlight) do
    quote = quote .. "> " .. line .. "\n"
  end
  -- get the URL
  hs.eventtap.keyStroke('command', 'l')
  hs.eventtap.keyStroke('command', 'c')
  local url = hs.pasteboard.readString()
  --
  local template = string.format([[%s
%s
[%s](%s)]], title, quote, title, url)
  -- format and send to drafts
  -- @todo what to do here?
  hs.urlevent.openURL("drafts://x-callback-url/create?tag=links&text=" .. hs.http.encodeForQuery(template))
  hs.notify.show("Snipped!", "The snippet has been sent to Drafts", "")
end)

-- create a global variable here, otherwise the pathwatcher will get garbage collected!
mwWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Hammerspoon config loaded")
