return {
	'mfussenegger/nvim-dap',
	{
		'igorlfs/nvim-dap-view',
		opts = {
			winbar = {
				default_section = "threads",
			},
			windows = {
				size = 0.33,
				position = "below",
			},
			auto_toggle = true,
			follow_tab = true,
		},
	},
	{
		"Jorenar/nvim-dap-disasm",
		dependencies = "igorlfs/nvim-dap-view",
		config = true,
		opts = {
			dapview_register = false,
			-- dapview = {
			-- 	keymap = "A",
			-- 	label = "Disassembly [A]",
			-- 	short_label = "[A]",
			-- },
		},
	},
	'theHamsta/nvim-dap-virtual-text',
}
