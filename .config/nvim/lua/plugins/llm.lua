return {
  --[[ {
    "robitx/gp.nvim",
    config = function()
      local config = {
        -- For customization, refer to Install > Configuration in the Documentation/Readme
        providers = {
          googleai = {
            endpoint = "https://generativelanguage.googleapis.com/v1beta/models/{{model}}:streamGenerateContent?key={{secret}}",
            secret = os.getenv("GOOGLEAI_API_KEY"),
          },
        }
      }

      require("gp").setup(config)

      -- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
    end,
  } ]]
}
