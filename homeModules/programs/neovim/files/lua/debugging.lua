local dap = require('dap')
local dap_view = require('dap')
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

dap.adapters.lldb = {
  type = 'executable',
  command = 'lldb-dap', -- adjust as needed, must be absolute path
  name = 'lldb'
}
dap.adapters.rust = dap.adapters.lldb

local dap = require('dap')
dap.configurations.cpp = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    -- program = function()
    --   return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    -- end,
    program = function()
      return coroutine.create(function(coro)
        local opts = {}
        pickers
          .new(opts, {
            prompt_title = "Path to executable",
            finder = finders.new_oneshot_job({ "fd", "--no-ignore", "--type", "x" }, {}),
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(buffer_number)
              actions.select_default:replace(function()
                actions.close(buffer_number)
                coroutine.resume(coro, action_state.get_selected_entry()[1])
              end)
              return true
            end,
          })
          :find()
      end)
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},

    -- 💀
    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    -- runInTerminal = false,
  },
}
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

vim.api.nvim_create_user_command("RunDebuggerWithArgs", function(t)
  -- :help nvim_create_user_command
  args = vim.split(vim.fn.expand(t.args), ' ')
  -- approval = vim.fn.confirm(
  --   "Will try to run:\n    " ..
  --   vim.bo.filetype .. " " ..
  --   vim.fn.expand('%') .. " " ..
  --   t.args .. "\n\n" ..
  --   "Do you approve? ",
  --   "&Yes\n&No", 1
  -- )
  dap.run({
    type = vim.bo.filetype,
    request = 'launch',
    name = 'Launch file with custom arguments (adhoc)',
    program = function()
      return coroutine.create(function(coro)
        local opts = {}
        pickers
          .new(opts, {
            prompt_title = "Path to executable",
            finder = finders.new_oneshot_job({ "fd", "--no-ignore", "--type", "x" }, {}),
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(buffer_number)
              actions.select_default:replace(function()
                actions.close(buffer_number)
                coroutine.resume(coro, action_state.get_selected_entry()[1])
              end)
              return true
            end,
          })
          :find()
      end)
    end,
    args = args,
  })
end, {
  complete = 'file',
  nargs = '*'
})

dap_view.follow_tab = true;

require("nvim-dap-virtual-text").setup()
