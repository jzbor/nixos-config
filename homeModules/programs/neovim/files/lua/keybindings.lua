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
