return {
	{
		'kdheepak/lazygit.nvim',
		lazy = true,
		dependencies = { "nvim-lua/plenary.nvim", },
		cmd = { "LazyGit" },
		keys = {
			{ "<leader>lg", "<cmd>LazyGit<CR>", desc = "LazyGit" }
		}
	},

}
