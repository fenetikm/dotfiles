command! RenameFile :call custom#renamefile()

command! TrimWhiteSpace :call custom#trimwhitespace()
command! RemoveFancyCharacters :call custom#removefancycharacters()

command! Bdi :call custom#deleteinactivebufs()
command! DeleteInactiveBuffers :call custom#deleteinactivebufs()

command! StartProfile call custom#startprofile()
command! StopProfile call custom#stopprofile()

command! ToggleVerbose call custom#toggleverbose()
command! ToggleSyntax call custom#togglesyntax()

command! -nargs=1 NormLead call custom#ExecuteLeader(<f-args>)
