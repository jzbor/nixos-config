return {
	{
		'nvim-treesitter/nvim-treesitter',
		opts = {
			-- Add languages to be installed here that you want installed for treesitter
			ensure_installed = { 'c', 'cpp', 'lua', 'python', 'rust', 'make', 'java', 'nix' },
			highlight = {
				enable = true, -- false will disable the whole extension.
			},
			incremental_selection = {
				enable = false,
				keymaps = {
					init_selection = 'gsn',
					node_incremental = 'grn',
					scope_incremental = 'grc',
					node_decremental = 'grm',
				},
			},
			indent = {
				enable = true,
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim.
					keymaps = {
						-- You can use the capture groups defined in textobjects.scm.
						['af'] = '@function.outer',
						['if'] = '@function.inner',
						['ac'] = '@class.outer',
						['ic'] = '@class.inner',
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						[']m'] = '@function.outer',
						[']]'] = '@class.outer',
					},
					goto_next_end = {
						[']M'] = '@function.outer',
						[']['] = '@class.outer',
					},
					goto_previous_start = {
						['[m'] = '@function.outer',
						['[['] = '@class.outer',
					},
					goto_previous_end = {
						['[M'] = '@function.outer',
						['[]'] = '@class.outer',
					},
				},
			},
		},
	},
}
