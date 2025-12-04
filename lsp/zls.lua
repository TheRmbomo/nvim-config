return {
	cmd = { "zls" },

	on_attach = function(client, bufnr)
		-- Enable inlay hints if the server supports them
		if client.server_capabilities.inlayHintProvider then
			vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			-- vim.lsp.buf.inlay_hint(bufnr, true)
		end
	end,

	-- on_attach = function(client, bufnr)
	-- 	-- Buffer-local completion
	-- 	vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
	--
	-- 	-- LSP key mappings
	-- 	local opts = { noremap = true, silent = true, buffer = bufnr }
	-- 	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	-- 	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	-- 	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
	-- 	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	--
	-- 	-- Diagnostics
	-- 	vim.diagnostic.config({
	-- 		virtual_text = true,
	-- 		signs = true,
	-- 		underline = true,
	-- 		update_in_insert = false,
	-- 		severity_sort = true,
	-- 	}, bufnr)
	-- end,

	-- on_new_config = function(new_config, new_root_dir)
	-- 	local config_path = vim.fs.joinpath(new_root_dir, 'zls.json')
	-- 	if vim.fn.filereadable(config_path) ~= 0 then
	-- 		new_config.cmd = { 'zls', '--config-path', config_path }
	-- 	end
	-- end,

	filetypes = { "zig", "zir" },

	root_markers = { "zls.json", "build.zig", ".git" },

	-- single_file_support = true,

	-- Semantic diagnostics
	settings = {
		zig = {
	       	enable_autofix = true,
			enable_build_on_save = true,
			-- foo: foo
			inlay_hints_hide_redundant_param_names = true,
			-- foo: bar.foo, foo: &foo
			inlay_hints_hide_redundant_param_names_last_token = true,
			skip_std_references = true,
			-- semantic_tokens = "partial",
			semantic_tokens = "full",
			-- warn_style = true,
			build_on_save_step = "check",
			build_on_save_args = { "check", "--watch", "-fincremental" },
		}
	}
}
