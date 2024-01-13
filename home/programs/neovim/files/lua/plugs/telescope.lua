-- Telescope
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}
-- Add leader shortcuts.
vim.api.nvim_set_keymap('n', '<leader><space>', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sf', [[<cmd>lua require('telescope.builtin').find_files({previewer = false})<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sb', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>st', [[<cmd>lua require('telescope.builtin').tags()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sd', [[<cmd>lua require('telescope.builtin').grep_string()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sp', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>so', [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>?', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]], { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>gr', [[<cmd>lua require('telescope.builtin').lsp_references()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gc', [[<cmd>lua require('telescope.builtin').lsp_incoming_calls()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>go', [[<cmd>lua require('telescope.builtin').lsp_outgoing_calls()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gs', [[<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gd', [[<cmd>lua require('telescope.builtin').lsp_diagnostics()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gi', [[<cmd>lua require('telescope.builtin').lsp_implementations()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gd', [[<cmd>lua require('telescope.builtin').lsp_definitions()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gt', [[<cmd>lua require('telescope.builtin').lsp_type_definitions()<CR>]], { noremap = true, silent = true })

