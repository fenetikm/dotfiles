# New window mgmt mapping
## Goals
-~~ Ergonomic, easy and logical for both hands (space wins here)~~
- Minimise clashes -- SpaceFN was ok but `space` is too fiddly to work
- Reliable
- _Majority_ of combos are easy to reach

## Mappings v2
Based around `wasd` and F21.

a/d - move window left/right
f - full screen
enter - present @done
r - restart yabai
c - center @done
z - toggle float @done
r - restart yabai @done
x - minimise @done
b - balance @done
1x - change focused space
1x double - shift to that space
w/s - select window to left or right? or maybe make window smaller/larger, yes, do this
q/e? - change space mode? focus / select window to left or right?

for change mode:
- `                    "shell_command": "export PATH=/usr/local/bin:/usr/bin:/opt/homebrew/bin; /bin/zsh ~/.config/yabai/toggle_mode.sh"
`

for focus a direction:
` "shell_command": "export PATH=/usr/local/bin:/usr/bin:/opt/homebrew/bin; yabai -m window --focus west || yabai -m display --focus west"`

Map right option on inbuilt to F21 via karabiner.
Other keyboards use QMK.

## Previous mappings with SpaceFN
things that I want to do regularly:
h/l -     select window (left/right) @done
j/k -     move window left/right @done
j/k -     move window to next display (can we do that with left/right? have seen a script that does) @done
j/k -     move window to next display, working with floats?
g -      center window @done
f -      full screen, or one of a few sizes (cycle) @done
z -      toggle zoomed full screen @done
enter -  send to 6, center, @done
n -      toggle float @done
r -      reload yabai @done
90 -     preset sizes? can just use the full screen sizes then use position
m -      minimise / hide @done
shift or double tap numbers, or qwerty (what about reload though?) - gone with double tap, yes - @done
123456 - change focused space @done
u/i     - change layout / window size (non-float): 1/3,1/2,1/4,2/3,1/4 (cycle)
u/i     - change position (float): 1/3,1/2,1/4,2/3,1/4 (cycle)
a      - autolayout (for floats e.g. side by side)
? -      change position (floated window) (as above) (cycle)
,. -     change width/metrics (on floated window) (1/3, 1/2, 1/4, 2/3 etc.) (cycle)
s -      toggle space mode between stack / bsp... float? is that useful? can't remember last time wanted float mode @done

less often:
- go from stack to split easily, esp. on laptop screen
- change space mode: bsp,stack,float
b - balance - not that useful, replace with layout @done
- send to display (remove, instead left/right or send to space)
- hide all floats (`hide_floats.sh`) `nn`?
- minimise all others

## Going from stack to split
Now:
- change mode
- minimise all others... how?!
- open the one you want with the split

Next?:
- If you have a stack, select the top app
- Then select the next one
- Hit key to switch to split which should show just the top 2 side by side

## Nice to have / gold plating
- when kitty open on a large screen by it self with margins
