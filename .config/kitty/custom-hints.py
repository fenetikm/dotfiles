#!/usr/bin/env python3

import re
from kitty.clipboard import (
        set_primary_selection,
        set_clipboard_string
)

RE_PATH = (
    r'(?=[ \t\n]|"|\(|\[|<|\')?'
    '(~/|/)?'
    '([-a-zA-Z0-9_+-,.]+/[^ \t\n\r|:"\'$%&)>\]]*)'
)

RE_URL = (r"(https?://|git@|git://|ssh://|s*ftp://|file:///)"
          "[a-zA-Z0-9?=%/_.:,;~@!#$&()*+-]*")

RE_FILE = r'\s?([a-zA-Z0-9_.-/]*[a-zA-Z0-9_.-]+\.(ini|yml|yaml|vim|toml|conf|lua|go|php|rs|py|js|vue|jsx|html|htm|md|mp3|wav|flac|mp4|mkv|me|sh|txt|log|gz|tar|rar|7z|zip|mod|sum|iso|patch))\s?'

RE_HASH = r'[0-9a-f][0-9a-f\r]{6,127}'

RE_COLOUR = r'#[0-9a-fA-F]{6,8}'

ALL_RE = RE_FILE + "|" + RE_PATH + "|" + RE_URL + "|" + RE_HASH + "|" + RE_COLOUR

def mark(text, args, Mark, extra_cli_args, *a):
    for idx, m in enumerate(re.finditer(ALL_RE, text)):
        start, end = m.span()
        mark_text = text[start:end].replace('\n', '').replace('\0', '').strip()
        yield Mark(idx, start, end, mark_text, {})

def handle_result(args, data, target_window_id, boss, extra_cli_args, *a):
    matches, groupdicts = [], []
    for m, g in zip(data['match'], data['groupdicts']):
        if m:
            matches.append(m), groupdicts.append(g)
    for word, match_data in zip(matches, groupdicts):
        set_clipboard_string(word)
