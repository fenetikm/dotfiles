return {
  {
    'mfussenegger/nvim-dap',
    key = '<leader>db',
    config = function()
      local dap = require('dap')
      vim.fn.sign_define('DapBreakpoint', {text='●', texthl='DapBreakpoint', linehl='', numhl=''})
      vim.fn.sign_define('DapBreakpointCondition', {text='◆', texthl='DapBreakpointCondition', linehl='', numhl=''})
      vim.fn.sign_define('DapStopped', {text='▶', texthl='DapStopped', linehl='', numhl=''})
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
      local map = function(lhs, rhs, desc)
        if desc then
          desc = "[DAP] " .. desc
        end

        vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
      end

      map("<leader>dk", require("dap").step_back, "step back")
      map("<leader>dl", require("dap").step_into, "step into")
      map("<leader>dj", require("dap").step_over, "step over")
      map("<leader>dh", require("dap").step_out, "step out")
      map("<leader>ds", require("dap").continue, "start / continue")
      map("<leader>d<space>", require("dap").run_to_cursor, "start / continue")
      map("<leader>db", require("dap").toggle_breakpoint, "toggle breakpoint")
      map("<leader>dt", require("dap").terminate, "terminate")
      map("<leader>dc", require("dap").clear_breakpoints, "clear breakpoints")
      map("<leader>dB", function()
        require("dap").set_breakpoint(vim.fn.input "[DAP] Condition > ")
      end)
      map("<leader>dr", require("dap").repl.open, "open repl")
      map("<leader>de", require("dapui").eval)
      map("<leader>dE", function()
        require("dapui").eval(vim.fn.input "[DAP] Expression > ")
      end)

      dap.adapters.php = {
        type = 'executable',
        command = 'node',
        args = { os.getenv('HOME') .. '/Applications/vscode-php-debug/out/phpDebug.js' }
      }

      -- Can we instead use a config for the workspace?
      -- Can this be added in via .lvimrc?
      dap.configurations.php = {
        {
          type = 'php',
          request = 'launch',
          name = 'Listen for Xdebug',
          port = 9000,
          log = true,
          localSourceRoot = '/Users/michael/Documents/Work/personify_care/repos/personify-care-platform/application/',
          serverSourceRoot = '/app/application/'
        }
      }
    end
  },
  {
    'rcarriga/nvim-dap-ui',
    key = '<leader>db',
    dependencies = {'mfussenegger/nvim-dap'},
    opts = {
    layouts = { {
        elements = { {
            id = "scopes",
            size = 0.45
          }, {
            id = "breakpoints",
            size = 0.15
          }, {
            id = "stacks",
            size = 0.20
          }, {
            id = "watches",
            size = 0.20
          } },
        position = "left",
        size = 60
      }, {
        elements = { {
            id = "repl",
            size = 0.5
          }, {
            id = "console",
            size = 0.5
          } },
        position = "bottom",
        size = 8
      } },
    }
  },
  {
    'theHamsta/nvim-dap-virtual-text',
    key = '<leader>db',
    dependencies = {'mfussenegger/nvim-dap'},
    opts = {
      enabled = true,                        -- enable this plugin (the default)
      enabled_commands = true,               -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
      highlight_changed_variables = true,    -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
      highlight_new_as_changed = false,      -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
      show_stop_reason = true,               -- show stop reason when stopped for exceptions
      commented = false,                     -- prefix virtual text with comment string
      only_first_definition = true,          -- only show virtual text at first definition (if there are multiple)
      all_references = false,                -- show virtual text on all all references of the variable (not only definitions)
      filter_references_pattern = '<module', -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)
      -- experimental features:
      virt_text_pos = 'eol',                 -- position of virtual text, see `:h nvim_buf_set_extmark()`
      all_frames = false,                    -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
      virt_lines = false,                    -- show virtual lines instead of virtual text (will flicker!)
      virt_text_win_col = nil                -- position the virtual text at a fixed window column (starting from the first text column) ,
                                             -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
    }
  }
}
