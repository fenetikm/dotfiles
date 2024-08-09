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

-- predefined layouts
-- Application name, window title or window object or function
-- @todo what about when there are multiple screens available? e.g. ultra left, internal right?
-- local layouts = {
--   {
    -- key = '1', -- blog
    -- internal = {
    --   {"Blog View", nil, "Color LCD", grid.rightHalf, nil, nil},
    --   {"kitty", "blog", "Color LCD", grid.leftHalf, nil, nil}
    -- },
    -- ultra = {
    --   {"Blog View", nil, "LG ULTRAWIDE", grid.rightFocus, nil, nil},
    --   {"kitty", "blog", "LG ULTRAWIDE", grid.leftFocus, nil, nil}
    -- }
--     key = '1',
--     ultra = {
--
--     }
--   }
-- }


function ext.app.applyLayout(layout)
  local log = hs.logger.new('mylog', 'debug')
  local screen = 'internal'
  local ms = hs.screen.primaryScreen()
  if ms:name() == 'LG ULTRAWIDE' then
    screen = 'ultra'
  elseif ms:name() == 'DELL U2715H' then
    screen = 'dell'
  end

  -- hide everything, @fixme
  for key, app in pairs(hs.application.runningApplications()) do
    app:hide()
  end

  -- now show the matches
  for key, app in pairs(hs.application.runningApplications()) do
    local match = false
    local winMatch = false
    for ai, settings in pairs(layout[screen]) do
      if app:name() == settings[1] then
        if settings[2] == nil then
          app:unhide()

          for _, wins in pairs(app:allWindows()) do
            hs.grid.set(wins, layout[screen][ai][4])
          end

          break
        end
        for _, wins in pairs(app:allWindows()) do
          if wins:title() == settings[2] then
            app:unhide()

            for _, wins2 in pairs(app:allWindows()) do
              hs.grid.set(wins2, layout[screen][ai][4])
            end

            winMatch = true
            break
          end
        end

        if winMatch then
          break
        end
      end
    end
  end
end

-- hs.fnutils.each(layouts, function(object)
--   hs.hotkey.bind(hyper_mapping, object.key, function() ext.app.applyLayout(object) end)
-- end)
