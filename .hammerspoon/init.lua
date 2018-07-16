

-- hyper key mash
local mash_apps = {"cmd", "alt", "ctrl", "shift"}

-- https://github.com/digitalbase/hammerspoon/blob/master/init.lua
hs.fnutils.each({
  { key = "t", app = "Telegram" },
  { key = "b", app = "Thunderbird" },
  { key = "f", app = "Path Finder" },
  { key = "s", app = "Slack" },
  { key = "g", app = "Google Chrome" },
  { key = "x", app = "Firefox" },
  { key = "space", app = "kitty" },
  { key = "m", app = "Mail" },
  { key = "v", app = "iTerm_2" },
  { key = "d", app = "Dash" },
  { key = "q", app = "Sequel" },
  { key = "n", app = "Notes" },
  { key = "c", app = "Calendar" },
  { key = "w", app = "iTerm" },
  { key = "e", app = "Microsoft Excel" },
  { key = "p", app = "Preview" },
  { key = "1", app = "Messages" },
  { key = "3", app = "activeCollabTimer3" },
  { key = "i", app = "iTunes" },
  { key = "r", app = "Transmit" },
}, function(object)
    hs.hotkey.bind(mash_apps, object.key, function() ext.app.forceLaunchOrFocus(object.app) end)
end)

-- map mash+l to lock screen
hs.hotkey.bind(mash_apps, 'l', function() hs.caffeinate.lockScreen() end)

ext = {
  app = {},
}

function ext.app.forceLaunchOrFocus(appName)
  -- first focus with hammerspoon
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
