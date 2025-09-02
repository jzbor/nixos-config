require('vis')

vis.events.subscribe(vis.events.INIT, function()
	-- Your global configuration options

	--- PLUGINS ---
	local plug = (function() if not pcall(require, 'plugins/vis-plug') then
	 	os.execute('git clone --quiet https://github.com/erf/vis-plug ' ..
		 	(os.getenv('XDG_CONFIG_HOME') or os.getenv('HOME') .. '/.config')
		 	.. '/vis/plugins/vis-plug')
	end return require('plugins/vis-plug') end)()

	local plugins = {
		{ 'https://git.sr.ht/~mcepl/vis-fzf-open/', alias = 'fzf_open' },
		{ 'https://gitlab.com/muhq/vis-lspc', alias = 'lspc' },
		-- { 'https://repo.or.cz/vis-goto-file.git' },

		{ 'Nomarian/vis-tab-autoconf' },
		{ 'erf/vis-cursors', alias = 'cursors' },
		{ 'erf/vis-minimal-theme', theme = true },
		{ 'erf/vis-plug' },
		{ 'erf/vis-title' },
		{ 'guillaumeboudon/vis-fzf', file = 'vis-fzf', alias = 'fzf_rg' },
		{ 'lutobler/vis-commentary' },
		{ 'lutobler/vis-modelines' },
		{ 'lutobler/vis-modelines' },
		{ 'milhnl/vis-format' },
		{ 'peaceant/vis-fzf-mru', file = 'fzf-mru', alias = 'fzf_mru' },
		{ 'thimc/vis-colorizer' },
	}

	plug.init(plugins, true)

	plug.plugins.lspc.ls_map.nix = {
		name = 'nil';
		cmd = 'nil';
	}

	-- plug.plugins.fzf_open.fzf_args = '--preview "bat --color always --decorations never --theme gruvbox-dark {}" --prompt ".../$(basename "$PWD"): "'--
	plug.plugins.fzf_open.fzf_args = '--preview "cat {}" --prompt ".../$(basename "$PWD"): "'

	plug.plugins.fzf_mru.fzfmru_args = plug.plugins.fzf_open.fzf_args
	plug.plugins.fzf_mru.fzfmru_path = 'grep "^'..os.getenv('PWD')..'" | fzf'
	plug.plugins.fzf_mru.fzfmru_filepath = os.getenv('XDG_CONFIG_HOME')..'/vis/mru'
	plug.plugins.fzf_mru.fzfmru_history = 100

	plug.plugins.cursors.path = os.getenv('XDG_CONFIG_HOME')..'/vis/vis-cursors.csv'
	plug.plugins.cursors.maxsize = 1000
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win) -- luacheck: no unused args
	-- Your per window configuration options e.g.
	-- vis:command('set number')
	vis:command('set number')
	vis:command('set ignorecase')
	vis:command('set autoindent')
	vis:command('set tabwidth 4')
	vis:command('set theme vis-minimal-theme/minimal-dark-clear')

	vis:map(vis.modes.NORMAL, " sf", function () vis:command('fzf') end)
	vis:map(vis.modes.NORMAL, " sg", function () vis:command('fzf-rg') end)
	vis:map(vis.modes.NORMAL, " sr", function () vis:command('fzfmru') end)
	vis:map(vis.modes.NORMAL, " lg", function () vis:command('!lazygit') end)
end)


vis.events.subscribe(vis.events.FILE_SAVE_PRE, function(file, _path)
	for i=1, #file.lines do
		-- Trim trailing whitespace
		if string.match(file.lines[i], '[ \t]$') then
			file.lines[i] = string.gsub(file.lines[i], '[ \t]*$', '')
		end
	end
end)
