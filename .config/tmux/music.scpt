on appIsRunning(appName)
    tell app "System Events" to (name of processes) contains appName
end appIsRunning
if appIsRunning("Music") then
  tell app "Music" to get the name of the current track
end if

