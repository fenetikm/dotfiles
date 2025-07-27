-- from https://apple.stackexchange.com/a/440455 and some other sleuthing
tell the application "Finder"
    set drive_name to name of startup disk
  
    set free_bytes to (free space of disk drive_name)
    set free_Gbytes to (free_bytes / (1024 * 1024 * 0.1024) div 100) / 100
    set rounded_gb to free_Gbytes as integer

    return rounded_gb
end tell
