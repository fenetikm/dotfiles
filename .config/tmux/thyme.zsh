#!/bin/bash

cat ~/.thyme-tmux | gsed 's/:[0-9][0-9]/m/' | gsed 's/\]\([0-9]\)/] \1/' | gsed 's/\]$/\]  | /'
