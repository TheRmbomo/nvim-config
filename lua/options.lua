vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.backspace = 'indent,eol,start'
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.autoread = true
vim.opt.title = true
-- vim.opt.titlestring = [[%f %h%m%r%w %{v:progname} (%{tabpagenr()} of %{tabpagenr('$')})]]
vim.opt.titlestring = [[[%{fnamemodify(getcwd(), ':t')}] %f %h%m%r%w]]

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.expandtab = false
vim.opt.mousehide = false
vim.opt.smoothscroll = true
vim.opt.scrolloff = 4
vim.opt.clipboard = 'unnamedplus'

vim.wo.number = true
vim.wo.relativenumber = true

-- local exampleGroup = vim.api.nvim_create_augroup('ExampleGroupSettings', { clear = true })
-- vim.api.nvim_create_autocmd({ 'BufRead', 'BufEnter' }, {
-- 	pattern = '/tmp/insert/directory/here/*',
-- 	group = exampleGroup,
-- 	command = 'set tabstop=2 shiftwidth=4',
-- })

local goGroup = vim.api.nvim_create_augroup('GoProjectSetup', { clear = true })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufEnter' }, {
	pattern = '*.go',
	group = goGroup,
	command = 'set noexpandtab tabstop=4 shiftwidth=4',
})

local zigGroup = vim.api.nvim_create_augroup('ZigGroup', { clear = true })
vim.api.nvim_create_autocmd({ 'BufRead', 'BufEnter' }, {
	pattern = '*.zig, *.zir',
	group = zigGroup,
	callback = function()
		vim.opt.expandtab = true
		vim.opt.tabstop = 4
		vim.opt.shiftwidth = 4
		vim.api.nvim_create_user_command("Std", function()
			if vim.api.nvim_get_mode().mode ~= "i" then
				vim.cmd("startinsert") -- Enter insert mode
				vim.api.nvim_paste("const std = @import(\"std\");", true, -1)
			end
		end, { desc = "Write a std import" })
	end
})

vim.filetype.add({
	filename = {
		['.swcrc'] = 'json'
	},
})

vim.filetype.add({
	extension = {
		html = "glimmer",
		hbs = "glimmer",
		handlebars = "glimmer",
	},
})

-- Define a Neovim command :SearchParentheses
vim.api.nvim_create_user_command('SearchParentheses', function()
	local ext = vim.fn.expand('%:e')
	if ext == 'js' or ext == 'ts' then
		-- Set the search register to your regex
		-- Note: escaping differs slightly in Lua strings
		local pattern = [[\(if\|>\|catch\|while\|:\|compile\|for\)\@<! (]]
		vim.fn.setreg('/', pattern)   -- set search register for n/N repetition
		vim.fn.search(pattern, 'Wc')  -- perform search, suppress errors
	else
		print("SearchParentheses only applies to .js or .ts files")
	end
end, {})

local config_path = vim.fn.stdpath("config") .. "/init.lua"

vim.api.nvim_create_user_command("ReloadSrc", function()
	vim.cmd("luafile ", config_path)
end, { desc = "Reload nvim lua init" })

vim.api.nvim_create_user_command("Src", function()
	vim.cmd.edit(config_path)

	vim.api.nvim_create_autocmd("BufDelete", {
		pattern = config_path,
		once = true,
		callback = function()
			vim.cmd("luafile ", config_path)
		end,
	})
end, { desc = "Open the neovim config lua and reload it upon closing the buffer." })
