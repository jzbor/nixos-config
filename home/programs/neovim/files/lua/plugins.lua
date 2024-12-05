-- PLUGINS

-- Install lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  'tpope/vim-fugitive', -- Git commands for nvim.
  'tpope/vim-commentary', -- Use "gc" to comment lines in visual mode. Similarly to cmd+/ in other editors.
  'tpope/vim-surround', -- A great tool for adding, removing and changing braces, brackets, quotes and various tags around your text.
  { 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' } }, -- UI to select things (files, search results, open buffers...)
  { "nvim-telescope/telescope-file-browser.nvim", dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" } },
  -- { 'romgrk/barbar.nvim', dependencies = {'kyazdani42/nvim-web-devicons'} }, -- A bar that will show at the top of you nvim containing your open buffers. Similarly to how other editors show tabs with open files.
  { 'lewis6991/gitsigns.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  -- 'itchyny/lightline.vim', -- Fancier status line with some information that will be displayed at the bottom.
  -- 'nvim-lualine/lualine.nvim',
  { "brianaung/yasl.nvim", opts = {} },
  { 'lewis6991/gitsigns.nvim', dependencies = { 'nvim-lua/plenary.nvim' } }, -- Adds git related info in the signs columns (near the line numbers) and popups.
  'nvim-treesitter/nvim-treesitter', -- Highlight, edit, and navigate code using a fast incremental parsing library. Treesitter is used by nvim for various things, but among others, for syntax coloring. Make sure that any themes you install support treesitter!
  'nvim-treesitter/nvim-treesitter-textobjects', -- Additional textobjects for treesitter.
  'neovim/nvim-lspconfig', -- Collection of configurations for built-in LSP client.
  'hrsh7th/nvim-cmp', -- Autocompletion plugin.
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-nvim-lsp',
  'saadparwaiz1/cmp_luasnip',
  'L3MON4D3/LuaSnip', -- Snippets plugin.
  'vimwiki/vimwiki',
  'editorconfig/editorconfig-vim',
  'LnL7/vim-nix',
  -- { 'kaarmu/typst.vim', ft = {'typ'} } -- currently broken
  { 'kaarmu/typst.vim' },
  -- { 'whonore/Coqtail' },

  -- Colorschemes
  -- 'bluz71/vim-moonfly-colors', -- A theme I particularly like.
  -- 'fneu/breezy', -- color scheme
  -- { 'romainl/Apprentice', branch = "fancylines-and-neovim" }, -- color scheme
  { 'zenbones-theme/zenbones.nvim', dependencies = { 'rktjmp/lush.nvim' } },
  'huyvohcmc/atlas.vim',
  'aditya-azad/candle-grey',
  'folke/zen-mode.nvim',
  -- 'folke/which-key.nvim',
  { 'mfussenegger/nvim-jdtls', ft = {'java'} },
  { 'jez/vim-better-sml', ft = {'sml'} },
}

require("lazy").setup(plugins, {
  lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
  ui = {
    icons = {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
})

-- luasnip setup (you can leave this here or move it to its own configuration file in `lua/plugs/luasnip.lua`.)
luasnip = require 'luasnip'
