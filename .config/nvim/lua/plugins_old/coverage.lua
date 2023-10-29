require('coverage').setup({
  commands = true,
  signs = {
    covered = { hl = 'NvimCoverageCovered', text = '┊' },
    uncovered = { hl = 'NvimCoverageUncovered', text = '┊' },
    partial = { hl = 'NvimCoveragePartial', text = '┊' },
  },
  summary = {
    min_coverage = 80.0,      -- minimum coverage threshold (used for highlighting)
  },
})
