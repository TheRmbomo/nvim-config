vim.keymap.set('n', '<leader>q', function()
	local winid = vim.fn.getloclist(0, { winid = 0 }).winid

	if winid ~= 0 then
		-- Loclist is open → close it
		vim.cmd("lclose")
	else
		-- Loclist is closed → populate & open it
		vim.diagnostic.setloclist({ open = true })
	end
end, { desc = "Toggle diagnostics loclist" })

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set('n', ';', ':')
vim.keymap.set('v', ';', ':')

vim.keymap.set('n', '<S-Left>', '<Left>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-Right>', '<Right>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-Up>', '<Up>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-Down>', '<Down>', { noremap = true, silent = true })

vim.keymap.set('v', '<S-Left>', '<Left>', { noremap = true, silent = true })
vim.keymap.set('v', '<S-Right>', '<Right>', { noremap = true, silent = true })
vim.keymap.set('v', '<S-Up>', '<Up>', { noremap = true, silent = true })
vim.keymap.set('v', '<S-Down>', '<Down>', { noremap = true, silent = true })

vim.keymap.set('n', '<A-j>', ':move .+1<CR>==')
vim.keymap.set('v', '<A-j>', ':move \'>+1<CR>gv=gv')

vim.keymap.set('n', '<A-k>', ':move .-2<CR>==')
vim.keymap.set('v', '<A-k>', ':move \'<-2<CR>gv=gv')

vim.api.nvim_create_user_command('ClearSearch', function()
	vim.fn.setreg('/', '')
	vim.cmd('let @/=""')
	-- vim.cmd('silent! s///ne')
	-- vim.cmd('silent! %s///ne')
	vim.cmd('call histdel("/")')
	vim.cmd('call histdel("?")')
	vim.cmd('call histdel("=")')
	-- vim.cmd('call histdel(":")')
	vim.cmd('nohlsearch')
	-- vim.cmd('wshada!')
end, {})
vim.keymap.set('n', '<leader>h', ':ClearSearch<CR>')

-- vim.api.nvim_create_user_command('ClearHistory', function()
-- 	vim.fn.setreg('/', '')
--     vim.cmd('let @/=""')
--     -- vim.cmd('silent! s///ne')
-- 	vim.cmd('silent! %s///e')
--     vim.cmd('call histdel("/")')
--     vim.cmd('call histdel(":")')
-- 	vim.cmd('wshada!')
--     vim.cmd('nohlsearch')
-- end, {})
-- vim.keymap.set('n', '<leader>h', ':ClearSearch<CR>')

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next)

-- local function with_q_close(callback)
-- 	return function(...)
-- 		local before = vim.api.nvim_list_wins()
-- 		callback(...)
--
-- 		vim.defer_fn(function()
-- 			local after = vim.api.nvim_list_wins()
-- 			for _, win in ipairs(after) do
-- 				if not vim.tbl_contains(before, win) then
-- 					local buf = vim.api.nvim_win_get_buf(win)
-- 					vim.keymap.set("n", "q", "<cmd>bd!<cr>", {
-- 						buffer = buf,
-- 						silent = true,
-- 					})
-- 				end
-- 			end
-- 		end, 30)
-- 	end
-- end

-- Add a quick close keymap 'q' to the quickfix buffer and select the next most recent buffer after
vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf",
	callback = function(event)
		local prev_win = vim.fn.win_getid(vim.fn.winnr("#"))

		vim.keymap.set("n", "q", function()
			vim.cmd("cclose")

			if prev_win ~= 0 and vim.api.nvim_win_is_valid(prev_win) then
				vim.api.nvim_set_current_win(prev_win)
			end
		end, {
			buffer = event.buf,
			silent = true,
		})
	end,
})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
		-- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
		-- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
		-- vim.keymap.set('n', '<space>wl', function()
		--   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		-- end, opts)
		vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
		vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
		vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
		-- vim.keymap.set("n", "gr", with_q_close(vim.lsp.buf.references), opts)
		-- vim.keymap.set('n', '<space>f', function()
		--   vim.lsp.buf.format { async = true }
		-- end, opts)
	end,
})
