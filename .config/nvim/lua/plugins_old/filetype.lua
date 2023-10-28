require('filetype').setup({
  overrides = {
    literal = {
      ['.env'] = 'bash',
    },
  }
})
