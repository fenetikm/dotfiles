-- @todo hide everything except top window
-- @todo center something
-- @todo snap new windows to closest grid
-- @todo allow top half in a third
-- @todo when first opening something, put it in desired place but don't on focus
-- @todo layout method
ext = {
  app = {},
}

hs.loadSpoon("URLDispatcher")

-- keys used to trigger screen management
local mash_screen = {"cmd", "alt", "ctrl"}

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
  focus = '3,1 6x10'
}

local layoutMetrics = {
  leftThird = {x=0, y=0, w=0.333, h=1},
  leftHalf = {x=0, y=0, w=0.5, h=1},
  rightTwoThirds = {x=0.333, y=0, w=0.667, h=1},
  rightHalf = {x=0.5, y=0, w=0.5, h=1},
  middleThird = {x=0.333, y=0, w=0.333, h=1},
  screenshot1 = {x=1280, y=320, w=1280, h=960}
}

-- predefined layouts
-- Application name, window title or window object or function
local layouts = {
  {
    key = '1',
    internal = {
      {"Google Chrome", nil, "Color LCD", layoutMetrics.leftHalf, nil, nil},
      {"kitty", "kitty", "Color LCD", layoutMetrics.rightHalf, nil, nil}
    },
    ultra = {
      {"Google Chrome", nil, "LG ULTRAWIDE", grid.leftThird, nil, nil},
      {"kitty", "kitty", "LG ULTRAWIDE", grid.rightTwoThirds, nil, nil}
    }
  },
  {
    key = '2',
    internal = {
      {"Google Chrome", nil, "Color LCD", layoutMetrics.leftHalf, nil, nil},
      {"kitty", "kitty", "Color LCD", layoutMetrics.rightHalf, nil, nil}
    },
    ultra = {
      {"kitty", "vimwiki", "LG ULTRAWIDE", layoutMetrics.middleThird, nil, nil}
    }
  },
  {
    key = '3',
    internal = {
    },
    ultra = {
      {"kitty", "vimwiki", "LG ULTRAWIDE", layoutMetrics.screenshot1, nil, nil}
    },
    dell = {
      {"kitty", "vimwiki", "DELL U2715H", layoutMetrics.screenshot1, nil, nil}
    }
  },
  {
    key = '4',
    internal = {
    },
    ultra = {
      {"kitty", "vimwiki", "LG ULTRAWIDE", layoutMetrics.leftThird, nil, nil},
      {"Google Chrome", nil, "LG ULTRAWIDE", layoutMetrics.middleThird, nil, nil},
      {"Finder", nil, "LG ULTRAWIDE", layoutMetrics.rightThird, nil, nil}
    },
    dell = {
    }
  }
}

hs.fnutils.each(layouts, function(object)
  hs.hotkey.bind(mash_screen, object.key, function() ext.app.applyLayout(object) end)
end)

-- @todo
-- fill out layouts as above
-- hide everything else
function ext.app.applyLayout(layout)
  local log = hs.logger.new('mylog', 'debug')
  local screen = 'internal'
  local ms = hs.screen.primaryScreen()
  log.i(ms)
  if ms:name() == 'LG ULTRAWIDE' then
    screen = 'ultra'
  elseif ms:name() == 'DELL U2715H' then
    screen = 'dell'
  end
  log.i(screen)
  log.i(layout)

  -- hide non-matching apps
  for key, app in pairs(hs.application.runningApplications()) do
    local appIndex = -1
    local match = false
    local winMatch = false
    -- @todo how to handle apps such as kitty / kitty_2?
    for ai, settings in pairs(layout[screen]) do
      log.i(app:name())
      if app:name() == settings[1] then
        for w, wins in pairs(app:allWindows()) do
          log.i(wins:title())
        end
        match = true
        appIndex = ai
      end
    end
    if match == false then
      app:hide()
    else
      app:unhide()
      for w, wins in pairs(app:allWindows()) do
        hs.grid.set(wins, layout[screen][appIndex][4])
        -- hs.grid.set(w, grid[layout[screen[3]]])
      end
    end
  end

  -- hs.layout.apply(layout[screen])
end

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

local internalDisplay = (function()
  -- Fun fact: this resolution matches both the 13" MacBook Air and the 15"
  -- (Retina) MacBook Pro.
  return hs.screen.find('Built%-in')
end)

hs.hotkey.bind(mash_screen, 'up', chain({
  grid.topHalf,
  grid.topThird,
  grid.topTwoThirds,
}))

hs.hotkey.bind(mash_screen, 'right', chain({
  grid.rightHalf,
  grid.rightThird,
  grid.rightTwoThirds,
}))

hs.hotkey.bind(mash_screen, 'down', chain({
  grid.bottomHalf,
  grid.bottomThird,
  grid.bottomTwoThirds,
}))

hs.hotkey.bind(mash_screen, 'left', chain({
  grid.leftHalf,
  grid.leftThird,
  grid.leftTwoThirds,
}))

hs.hotkey.bind(mash_screen, 'f', chain({
  grid.fullScreen,
  grid.centeredHuge,
  grid.centeredBig,
  grid.focus,
}))

