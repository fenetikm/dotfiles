local M = {}

M.open_agent = function()
  require("sidekick.cli").toggle({ name = "claude", new = true })
end

return M
