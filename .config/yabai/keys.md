# New window mgmt mapping
Can also do more chording instead of modifiers?! but how does that work with sequence?!

## Goals
- Ergonomic, easy and logical for both hands (space wins here)
- Not many clashes with programs e.g. Thunderbird with ctrl+shift+command

## Approaches
- Simultaneous -> shell call
- SpaceFN via non-simultaneous -> shell call @yep!
- SpaceFN using firmware -> shell call
- Hammerspoon mode via, say, F19

## To try
- SpaceFN + double tap, vs single tap @done, all good!

## How to do the chaining thing via shell?
set a "last called" file which has the trigger and a timestamp, compare, run next one
have to store the items in the cycle somewhere, another file?
@done

## Mappings
things that I want to do regularly:
hl -     select window (left/right) @done
jk -     move window left/right @done
jk -     move window to next display (can we do that with left/right? have seen a script that does) @done
jk -     move window to next display, working with floats?
g -      center window @done
f -      full screen, or one of a few sizes (cycle) @done
z -      toggle zoomed full screen @done
p -      present (send to 6, center) @done
n -      toggle float @done
r -      reload yabai @done
90 -     preset sizes? can just use the full screen sizes then use position
m -      minimise / hide @done
shift or double tap numbers, or qwerty (what about reload though?) - gone with double tap, yes - @done
123456 - change focused space @done
ui     - change layout / window size (non-float): 1/3,1/2,1/4,2/3,1/4 (cycle)
ui     - change position (float): 1/3,1/2,1/4,2/3,1/4 (cycle)
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
- minimise all others
- open the one you want with the split

## Nice to have / gold plating
- when kitty open on a large screen by it self with margins

## Other
Double tapping (working for now) reference:
- https://github.com/pqrs-org/Karabiner-Elements/issues/2532
- https://agileadam.com/2024/11/double-tap-modifier-hotkeys-in-any-application/
