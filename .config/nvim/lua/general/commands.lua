vim.cmd([[
  command! RenameFile :call custom#RenameFile()

  command! TrimWhiteSpace :call custom#TrimWhiteSpace()
  command! RemoveFancyCharacters :call custom#RemoveFancyCharacters()
  command! RemoveQuotes :call custom#RemoveQuotes()

  command! Bdi :call custom#DeleteInactiveBufs()
  command! DeleteInactiveBuffers :call custom#DeleteInactiveBufs()

  command! StartProfile call custom#StartProfile()
  command! StopProfile call custom#StopProfile()

  command! ToggleVerbose call custom#ToggleVerbose()
  command! ToggleSyntax call custom#ToggleSyntax()

  command! -nargs=1 NormLead call custom#ExecuteLeader(<f-args>)
]])
