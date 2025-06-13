#!/bin/bash

cat ~/.thyme-tmux | gsed 's/#\[[a-z\=]*\]//g' | gsed 's/$/ left/'
