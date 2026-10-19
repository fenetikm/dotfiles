#!/usr/bin/env bash
# mdview: render markdown to an image (pandoc -> typst -> png) and show it in kitty.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: mdview [options] FILE.md...

Options:
  -w COLS     max render width in terminal columns (default: fill the pane)
  -t THEME    dark | light (default: dark, or $MDVIEW_THEME)
  -s SCALE    text scale relative to terminal font (default: 1.0, or $MDVIEW_SCALE)
  -o FILE     write the full PNG to FILE instead of displaying it
  -p          always use the pager (default: only when the doc is taller than the pane)
  -i          always print inline (stays in scrollback, but uses kitty image memory)
  -n          ignore the cache and re-render
  -d          print debug info (sizes, cache key, timings)
  -C          clear the cache and exit
  -h          show this help
EOF
}

MAX_COLS=297
MAX_PAGE_PT=${MDVIEW_MAX_PAGE_PT:-760} # widest page before scaling up instead
MAX_UPSCALE=1.4
THEME=${MDVIEW_THEME:-dark}
SCALE=${MDVIEW_SCALE:-1.0}
OUT=""
NO_CACHE=0
MODE=auto
DEBUG=0
CACHE_ROOT="${XDG_CACHE_HOME:-$HOME/.cache}/mdview"
TILE_ROWS=50 # placeholders can address at most 297 rows/cols per image

while getopts "w:t:s:o:ndCpih" opt; do
  case $opt in
    w) MAX_COLS=$OPTARG ;;
    t) THEME=$OPTARG ;;
    s) SCALE=$OPTARG ;;
    o) OUT=$OPTARG ;;
    n) NO_CACHE=1 ;;
    p) MODE=pager ;;
    i) MODE=inline ;;
    d) DEBUG=1 ;;
    C) rm -rf "$CACHE_ROOT"; echo "cleared $CACHE_ROOT"; exit 0 ;;
    h) usage; exit 0 ;;
    *) usage >&2; exit 2 ;;
  esac
done
shift $((OPTIND - 1))
[[ $# -ge 1 ]] || { usage >&2; exit 2; }

for cmd in pandoc typst magick kitty; do
  command -v "$cmd" >/dev/null || { echo "mdview: missing dependency: $cmd" >&2; exit 1; }
done

debug() { [[ $DEBUG == 1 ]] && echo "mdview: $*" >&2 || true; }

case $THEME in
  dark)  BG="#1e1e2e" FG="#cdd6f4" MUTED="#7f849c" ACCENT="#89b4fa" LINK="#f5c2e7" CODE_BG="#313244" RAW_THEME=dark.tmTheme ;;
  light) BG="#ffffff" FG="#24292f" MUTED="#6e7781" ACCENT="#0550ae" LINK="#8250df" CODE_BG="#f3f4f6" RAW_THEME= ;;
  *) echo "mdview: unknown theme: $THEME" >&2; exit 2 ;;
esac

# --- terminal geometry -------------------------------------------------------
# Cell size in pixels and available columns. tmux knows the client's cell size;
# outside tmux ask kitty for the window size and divide by the grid.
if [[ -n ${TMUX:-} ]]; then
  read -r PANE_COLS PANE_ROWS CELL_W CELL_H < <(tmux display -p '#{pane_width} #{pane_height} #{client_cell_width} #{client_cell_height}')