function ext.app.setGrid(key)
  local win = hs.window.focusedWindow()
  hs.grid.set(win, grid[key])
end

function ext.app.setLayout(rect)
  local win = hs.window.focusedWindow()
  win:setFrame(rect)
end

function ext.app.moveToDisplay(displayIndex)
  local displays = hs.screen.allScreens()
  local win = hs.window.focusedWindow()
  -- 2 should always be the builtin
  if (displayIndex == 2 and displays[displayIndex]:name() ~= internalDisplay():name()) then
    displayIndex = 1
  elseif (displayIndex == 1 and displays[displayIndex]:name() == internalDisplay():name()) then
    displayIndex = 2
  end
  win:moveToScreen(displays[displayIndex], false, true);
end

-- 1 row, halves
hs.hotkey.bind(mash_screen, 'q', function() ext.app.setGrid('leftHalf') end)
hs.hotkey.bind(mash_screen, 'w', function() ext.app.setGrid('rightHalf') end)
hs.hotkey.bind(mash_screen, 'e', function() ext.app.setGrid('leftHalf') end)
hs.hotkey.bind(mash_screen, 'r', function() ext.app.setGrid('rightHalf') end)

-- 1 row, thirds
hs.hotkey.bind(mash_screen, 'a', function() ext.app.setGrid('leftThird') end)
hs.hotkey.bind(mash_screen, 's', function() ext.app.setGrid('middleVertical') end)
hs.hotkey.bind(mash_screen, 'd', function() ext.app.setGrid('rightThird') end)

-- 1 row, two thirds
hs.hotkey.bind(mash_screen, 'z', function() ext.app.setGrid('leftTwoThirds') end)
hs.hotkey.bind(mash_screen, 'x', function() ext.app.setGrid('middleTwoThirds') end)
hs.hotkey.bind(mash_screen, 'c', function() ext.app.setGrid('rightTwoThirds') end)

-- hs.hotkey.bind(mash_screen, 'g', function() ext.app.setLayout(layoutMetrics.screenshot1) end)

hs.hotkey.bind(mash_screen, '1', function() ext.app.moveToDisplay(1) end)
hs.hotkey.bind(mash_screen, '2', function() ext.app.moveToDisplay(2) end)

-- global operations
-- hs.hotkey.bind(mash_screen, ';', function() hs.grid.snap(hs.window.focusedWindow()) end)
-- hs.hotkey.bind(mash_screen, "'", function() hs.fnutil.map(hs.window.visibleWindows(), hs.grid.snap) end)

-- hyper key mash
local mash_apps = {"cmd", "alt", "ctrl", "shift"}

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
  { key = "d", app = "Dash" },
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
}, function(object)
    hs.hotkey.bind(mash_apps, object.key, function() ext.app.forceLaunchOrFocus(object.app, object) end)
end)

function appID(app)
  return hs.application.infoForBundlePath(app)['CFBundleIdentifier']
end

-- apps for URL dispatching
local obsidianApp = appID('/Applications/obsidian.app')
local chromeApp = appID('/Applications/Google Chrome.app')

-- map mash+l to lock screen
hs.hotkey.bind(mash_apps, 'l', function() hs.caffeinate.systemSleep() end)

function ext.app.forceLaunchOrFocus(appName, object)
  local log = hs.logger.new('mylog', 'debug')
  local screenCount = #hs.screen.allScreens()

  if (object.url) then
    spoon.URLDispatcher.url_patterns = {
      {'obsidian:', obsidianApp},
      {'https:', chromeApp},
      {'http:', chromeApp}
    }

    spoon.URLDispatcher:dispatchURL('', '', '', object.url)
  end

  -- focus with hammerspoon
  hs.application.launchOrFocus(appName)

  -- check display
  if (object.display and screenCount == 2) then
    local win = hs.window.focusedWindow()
    local winScreen = win:screen():name()
    local builtinScreen = hs.screen.find('Built%-in'):name()
    if (object.display == 2 and winScreen ~= builtinScreen) then
      ext.app.moveToDisplay(2)
      ext.moveTimer = hs.timer.doAfter(0.1, function()
        ext.app.setGrid(object.size)
      end)

      return
    elseif (object.display == 1 and winScreen == builtinScreen) then
      ext.app.moveToDisplay(1)
      ext.moveTimer = hs.timer.doAfter(0.1, function()
        ext.app.setGrid(object.size)
      end)

      return
    end
  end
end

function ext.app.showBundleID()
  local frontmostApp = hs.application.frontmostApplication()
  hs.alert.show(frontmostApp:title())
end

function ext.app.showScreenID()
  local ms = hs.screen.primaryScreen()
  hs.alert.show(ms:name())
end

hs.hotkey.bind(mash_screen, 'b', function() ext.app.showBundleID() end)

-- Reload Configuration
--- http://www.hammerspoon.org/go/#fancyreload
function reloadConfig(files)
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
hs.hotkey.bind(mash_screen, 'y', function()
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

hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Hammerspoon config loaded")
