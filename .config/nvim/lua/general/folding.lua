vim.cmd([[
    set foldmethod=indent "indent method
    set foldlevelstart=99 "start unfolded
    set foldtext=Customfoldtext()
    set foldnestmax=10

    " Based off of a post by Greg Sexton
    function! Customfoldtext() abort
      "get first non-blank line
      let fs = v:foldstart
      while getline(fs) =~ '^\s*$' | let fs = nextnonblank(fs + 1)
      endwhile
      if fs > v:foldend
        let line = getline(v:foldstart)
      else
        let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
      endif

      let foldsymbol='+'
      " let repeatsymbol=''
      let repeatsymbol=''
      let prefix = foldsymbol . ' '

      let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
      let foldSize = 1 + v:foldend - v:foldstart
      let foldSizeStr = " " . foldSize . " lines "
      let foldLevelStr = repeat("+--", v:foldlevel)
      let lineCount = line("$")
      let expansionString = repeat(repeatsymbol, w - strwidth(prefix.foldSizeStr.line.foldLevelStr))
      return prefix . line . expansionString . foldSizeStr . foldLevelStr
    endfunction

]])