else
  PANE_COLS=$(tput cols)
  PANE_ROWS=$(tput lines)
  if size=$(kitty +kitten icat --print-window-size 2>/dev/null); then
    CELL_W=$(( ${size%x*} / PANE_COLS ))
    CELL_H=$(( ${size#*x} / $(tput lines) ))
  else
    CELL_W=10 CELL_H=20
  fi
fi
[[ ${CELL_W:-0} -gt 0 && ${CELL_H:-0} -gt 0 ]] || { CELL_W=10 CELL_H=20; }

COLS=$(( PANE_COLS < MAX_COLS ? PANE_COLS : MAX_COLS ))
(( COLS <= 297 )) || COLS=297
# Base ppi makes 11pt body text roughly the size of the terminal font. Fill the
# available width, but past MAX_PAGE_PT (a comfortable line length) scale the
# render up instead of making lines longer; past MAX_UPSCALE, stop short of
# the full width rather than making the text huge.
read -r PPI COLS < <(awk -v h="$CELL_H" -v s="$SCALE" -v cols="$COLS" -v cw="$CELL_W" \
  -v measure="$MAX_PAGE_PT" -v up="$MAX_UPSCALE" 'BEGIN {
    base = h * 0.72 * 72 / 11 * s
    ppi = cols * cw * 72 / measure
    if (ppi <= base) { ppi = base }
    else if (ppi > base * up) { ppi = base * up; cols = int(measure * ppi / 72 / cw) }
    printf "%.2f %d\n", ppi, cols
  }')
TARGET_PX=$(( COLS * CELL_W ))
PAGE_PT=$(awk -v px="$TARGET_PX" -v ppi="$PPI" 'BEGIN { printf "%.3f", px * 72 / ppi }')
debug "pane=${PANE_COLS}cols cell=${CELL_W}x${CELL_H}px cols=$COLS target=${TARGET_PX}px ppi=$PPI page=${PAGE_PT}pt"

# --- assets ------------------------------------------------------------------
ASSETS="$CACHE_ROOT/assets"
mkdir -p "$ASSETS"

cat >"$ASSETS/template.typ" <<'EOF'
#let divider() = line(length: 100%, stroke: 0.5pt + rgb("$muted$"))
#let horizontalRule = divider()

$if(raw-theme)$
#set raw(theme: "$raw-theme$")
$endif$

#set page(width: $page-width$pt, height: auto, margin: (x: 22pt, y: 18pt), fill: rgb("$bg$"))
#set text(font: ("SF Pro Text", "Helvetica Neue", "Apple Symbols", "Menlo", "Apple Color Emoji"), size: 11pt, fill: rgb("$fg$"))
#set par(leading: 0.7em, spacing: 1.2em)
#set list(indent: 0.4em, body-indent: 0.5em)
#set enum(indent: 0.4em, body-indent: 0.5em)
#set terms(hanging-indent: 1.5em)

#show heading: set text(fill: rgb("$accent$"), font: ("SF Pro Display", "Helvetica Neue"), weight: "semibold")
#show heading: set block(above: 1.4em, below: 0.8em)
#show heading.where(level: 1): it => {
  set text(size: 20pt)
  it
  v(-0.5em)
  line(length: 100%, stroke: 0.5pt + rgb("$muted$"))
}
#show heading.where(level: 2): set text(size: 15pt)
#show heading.where(level: 3): set text(size: 12.5pt)
#show heading.where(level: 4): set text(size: 11pt)

#show raw: set text(font: ("Menlo", "DejaVu Sans Mono"), size: 9.5pt)
#show raw.where(block: false): box.with(fill: rgb("$code-bg$"), inset: (x: 3pt), outset: (y: 3pt), radius: 2pt)
#show raw.where(block: true): block.with(fill: rgb("$code-bg$"), inset: 10pt, radius: 4pt, width: 100%)

#show link: set text(fill: rgb("$link$"))
#show quote.where(block: true): it => block(
  stroke: (left: 2pt + rgb("$accent$")),
  inset: (left: 10pt, y: 4pt),
  text(fill: rgb("$muted$"), it.body),
)

#set table(stroke: 0.5pt + rgb("$muted$"), inset: 6pt)
#show table.cell.where(y: 0): set text(weight: "bold")
#show figure: set block(breakable: true)
#show figure.where(kind: table): set align(left)
#show figure.caption: set text(fill: rgb("$muted$"), size: 9.5pt)
#set image(fit: "contain")

$if(title)$
#heading(level: 1)[$title$]
$endif$

$body$
EOF

# Lua filter: render mermaid diagrams, make relative image paths absolute (the
# .typ file lives in the cache), swap remote or missing images for their alt
# text since typst can't fetch, and tidy up raw HTML.
cat >"$ASSETS/filter.lua" <<'EOF'
local function urldecode(s)
  return (s:gsub("%%(%x%x)", function(h) return string.char(tonumber(h, 16)) end))
end

local html_tags = {}
for t in ([[a abbr address article aside b blockquote body br center code dd del details div dl dt
  em figcaption figure font footer h1 h2 h3 h4 h5 h6 head header hr html i iframe img ins kbd li
  main mark nav ol p picture pre s section small source span strong sub summary sup table tbody td
  tfoot th thead tr u ul video]]):gmatch("%S+") do html_tags[t] = true end

local function meta(doc, key)
  return doc.meta[key] and pandoc.utils.stringify(doc.meta[key]) or ""
end

local function exists(path)
  local f = io.open(path, "rb")
  if f then f:close() end
  return f ~= nil
end

local function read(path)
  local f = io.open(path, "rb")
  if not f then return "" end
  local s = f:read("a")
  f:close()
  return s
end

local function write(path, s)
  local f = assert(io.open(path, "wb"))
  f:write(s)
  f:close()
end

local function png_width(path)
  local b = read(path):sub(17, 20)
  if #b < 4 then return nil end
  return ((b:byte(1) * 256 + b:byte(2)) * 256 + b:byte(3)) * 256 + b:byte(4)
end

-- Run a command with stderr folded into stdout; returns ok, output.
local function run(cmd, args)
  local argv = { "-c", 'exec "$0" "$@" 2>&1', cmd }
  for _, a in ipairs(args) do argv[#argv + 1] = a end
  local ok, res = pcall(pandoc.pipe, "sh", argv, "")
  if ok then return true, res end
  return false, type(res) == "table" and (res.output or tostring(res)) or tostring(res)
end

local function mermaid_error(out)
  local first, expecting
  for line in out:gmatch("[^\n]+") do
    line = line:gsub("^%s+", "")
    if not first and line:match("[Ee]rror") then first = line end
    if not expecting and line:match("^Expecting") then expecting = line end
  end
  return (first or "render failed") .. (expecting and (" " .. expecting) or "")
end

-- Render ```mermaid blocks to PNGs (cached by diagram + theme) via mmdc. Uncached
-- diagrams go through one mmdc call so Chrome only starts once; if that fails,
-- fall back to one call per diagram so a single bad diagram doesn't sink the rest.
local SCALE = 3
local function render_mermaid(doc)
  local cache = meta(doc, "mdview-mermaid-cache")
  local config = meta(doc, "mdview-mermaid-config")
  local puppeteer = meta(doc, "mdview-puppeteer-config")
  if cache == "" then return doc end
  pandoc.system.make_directory(cache, true)
  local config_hash = pandoc.sha1(read(config) .. read(puppeteer) .. SCALE)

  local function png_for(code) return pandoc.path.join({ cache, pandoc.sha1(config_hash .. code) .. ".png" }) end
  local function err_for(code) return (png_for(code):gsub("%.png$", ".err")) end
  local function mmdc_args(input, output)
    local args = { "-i", input, "-o", output, "-c", config, "-b", "transparent", "-s", tostring(SCALE), "-e", "png", "-q" }
    if puppeteer ~= "" then table.insert(args, "-p"); table.insert(args, puppeteer) end
    return args
  end

  local todo, seen = {}, {}
  doc:walk({
    CodeBlock = function(cb)
      if cb.classes[1] == "mermaid" and not seen[cb.text]
        and not exists(png_for(cb.text)) and not exists(err_for(cb.text)) then
        seen[cb.text] = true
        todo[#todo + 1] = cb.text
      end
    end,
  })

  if #todo > 0 then
    pandoc.system.with_temporary_directory(cache, "batch", function(tmp)
      local parts = {}
      for _, code in ipairs(todo) do parts[#parts + 1] = "```mermaid\n" .. code .. "\n```\n" end
      local input = pandoc.path.join({ tmp, "in.md" })
      write(input, table.concat(parts, "\n"))
      local ok = run("mmdc", mmdc_args(input, pandoc.path.join({ tmp, "out.md" })))
      for i, code in ipairs(todo) do
        local out = pandoc.path.join({ tmp, "out-" .. i .. ".png" })
        if ok and exists(out) then
          os.rename(out, png_for(code))
        else
          local single = pandoc.path.join({ tmp, i .. ".mmd" })
          write(single, code)
          local ok1, output = run("mmdc", mmdc_args(single, png_for(code)))
          if not ok1 then write(err_for(code), mermaid_error(output)) end
        end
      end
    end)
  end

  return doc:walk({
    CodeBlock = function(cb)
      if cb.classes[1] ~= "mermaid" then return nil end
      local png = png_for(cb.text)
      local width = exists(png) and png_width(png)
      if not width then
        local err = read(err_for(cb.text))
        local note = pandoc.Para({ pandoc.Emph({ pandoc.Str("[mermaid: " .. (err ~= "" and err or "render failed") .. "]") }) })
        return { note, cb }
      end
      -- mmdc pixels are CSS px * SCALE; 1 CSS px = 0.75pt. Shrink to fit if too wide.
      return pandoc.RawBlock("typst", string.format(
        '#align(center, layout(size => image("%s", width: calc.min(%.2fpt, size.width))))',
        png, width / SCALE * 0.75))
    end,
  })
end

function Pandoc(doc)
  local dir = meta(doc, "mdview-dir")
  doc = render_mermaid(doc)
  return doc:walk({
    Image = function(img)
      local placeholder = pandoc.Emph({ pandoc.Str("[image: " .. pandoc.utils.stringify(img.caption) .. "]") })
      if img.src:match("^%a[%w+.-]*:") then return placeholder end
      local src = urldecode(img.src)
      if not pandoc.path.is_absolute(src) then src = pandoc.path.join({ dir, src }) end
      local f = io.open(src, "r")
      if not f then return placeholder end
      f:close()
      img.src = src
      return img
    end,
    -- Typst can't render HTML. Keep inline tags as literal text (notes often
    -- use them for keys like <c-n>), drop comments and block-level tags.
    RawInline = function(el)
      if el.format ~= "html" then return nil end
      if el.text:match("^<!%-%-") then return {} end
      if el.text:match("^<br%s*/?>$") then return pandoc.LineBreak() end
      local tag = el.text:match("^</?([%w-]+)")
      if tag and html_tags[tag:lower()] then return {} end
      return pandoc.Str(el.text)
    end,
    RawBlock = function(el)
      if el.format ~= "html" then return nil end
      local tag = el.text:match("^</?([%w-]+)")
      if not tag or html_tags[tag:lower()] then return {} end
      return pandoc.Plain({ pandoc.Str(el.text) })
    end,
  })
end
EOF

# Code highlighting for the dark theme (Catppuccin Mocha); light uses typst's default.
tm_rule() {
  printf '<dict><key>scope</key><string>%s</string><key>settings</key><dict><key>foreground</key><string>%s</string>%s</dict></dict>\n' "$@"
}
{
  cat <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict><key>name</key><string>mdview-dark</string><key>settings</key><array>
<dict><key>settings</key><dict><key>foreground</key><string>#cdd6f4</string><key>background</key><string>#313244</string></dict></dict>
EOF
  tm_rule "comment" "#7f849c" "<key>fontStyle</key><string>italic</string>"
  tm_rule "string, markup.raw" "#a6e3a1" ""
  tm_rule "constant.numeric, constant.language, constant.character" "#fab387" ""
  tm_rule "keyword, storage, keyword.control" "#cba6f7" ""
  tm_rule "keyword.operator, punctuation.separator, punctuation.accessor" "#94e2d5" ""
  tm_rule "entity.name.function, support.function, meta.function-call" "#89b4fa" ""
  tm_rule "entity.name.type, entity.name.class, support.type, support.class, storage.type" "#f9e2af" ""
  tm_rule "variable.parameter" "#eba0ac" ""
  tm_rule "entity.name.tag, markup.heading" "#89b4fa" ""
  tm_rule "entity.other.attribute-name, support.type.property-name" "#f9e2af" ""
  tm_rule "markup.inserted" "#a6e3a1" ""
  tm_rule "markup.deleted" "#f38ba8" ""
  echo '</array></dict></plist>'
} >"$ASSETS/dark.tmTheme"

# Mermaid diagrams (optional, needs mmdc): themed to match the page. Point
# puppeteer at the system Chrome so it doesn't need its own Chromium download.
MERMAID_ARGS=()
if command -v mmdc >/dev/null; then
  if [[ $THEME == dark ]]; then
    cat >"$ASSETS/mermaid-dark.json" <<'EOF'
{"theme": "base", "themeVariables": {"darkMode": true, "background": "#1e1e2e",
 "primaryColor": "#313244", "primaryTextColor": "#cdd6f4", "primaryBorderColor": "#89b4fa",
 "secondaryColor": "#45475a", "tertiaryColor": "#181825", "lineColor": "#7f849c",
 "textColor": "#cdd6f4", "edgeLabelBackground": "#1e1e2e", "noteBkgColor": "#45475a",
 "noteTextColor": "#cdd6f4", "fontFamily": "SF Pro Text, Helvetica Neue, sans-serif"}}
EOF
  else
    cat >"$ASSETS/mermaid-light.json" <<'EOF'
{"theme": "default", "themeVariables": {"fontFamily": "SF Pro Text, Helvetica Neue, sans-serif"}}
EOF
  fi
  MERMAID_ARGS=(-M mdview-mermaid-cache="$CACHE_ROOT/mermaid" -M mdview-mermaid-config="$ASSETS/mermaid-$THEME.json")
  chrome="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
  if [[ -x $chrome ]]; then
    printf '{"executablePath": "%s", "headless": "shell"}\n' "$chrome" >"$ASSETS/puppeteer.json"
    MERMAID_ARGS+=(-M mdview-puppeteer-config="$ASSETS/puppeteer.json")
  fi
fi

# Pager: draws kitty unicode placeholder cells itself so it can show any row
# slice of the tiles. Only tiles near the viewport are kept in kitty (re-sent
# when they come back into range), so memory stays bounded however long the doc.
cat >"$ASSETS/pager.py" <<'EOF'
import argparse, base64, hashlib, os, re, select, signal, shutil, sys, termios, tty

DIACRITICS = [chr(int(h, 16)) for h in """
0305 030D 030E 0310 0312 033D 033E 033F 0346 034A 034B 034C 0350 0351 0352 0357 035B 0363 0364
0365 0366 0367 0368 0369 036A 036B 036C 036D 036E 036F 0483 0484 0485 0486 0487 0592 0593 0594
0595 0597 0598 0599 059C 059D 059E 059F 05A0 05A1 05A8 05A9 05AB 05AC 05AF 05C4 0610 0611 0612
0613 0614 0615 0616 0617 0657 0658 0659 065A 065B 065D 065E 06D6 06D7 06D8 06D9 06DA 06DB 06DC
06DF 06E0 06E1 06E2 06E4 06E7 06E8 06EB 06EC 0730 0732 0733 0735 0736 073A 073D 073F 0740 0741
0743 0745 0747 0749 074A 07EB 07EC 07ED 07EE 07EF 07F0 07F1 07F3 0816 0817 0818 0819 081B 081C
081D 081E 081F 0820 0821 0822 0823 0825 0826 0827 0829 082A 082B 082C 082D 0951 0953 0954 0F82
0F83 0F86 0F87 135D 135E 135F 17DD 193A 1A17 1A75 1A76 1A77 1A78 1A79 1A7A 1A7B 1A7C 1B6B 1B6D
1B6E 1B6F 1B70 1B71 1B72 1B73 1CD0 1CD1 1CD2 1CDA 1CDB 1CE0 1DC0 1DC1 1DC3 1DC4 1DC5 1DC6 1DC7
1DC8 1DC9 1DCB 1DCC 1DD1 1DD2 1DD3 1DD4 1DD5 1DD6 1DD7 1DD8 1DD9 1DDA 1DDB 1DDC 1DDD 1DDE 1DDF
1DE0 1DE1 1DE2 1DE3 1DE4 1DE5 1DE6 1DFE 20D0 20D1 20D4 20D5 20D6 20D7 20DB 20DC 20E1 20E7 20E9
20F0 2CEF 2CF0 2CF1 2DE0 2DE1 2DE2 2DE3 2DE4 2DE5 2DE6 2DE7 2DE8 2DE9 2DEA 2DEB 2DEC 2DED 2DEE
2DEF 2DF0 2DF1 2DF2 2DF3 2DF4 2DF5 2DF6 2DF7 2DF8 2DF9 2DFA 2DFB 2DFC 2DFD 2DFE 2DFF A66F A67C
A67D A6F0 A6F1 A8E0 A8E1 A8E2 A8E3 A8E4 A8E5 A8E6 A8E7 A8E8 A8E9 A8EA A8EB A8EC A8ED A8EE A8EF
A8F0 A8F1 AAB0 AAB2 AAB3 AAB7 AAB8 AABE AABF AAC1 FE20 FE21 FE22 FE23 FE24 FE25 FE26 10A0F
10A38 1D185 1D186 1D187 1D188 1D189 1D1AA 1D1AB 1D1AC 1D1AD 1D242 1D243 1D244
""".split()]
PLACEHOLDER = "\U0010EEEE"
IN_TMUX = bool(os.environ.get("TMUX"))
HELP = "q quit  j/k line  space/b page  d/u half  g/G ends  r reload"


def gfx(control, payload=""):
    seq = "\x1b_G" + control + (";" + payload if payload else "") + "\x1b\\"
    if IN_TMUX:
        seq = "\x1bPtmux;" + seq.replace("\x1b", "\x1b\x1b") + "\x1b\\"
    return seq


def png_height(path):
    with open(path, "rb") as f:
        return int.from_bytes(f.read(24)[20:24], "big")


class Pager:
    def __init__(self, tiles, cols, cell_h, title):
        self.tiles, self.cols, self.title = tiles, cols, title
        self.tile_rows = [-(-png_height(t) // cell_h) for t in tiles]
        self.starts = [sum(self.tile_rows[:i]) for i in range(len(tiles))]
        self.total = sum(self.tile_rows)
        # Stable 24-bit ids (the placeholder's foreground colour carries the id).
        self.ids, used = [], set()
        for t in tiles:
            i = int(hashlib.sha1(t.encode()).hexdigest()[:6], 16) or 1
            while i in used:
                i = i % 0xFFFFFF + 1
            used.add(i)
            self.ids.append(i)
        self.loaded = set()
        self.top = 0
        self.resized = True

    def size(self):
        sz = shutil.get_terminal_size()
        return sz.columns, max(sz.lines - 1, 1)

    def tile_at(self, y):
        for k in range(len(self.tiles) - 1, -1, -1):
            if y >= self.starts[k]:
                return k, y - self.starts[k]
        return 0, y

    def sync_images(self, height):
        lo, hi = self.top - height, self.top + 2 * height
        out = []
        for k, t in enumerate(self.tiles):
            want = self.starts[k] < hi and self.starts[k] + self.tile_rows[k] > lo
            if want and k not in self.loaded:
                out.append(gfx("a=T,U=1,f=100,t=f,q=2,i=%d,c=%d,r=%d" % (self.ids[k], self.cols, self.tile_rows[k]),
                               base64.b64encode(t.encode()).decode()))
                self.loaded.add(k)
            elif not want and k in self.loaded:
                out.append(gfx("a=d,d=I,q=2,i=%d" % self.ids[k]))
                self.loaded.discard(k)
        return "".join(out)

    def unload_all(self):
        out = "".join(gfx("a=d,d=I,q=2,i=%d" % self.ids[k]) for k in self.loaded)
        self.loaded.clear()
        return out

    def draw(self):
        width, height = self.size()
        self.top = max(0, min(self.top, self.total - height))
        out = [self.sync_images(height)]
        ncols = min(self.cols, width)
        for s in range(height):
            out.append("\x1b[%d;1H\x1b[2K" % (s + 1))  # clear first: EL after a full row eats the last cell
            y = self.top + s
            if y < self.total:
                k, r = self.tile_at(y)
                i = self.ids[k]
                out.append("\x1b[38;2;%d;%d;%dm" % (i >> 16, (i >> 8) & 255, i & 255))
                out.append("".join(PLACEHOLDER + DIACRITICS[r] + DIACRITICS[c] for c in range(ncols)))
                out.append("\x1b[39m")
        pct = 100 if self.total <= height else round(100 * (self.top + height) / self.total)
        status = " %s  %d%%  %s " % (self.title, min(pct, 100), HELP)
        out.append("\x1b[%d;1H\x1b[7m%s\x1b[0m\x1b[K" % (height + 1, status[:width]))
        os.write(1, "".join(out).encode())

    def handle(self, key, height):
        page, half = max(height - 2, 1), max(height // 2, 1)
        m = re.match(r"\x1b\[<(\d+);\d+;\d+[Mm]", key)
        if m:
            button = int(m.group(1))
            return {64: -3, 65: 3}.get(button, 0)
        moves = {
            "j": 1, "\x1b[B": 1, "\x1bOB": 1, "\r": 1, "\n": 1, "e": 1, "\x05": 1,
            "k": -1, "\x1b[A": -1, "\x1bOA": -1, "y": -1, "\x19": -1,
            " ": page, "f": page, "\x1b[6~": page, "\x06": page,
            "b": -page, "\x1b[5~": -page, "\x02": -page,
            "d": half, "\x04": half, "u": -half, "\x15": -half,
        }
        if key in moves:
            return moves[key]
        if key in ("g", "<", "\x1b[H", "\x1b[1~", "\x1bOH"):
            return -self.total
        if key in ("G", ">", "\x1b[F", "\x1b[4~", "\x1bOF"):
            return self.total
        if key == "r":
            os.write(1, self.unload_all().encode())
            return 0
        if key in ("q", "Q", "\x03", "\x1b"):
            raise SystemExit
        return 0

    def run(self):
        fd = sys.stdin.fileno()
        saved = termios.tcgetattr(fd)
        signal.signal(signal.SIGWINCH, lambda *_: setattr(self, "resized", True))
        signal.signal(signal.SIGTERM, lambda *_: sys.exit(0))
        tokens = re.compile(r"\x1b\[<\d+;\d+;\d+[Mm]|\x1b\[[0-9;]*[A-Za-z~]|\x1bO[A-Z]|.", re.S)
        try:
            tty.setraw(fd)
            os.write(1, b"\x1b[?1049h\x1b[?25l\x1b[?1000h\x1b[?1006h\x1b[2J")
            while True:
                if self.resized:
                    self.resized = False
                    self.draw()
                ready, _, _ = select.select([fd], [], [], 0.2)
                if not ready:
                    continue
                data = os.read(fd, 4096).decode("utf-8", "replace")
                _, height = self.size()
                delta = sum(self.handle(t, height) for t in tokens.findall(data))
                self.top += delta
                self.draw()
        except SystemExit:
            pass
        finally:
            os.write(1, (self.unload_all() + "\x1b[?1006l\x1b[?1000l\x1b[?25h\x1b[?1049l").encode())
            termios.tcsetattr(fd, termios.TCSADRAIN, saved)


def main():
    p = argparse.ArgumentParser()
    p.add_argument("--cols", type=int, required=True)
    p.add_argument("--cell-h", type=int, required=True)
    p.add_argument("--title", default="")
    p.add_argument("tiles", nargs="+")
    a = p.parse_args()
    Pager(a.tiles, a.cols, a.cell_h, a.title).run()


main()
EOF

# --- render ------------------------------------------------------------------
render() {
  local md=$1 dir key work
  dir=$(cd "$(dirname "$md")" && pwd)
  key=$( { cat "$md"; cat "$0"; echo "$THEME $COLS $CELL_W $CELL_H $PPI"; typst --version; pandoc --version | head -1; } \
    | shasum -a 256 | cut -c1-16)
  work="$CACHE_ROOT/$key"
  debug "$md -> $work"

  if [[ $NO_CACHE == 0 && -f $work/full.png ]]; then
    debug "cache hit"
    RESULT=$work
    return
  fi

  rm -rf "$work"
  mkdir -p "$work"
  local t0=$SECONDS
  pandoc "$md" \
    -f gfm+yaml_metadata_block+wikilinks_title_after_pipe+tex_math_dollars \
    -t typst -s --template "$ASSETS/template.typ" \
    --lua-filter "$ASSETS/filter.lua" \
    --syntax-highlighting=idiomatic \
    ${RAW_THEME:+-V raw-theme="$ASSETS/$RAW_THEME"} \
    -M mdview-dir="$dir" \
    ${MERMAID_ARGS[@]+"${MERMAID_ARGS[@]}"} \
    -V page-width="$PAGE_PT" -V bg="$BG" -V fg="$FG" -V muted="$MUTED" \
    -V accent="$ACCENT" -V link="$LINK" -V code-bg="$CODE_BG" \
    -o "$work/doc.typ"
  # GitHub-style left-aligned tables (pandoc hard-codes align(center))
  perl -pi -e 's/align\(center\)\[#table\(/align(left)[#table(/' "$work/doc.typ"
  # height: auto means one page, unless the doc has explicit page breaks
  typst compile --root / --ppi "$PPI" "$work/doc.typ" "$work/page-{0p}.png" 2>&1 \
    | grep -v '^$' >&2 || true
  local pages=("$work"/page-*.png)
  [[ -f ${pages[0]} ]] || { echo "mdview: typst failed for $md (see $work/doc.typ)" >&2; return 1; }
  if [[ ${#pages[@]} -gt 1 ]]; then
    magick "${pages[@]}" -append "$work/full.png"
  else
    mv "${pages[0]}" "$work/full.png"
  fi
  rm -f "$work"/page-*.png

  # Pad to a whole number of cells, then cut into tiles of TILE_ROWS cells, so
  # every tile maps exactly onto its placeholder grid and they stack seamlessly.
  local h
  h=$(magick identify -format '%h' "$work/full.png")
  magick "$work/full.png" -background "$BG" -gravity north \
    -extent "${TARGET_PX}x$(( (h + CELL_H - 1) / CELL_H * CELL_H ))" \
    -crop "x$(( TILE_ROWS * CELL_H ))" +repage "$work/tile-%03d.png"
  debug "rendered in $(( SECONDS - t0 ))s"
  RESULT=$work
}

show() {
  local work=$1 md=$2 rows tiles=("$1"/tile-*.png)
  rows=$(( $(magick identify -format '%h' "$work/full.png") / CELL_H ))
  if [[ $MODE == pager || ( $MODE == auto && $rows -ge $PANE_ROWS ) ]]; then
    python3 "$ASSETS/pager.py" --cols "$COLS" --cell-h "$CELL_H" --title "$(basename "$md")" "${tiles[@]}"
  else
    show_inline "$work"
  fi
}

show_inline() {
  local work=$1 tile
  local args=(--align left)
  [[ -n ${TMUX:-} ]] && args+=(--unicode-placeholder)
  # Kitty caps image storage (320 MiB) and evicts the least recently displayed
  # images; under tmux it never learns that old output scrolled away, so every
  # view adds up. A stable id per tile makes re-viewing replace, not accumulate.
  local id
  for tile in "$work"/tile-*.png; do
    id=$(( 0x$(printf '%s' "$tile" | shasum | cut -c1-8) ))
    (( id == 0 )) && id=1
    kitty +kitten icat "${args[@]}" --image-id "$id" "$tile"
  done
}

for md in "$@"; do
  [[ -f $md ]] || { echo "mdview: no such file: $md" >&2; exit 1; }
  render "$md"
  if [[ -n $OUT ]]; then
    cp "$RESULT/full.png" "$OUT"
    echo "$OUT"
  else
    show "$RESULT" "$md"
  fi
done
