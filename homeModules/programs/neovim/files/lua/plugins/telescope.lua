return {
	{
		'nvim-telescope/telescope.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		opts = {
			defaults = {
				mappings = {
					i = {
						['<C-u>'] = false,
						['<C-d>'] = false,
					},
				},
			},
		},
		keys = {
			{ "<leader>lg", "<CMD>LazyGit<CR>", desc = "LazyGit" },
			{ '<leader><space>', "<CMD>lua require('telescope.builtin').buffers()<CR>", },
			{ '<leader>sf', "<CMD>lua require('telescope.builtin').find_files({previewer = false, hidden = false})<CR>", },
			{ '<leader>s.', "<CMD>lua require('telescope.builtin').find_files({previewer = false, hidden = true})<CR>", },
			{ '<leader>sb', "<CMD>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>", },
			{ '<leader>sh', "<CMD>lua require('telescope.builtin').help_tags()<CR>", },
			{ '<leader>st', "<CMD>lua require('telescope.builtin').tags()<CR>", },
			{ '<leader>ss', "<CMD>lua require('telescope.builtin').grep_string()<CR>", },
			{ '<leader>sg', "<CMD>lua require('telescope.builtin').live_grep()<CR>", },
			{ '<leader>so', "<CMD>lua require('telescope.builtin').tags{ only_current_buffer = true }<CR>", },
			{ '<leader>?', "<CMD>lua require('telescope.builtin').oldfiles()<CR>", },
			{ '<leader>sd', "<CMD>Telescope file_browser path=%:p:h select_buffer=true<CR>", },

			{ '<leader>gr', "<CMD>lua require('telescope.builtin').lsp_references()<CR>", },
			{ '<leader>gc', "<CMD>lua require('telescope.builtin').lsp_incoming_calls()<CR>", },
			{ '<leader>go', "<CMD>lua require('telescope.builtin').lsp_outgoing_calls()<CR>", },
			{ '<leader>gs', "<CMD>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<CR>", },
			{ '<leader>gd', "<CMD>lua require('telescope.builtin').lsp_diagnostics()<CR>", },
			{ '<leader>gi', "<CMD>lua require('telescope.builtin').lsp_implementations()<CR>", },
			{ '<leader>gd', "<CMD>lua require('telescope.builtin').lsp_definitions()<CR>", },
			{ '<leader>gt', "<CMD>lua require('telescope.builtin').lsp_type_definitions()<CR>", },
		}
	},
	{
		'nvim-telescope/telescope-file-browser.nvim',
		dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' }
	},
}
