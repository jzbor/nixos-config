-- LSP settings
local nvim_lsp = require 'lspconfig'
local on_attach = function(_, bufnr)
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Sets up all of the keybindings that we will need for navigating the code and using features like getting documentation tooltips or quick actions. We'll go through them in more detail in a moment.
	local opts = { noremap = true, silent = true }
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.open_float()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.diagnostic.open_float(nil, {focus=false})<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
	vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
end

-- nvim-cmp supports additional completion capabilities.
capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Enable the following language servers. If you ever find yourself needing another programming language support, you'll have to find its LSP, add it to this list and make sure it is installed in your system! We'll go through installing tsserver together for TypeScript support.
local servers = { 'clangd', 'rust-analyzer', 'pyright', 'tsserver', 'gopls', 'typst-lsp', 'nixd', 'nil', 'jdtls', 'millet', 'tinymist', 'harper-ls' }
local path = os.getenv('PATH');
for _, lsp in ipairs(servers) do
	if vim.fn.executable(lsp) == 1
	then
		local params = {
			on_attach = on_attach,
			capabilities = capabilities,
		};

		if (lsp == 'nil') -- workaround
		then
			lsp = 'nil_ls'
		end
		lsp = string.gsub(lsp, '-', '_') -- workaround

		if (lsp == 'rust_analyzer')
		then
			params.settings = {
				["rust-analyzer"] = {
					imports = {
						granularity = {
							group = "module",
						},
					},
				}
			}
		end

		-- if lsp == 'harper_ls'
		-- then
		-- 	params.settings = {
		-- 		["larper-ls"] = {
		-- 			-- https://writewithharper.com/docs/integrations/neovim
		-- 		},
		-- 	}
		-- end

		vim.lsp.enable(lsp)
		vim.lsp.config(lsp, params)
	end
end

-- Make runtime files discoverable to the server.
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

-- Set completeopt to have a better completion experience.
vim.o.completeopt = 'menuone,noselect'
