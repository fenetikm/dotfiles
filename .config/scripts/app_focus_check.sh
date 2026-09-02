 #!/bin/zsh

 # Logs every change of the frontmost (focused) app with a timestamp.
 PREV=""
 while true; do
   FRONT=$(lsappinfo info -only name $(lsappinfo front) 2>/dev/null | sed 's/.*"\(.*\)".*/\1/')
   if [[ "$FRONT" != "$PREV" && -n "$front" ]]; then
     printf '%s  ->  %s\n' "$(date '+%H:%M:%S.%2N')" "$FRONT" | tee -a ./focus-watch.log
     PREV="$FRONT"
   fi
   sleep 0.15
 done
