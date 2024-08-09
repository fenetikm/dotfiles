return {
  {
    'mfussenegger/nvim-dap',
    keys = {
      {'<leader>db', function() require('dap').toggle_breakpoint() end, silent = true, desc = 'Toggle breakpoint'},
      {'<leader>ds', function() require('dap').continue() end, silent = true, desc = 'Start / continue'},
      {'<leader>dk', function() require('dap').step_back() end, silent = true, desc = 'Step back'},
      {'<leader>dl', function() require('dap').step_into() end, silent = true, desc = 'Step into'},
      {'<leader>dj', function() require('dap').step_over() end, silent = true, desc = 'Step over'},
      {'<leader>dh', function() require('dap').step_out() end, silent = true, desc = 'Step out'},
      {'<leader>d<cr>', function() require('dap').run_to_cursor() end, silent = true, desc = 'Run to cursor'},
      {'<leader>dt', function() require('dap').terminate() end, silent = true, desc = 'Terminate'},
      {'<leader>dc', function() require('dap').clear_breakpoints() end, silent = true, desc = 'Clear breakpoints'},
      {'<leader>dr', function() require('dap').repl.open() end, silent = true, desc = 'Open REPL'},
      {'<leader>dv', function() require('dapui').eval(nil, { enter = true}) end, silent = true, desc = 'Evaluate'},
      {'<leader>dV', function() require('dapui').eval(vim.fn.input('Expressions > ')) end, silent = true, desc = 'Expression'},
      {'<leader>dB', function() require('dap').set_breakpoint(vim.fn.input('Condition > ')) end, silent = true, desc = 'Condition'},
    },
    dependencies = {
      {
        'rcarriga/nvim-dap-ui',
        opts = {
          floating = {
            border = "none"
          },
          layouts = { {
            elements = { {
              id = "scopes",
              size = 0.55
            }, {
                id = "breakpoints",
                size = 0.15
              }, {
                id = "stacks",
                size = 0.15
              }, {
                id = "watches",
                size = 0.15
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
        'nvim-neotest/nvim-nio'
      },
      {
        'theHamsta/nvim-dap-virtual-text',
        event = 'VeryLazy',
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
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')
      vim.fn.sign_define('DapBreakpoint', {text='●', texthl='DapBreakpoint', linehl='', numhl=''})
      vim.fn.sign_define('DapBreakpointCondition', {text='◆', texthl='DapBreakpointCondition', linehl='', numhl=''})
      vim.fn.sign_define('DapStopped', {text='▶', texthl='DapStopped', linehl='', numhl=''})

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

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
          name = 'Listen for Xdebug (9000)',
          port = 9000,
          log = true,
          pathMappings = {
            ['/app/'] = '/Users/michael/Documents/Work/personify_care/repos/personify-care-platform/',
            ['/app/application/'] = '/Users/michael/Documents/Work/personify_care/repos/personify-care-platform/application/',
          },
        },
        {
          type = 'php',
          request = 'launch',
          name = 'Listen for Xdebug, tests, cron (8000)',
          port = 8000,
          log = true,
        },
      }
    end
  }
}
