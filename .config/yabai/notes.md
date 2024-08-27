# Notes
## Learnings
resizing by some amount
yabai -m window --resize right:20:0
resizing to a ratio, absolutely
yabai -m window --ratio abs:0.6
sticky is across all spaces, but floats
when you drag on a window and split, the dropped window "splits" the region taken by the existing window
toggle zoom-fullscreen means that it stays full screen whilst other things keep bsp-ing
zoom-parent does something similar
if you are on another space, switching to app focuses space that it is on - what happens if windows on different spaces? does that work?
I think it goes to the first one open dependent on the number of the space
When you get one window i.e. `--windows --window` since no array, don't need the `.[]` bit in `jq`
"insert" sets the splitting direction (or optionally whether to stack a dropped window)
"Warping" is doing the actual insert of the selected window.

## References
- [floating window, centred, based on app and title](https://github.com/koekeishiya/yabai/issues/2375)
- [making float windows not stay on top of other windows](yabai -m rule --add app=".*" sub-layer=normal)
- [stackline for visual stack indicators](https://github.com/AdamWagner/stackline)
- [3 columns](https://github.com/koekeishiya/yabai/issues/157)

## Space ideas

## Current uses
- how many layouts do we have for ultrawide:
- 1 browser, 23 kitty
- 1 bitbucket, 1 browser, 1 browser
- 1/2 bitbucket, 1/2 browser
- 1 x, 23 Jira
- 1 x, 23 tableplus
- 1 obsidian, 23 slack video
- 1 x, 23 reports

so layouts are:
- 1 + 23
- 1/2 + 1/2
- 1 + 1 + 1

could we have a browser on left
2/3 on right
next thing that is loaded comes in the middle and triple split

## Work use cases
- developing:
    - browser, kitty 23 or db
- intercom:
    - browser
- code review:
    * bitbucket, browser, browser
- product management:
    * browser, jira 23
    * omnifocus, floated centre or on laptop
- calendar, laptop?
- messages, laptop
- slack (laptop), then:
    * slack video call, floated centre, notes (obsidian) on left
- timesheets:
    * browser
- blogging:
    * browser, kitty

### How to do
(s1)
- developing / general:
    - browser, kitty 23
    - open another browser in middle for testing
    - db... float on kitty? or stack?
(s2)
- intercom/reports:
    - browser, reports 23
(s3)
- code review:
    * bitbucket, browser, browser
- product management:
    * browser, jira 23
    * omnifocus, floated centre or on laptop
- pkm:
    * browser, obsidian, obsidian
(inbuilt - could do something nicer here?)
- calendar, laptop?
- messages, laptop
- mail, laptop
- slack (laptop), then:
    * slack video call, floated centre, notes (obsidian) on left
(s1?)
- timesheets:
    * browser
(s1?)
- blogging:
    * browser, kitty

Also could have spaces on laptop e.g.
1 - is main, kitty, browser
x:
- browser and kitty for blog writing?
2:
- messages could be a split with something

## How to
- Float but not be "on top" forever, also toggle float and it goes back to where it was
- Focus in a direction then across to next display:
`alt - h : yabai -m window --focus west || yabai -m display --focus west`
- on laptop go from stack to bsp / side by side

## Todo?
- when floating, re balance
- shadow on floating ones
- when reloading change all float windows to not force on top
- handle this:
    * send to other display floated
- when slack huddle is activated, and on display 2, make floated and centred
- plugging in screen, space 2 is empty - quickest way to re-setup
- same as above but with other spaces - is that because I have set space 2 to display 2, only?

### Yabai
- Label spaces and displays
- When a new browser window is created, on ultrawide, it should end up in the middle

### Hammerspoon
either modal or non? non is better in general
but modal means that we can do more stuffs
let's try mapping that key to f19, ahh we can't because it isn't completely free (arrow)
other option is to swap with hyper...
double tap hyper to turn on window mode?

modal just for movement stuffs
- select space [1,2,3,...] (also selects display) @done
- Send to space? via modal then [1,2,3,...] @done
- Toggle float [space] @done
- Set size ratio of all windows to 1/23, 1/2, 23/1 [q,w,e], could be a toggle / balanced vs non-balanced
- reload yabai [r] @done
- Change space mode between bsp, stack, float? [asd]?
- Send to display? floated at first (then unfloat if applicable, toggle float) [,.]?
- Balance windows [z]
- Centre (floats if not floated) [c] @done
- Open apps in a particular space? (if we go for that)
- Toggle (cycle) padding on ultrawide [automate? might also want a key so we could have two skinnier windows e.g. for blogging or obsidian] [x]?
- Focus window directions (instead of using hyper+keys?) [hjkl] via modal [m], also swap
- Stack current window [use mouse drop?]
- full screen [f]
- how to change mode per display / space?
- next / previous window in space [fn+n,fn+p]

### Other
- Screen recording 1400x900 [0]
- Small kitty window for creating gifs 700x450 [9]
- Kitty sized for streaming 2512x1413? [8]
- toggle pip? good for... video?
- minimize window
