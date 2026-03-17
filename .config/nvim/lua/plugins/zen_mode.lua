-- replacement kitty plugin to handle socket changing
local set_kitty = function(font_size)
  if not vim.fn.executable("kitty") then
    return
  end

  local cmd = "kitty @ --to %s set-font-size %s"
  local socket = vim.trim(vim.fn.system("get_kitty_socket"))
  if socket == "nope" then
    return
  end

  vim.fn.system(cmd:format(socket, font_size))
end

return {
  {
    'folke/zen-mode.nvim',
    dependencies = {
      {
        'folke/twilight.nvim',
        opts = {
          context = 15,
          dimming = {
            alpha = 0.5
          }
        }
      }
    },
    keys = {
      { '<leader>z', function() require('zen-mode').toggle() end },
    },
    opts = {
      window = {
        width = 90,
        options = {
          relativenumber = false,
          number = false
        }
      },
      plugins = {
        tmux = { enabled = true },
      },
      on_open = function()
        require('gitsigns').toggle_signs(false)
        if vim.fn.exists(':IBLDisable') then
          vim.cmd('IBLDisable')
        end

        set_kitty("+4")


        vim.cmd([[redraw]])
      end,
      on_close = function()
        require('gitsigns').toggle_signs(true)
        if vim.fn.exists(':IBLEnable') then
          vim.cmd('IBLEnable')
        end

        set_kitty("0")
      end,
    }
  },
}
