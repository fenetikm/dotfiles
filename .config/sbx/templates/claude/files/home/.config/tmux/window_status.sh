#!/bin/bash
HOST=host.docker.internal
{ curl -s -o /dev/null --max-time 2 "http://$HOST:$TM_PORT/" --data $'running tests\n' & } 2>/dev/null
