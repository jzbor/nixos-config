-- KEYBINDINGS
-- Plugin specific keybindings are in the plugin's config files.

-- Function keys
vim.api.nvim_set_keymap('n', '<F1>', ':set number!<CR>', {})
vim.api.nvim_set_keymap('n', '<F2>', ':set relativenumber!<CR>', {})
vim.api.nvim_set_keymap('n', '<F3>', ':set cursorline!<CR>', {})
vim.api.nvim_set_keymap('n', '<F4>', ':set list!<CR>', {})
vim.api.nvim_set_keymap('n', '<F5>', ':source ~/.config/nvim/init.lua<CR>', {})
vim.api.nvim_set_keymap('n', '<F6>', ':set wrap!<CR>', {})

-- Split navigation and resizing
vim.api.nvim_set_keymap('n', '<C-Left>', ':vertical resize -5<CR>', {})
vim.api.nvim_set_keymap('n', '<C-Down>', ':resize -5<CR>', {})
vim.api.nvim_set_keymap('n', '<C-Up>', ':resize +5<CR>', {})
vim.api.nvim_set_keymap('n', '<C-Right>', ':vertical resize +5<CR>', {})

-- Tab navigation and moving
vim.api.nvim_set_keymap('n', '<Left>', ':tabprevious<CR>', {})
vim.api.nvim_set_keymap('n', '<Right>', ':tabnext<CR>', {})
vim.api.nvim_set_keymap('n', '<S-Left>', ':tabmove -1<CR>', {})
vim.api.nvim_set_keymap('n', '<S-Right>', ':tabmove +1<CR>', {})

-- Custom scripts
-- vim.api.nvim_set_keymap('n', '<Leader>r', ':belowright split term://run.sh %<CR>G', {})

-- Launch terminal
vim.api.nvim_set_keymap('n', '<C-Enter>', ':!$TERMINAL & sleep 0.2<CR><CR>', {})


-- Open highlighted file
vim.api.nvim_set_keymap('v', '<leader>o', 'y:!xdg-open "<C-r>0"<CR><CR>', {})

-- Debugging
vim.keymap.set('n', '<leader>dd', ":RunDebuggerWithArgs ")
vim.keymap.set('n', '<leader>dw', ":DapViewShow watches<CR>")
vim.keymap.set('n', '<leader>ds', ":DapViewShow scopes<CR>")
vim.keymap.set('n', '<leader>de', ":DapViewShow exceptions<CR>")
vim.keymap.set('n', '<leader>db', ":DapViewShow breakpoints<CR>")
vim.keymap.set('n', '<leader>dt', ":DapViewShow threads<CR>")
vim.keymap.set('n', '<leader>dr', ":DapViewShow repl<CR>")
vim.keymap.set('n', '<leader>dc', ":DapContinue<CR>")
vim.keymap.set('n', '<leader>b', ":DapToggleBreakpoint<CR>")
vim.keymap.set('n', '<leader>,', ":DapStepOver<CR>")
vim.keymap.set('n', '<leader>i', ":DapStepInto<CR>")
vim.keymap.set('n', '<leader>o', ":DapStepOut<CR>")
vim.keymap.set('n', '<leader>v', ":DapViewToggle<CR>")
