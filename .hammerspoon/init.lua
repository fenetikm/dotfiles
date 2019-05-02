-- @todo hide everything except top window
-- @todo center something
ext = {
  app = {},
}

-- moom replacement
local mash_screen = {"cmd", "alt", "ctrl"}

-- initial settings
hs.grid.setGrid('12x12') -- allows us to place on quarters, thirds and halves
hs.grid.MARGINX = 20
hs.grid.MARGINY = 20
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
      {"Google Chrome", nil, "LG ULTRAWIDE", layoutMetrics.leftThird, nil, nil},
      {"kitty", "kitty", "LG ULTRAWIDE", layoutMetrics.rightTwoThirds, nil, nil}
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
  local screen = 'internal'
  if internalDisplay() == nil then
    screen = 'ultra'
  end
  local log = hs.logger.new('mylog', 'debug')

  -- hide non-matching apps
  for key, app in pairs(hs.application.runningApplications()) do
    local match = false
    local winMatch = false
    -- @todo how to handle apps such as kitty / kitty_2?
    for _, settings in pairs(layout[screen]) do
      log.i(app:name())
      if app:name() == settings[1] then
        log.i('match')
        for w, wins in pairs(app:allWindows()) do
          log.i(wins:title())
        end
        match = true;
      end
    end
    if match == false then
      log.i('hide')
      -- app:hide()
    else
      log.i('unhide')
      app:unhide()
    end
  end

  hs.layout.apply(layout[screen])
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

internalDisplay = (function()
  -- Fun fact: this resolution matches both the 13" MacBook Air and the 15"
  -- (Retina) MacBook Pro.
  return hs.screen.find('Color LCD')
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
}))

-- bind key to set a specific grid layout
-- internalKey: used on internal display, ultraKey on ultrawide screen
function ext.app.setGrid(internalKey, ultraKey)
  local win = hs.window.focusedWindow()
  local internal = internalDisplay()
  if internal == nil then
    hs.grid.set(win, grid[ultraKey])
  else
    hs.grid.set(win, grid[internalKey])
  end
end

function ext.app.setLayout(rect)
  local win = hs.window.focusedWindow()
  win:setFrame(rect)
end

-- 1 row, halves
hs.hotkey.bind(mash_screen, 'q', function() ext.app.setGrid('leftHalf', 'leftHalf') end)
hs.hotkey.bind(mash_screen, 'w', function() ext.app.setGrid('rightHalf', 'rightHalf') end)

-- 1 row, thirds
hs.hotkey.bind(mash_screen, 'a', function() ext.app.setGrid('leftThird', 'leftThird') end)
hs.hotkey.bind(mash_screen, 's', function() ext.app.setGrid('middleVertical', 'middleVertical') end)
hs.hotkey.bind(mash_screen, 'd', function() ext.app.setGrid('rightThird', 'rightThird') end)

-- 1 row, two thirds
hs.hotkey.bind(mash_screen, 'z', function() ext.app.setGrid('leftTwoThirds', 'leftTwoThirds') end)
hs.hotkey.bind(mash_screen, 'x', function() ext.app.setGrid('middleTwoThirds', 'middleTwoThirds') end)
hs.hotkey.bind(mash_screen, 'c', function() ext.app.setGrid('rightTwoThirds', 'rightTwoThirds') end)

hs.hotkey.bind(mash_screen, 'g', function() ext.app.setLayout(layoutMetrics.screenshot1) end)

-- hyper key mash
local mash_apps = {"cmd", "alt", "ctrl", "shift"}

-- https://github.com/digitalbase/hammerspoon/blob/master/init.lua
hs.fnutils.each({
  { key = "b", app = "Thunderbird" },
  { key = "f", app = "Path Finder" },
  { key = "s", app = "Slack" },
  { key = "g", app = "Google Chrome" },
  { key = "x", app = "Firefox" },
  { key = "space", app = "kitty" },
  { key = "m", app = "Mail" },
  { key = "v", app = "/Users/mjw/.config/kitty/start.sh", windowApp = "kitty", window = "vimwiki" },
  { key = "t", app = "/Users/mjw/.config/kitty/taskw.sh", windowApp = "kitty", window = "taskw" },
  { key = "d", app = "Dash" },
  { key = "q", app = "Sequel" },
  { key = "n", app = "Notes" },
  { key = "c", app = "Calendar" },
  { key = "w", app = "WhatsApp" },
  { key = "e", app = "Microsoft Excel" },
  { key = "p", app = "Preview" },
  { key = "1", app = "Messages" },
  { key = "3", app = "activeCollabTimer3" },
  { key = "i", app = "iTunes" },
}, function(object)
    hs.hotkey.bind(mash_apps, object.key, function() ext.app.forceLaunchOrFocus(object.app, object) end)
end)

-- map mash+l to lock screen
hs.hotkey.bind(mash_apps, 'l', function() hs.caffeinate.systemSleep() end)

function ext.app.forceLaunchOrFocus(appName, object)
  -- if a window is specified then use that to try to focus by first
  if (object.windowApp) then
    for key, app in pairs(hs.application.runningApplications()) do
      if (app:name() == object.windowApp) then
        for w, wins in pairs(app:allWindows()) do
          if (wins:title() == object.window) then
            wins:focus()
            return
          end
        end
      end
    end
  end

  -- focus with hammerspoon
  hs.application.launchOrFocus(appName)

  -- clear timer if exists
  if ext.cache.launchTimer then ext.cache.launchTimer:stop() end

  -- wait 500ms for window to appear and try hard to show the window
  ext.cache.launchTimer = hs.timer.doAfter(0.5, function()
    local frontmostApp     = hs.application.frontmostApplication()
    local frontmostWindows = hs.fnutils.filter(frontmostApp:allWindows(), function(win) return win:isStandard() end)

    -- break if this app is not frontmost (when/why?)
    if frontmostApp:title() ~= appName then
      print('Expected app in front: ' .. appName .. ' got: ' .. frontmostApp:title())
      return
    end

    if #frontmostWindows == 0 then
      -- check if there's app name in window menu (Calendar, Messages, etc...)
      if frontmostApp:findMenuItem({ 'Window', appName }) then
        -- select it, usually moves to space with this window
        frontmostApp:selectMenuItem({ 'Window', appName })
      else
        -- otherwise send cmd-n to create new window
        hs.eventtap.keyStroke({ 'cmd' }, 'n')
      end
    end
  end)
end

function ext.app.showBundleID()
  -- local frontmostApp = hs.application.frontmostApplication()
  -- local frontmostApp = hs.screen:name()
  local ms = hs.screen.primaryScreen()
  hs.alert.show(ms:name())
end

-- hs.hotkey.bind(mash_screen, 'b', function() ext.app.showBundleID() end)
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

hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Hammerspoon config loaded")
