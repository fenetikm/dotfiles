#!/bin/bash

# send message back to the host using the set TM_PORT
HOST=host.docker.internal
{ curl -s -o /dev/null --max-time 2 "http://$HOST:$TM_PORT/" --data "$1"$'\n' & } 2>/dev/null
