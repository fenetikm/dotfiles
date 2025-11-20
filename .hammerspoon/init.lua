-- @todo:
-- https://zzamboni.org/post/my-hammerspoon-configuration-with-commentary/ sendtoomnifocus looks interesting and others

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

local hyper_mapping = { "cmd", "alt", "ctrl", "shift" }

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
  local task = hs.task.new(os.getenv('HOME') .. '/.config/yabai/' .. script_name, nil, args)
  local env = task:environment()
  env['PATH'] = env['PATH'] .. ':' .. G.bin_path
  task:setEnvironment(env)
  task:start()
end

-- todo: handling of windows in other spaces, sometimes doesn't work? maybe when also minimized?
local launchOrFocus = function(appName, details)
  if (details.url) then
    spoon.URLDispatcher.url_patterns = {
      { 'obsidian:', obsidianApp },
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
  { key = "f",      app = "Finder" },
  { key = "s",      app = "Slack" },
  { key = "g",      app = "Google Chrome" },
  { key = "space",  app = "kitty",                             yabai_script = "kitty.sh" },
  { key = "e",      app = "Mail" },
  { key = "p",      url = "obsidian://open?vault=personal" },
  { key = "q",      app = "TablePlus" },
  { key = "n",      app = "Notes" },
  { key = "c",      app = "Calendar" },
  { key = "j",      app = "Jira" },
  { key = "k",      app = "Bitbucket" },
  { key = "o",      app = "Confluence" },
  { key = "r",      app = "Metabase" },
  { key = "return", app = "Omnifocus" },
  { key = "z",      url = "obsidian://open?vault=zettelkasten" },
  { key = "v",      url = "obsidian://open?vault=PC" },
  { key = "m",      app = "Messages" },
  { key = "i",      app = "Music" },
  { key = "b",      app = "BoltAI" },
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

-- get the current url and send to clipboard
hk['u'] = hs.hotkey.bind(hyper_mapping, 'u', function()
  local win = hs.window.focusedWindow()
  local title = win:title()
  local quote = ""

  local elem = hs.uielement.focusedElement()
  local sel = nil
  if elem then
    sel = elem:selectedText()
  end
  if sel == nil then
    -- no selection, check for image URL in clipboard
    local url = hs.pasteboard.readString()
    if url ~= nil and (url:match(".png$") or url:match(".jpe?g$") or url:match(".gif$") or url:match(".webp$")) then
      quote = '![image from ' .. title .. '](' .. url .. ')' .. "\n"
    end
  else
    if sel:sub(-1) ~= "\n" then sel = sel .. "\n" end
    local lines = sel:gmatch("(.-)\n")
    for line in lines do
      quote = quote .. "> " .. line .. "\n"
    end
  end

  hs.eventtap.keyStroke('command', 'l')
  hs.eventtap.keyStroke('command', 'c')
  local url = hs.pasteboard.readString()
  -- deselect
  hs.eventtap.keyStroke({}, 'escape')

  local snip = quote .. '- [' .. title .. '](' .. url .. ')'

  hs.pasteboard.setContents(snip)
  s('Snipped!')
end)

local yabai = function(args, completion)
  local yabai_output = ""
  local yabai_error = ""
  -- Runs in background very fast
  local yabai_task = hs.task.new(G.yabai_path, function(err, stdout, stderr)
    print()
  end, function(task, stdout, stderr)
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

-- set mode, todo: better here, maybe one key and cycle? or a selector
-- also reset transparency stuff after mode change
-- sk['z'] = bindKey('z', function() yabai({'-m', 'space', '--layout', 'bsp'}) end)
-- sk['x'] = bindKey('x', function() yabai({'-m', 'space', '--layout', 'float'}) end)
-- sk['c'] = bindKey('c', function() yabai({'-m', 'space', '--layout', 'stack'}) end)

-- called from karabiner
function smartMinimise()
  local frontmost = hs.application.frontmostApplication()
  local frontmost_windows = frontmost:allWindows()
  if (#frontmost_windows > 1) then
    yabai({ '-m', 'window', '--minimize' })
  else
    frontmost:hide()
  end
end
