---@type vim.lsp.Config
return {
	cmd = { 'lua-language-server' },
	filetypes = { 'lua' },

	-- capabilities = capabilities,
	settings = {
		Lua = {
			inlayHints = {
				enable = true,
			},
			diagnostics = {
				globals = {'vim'},
			},
			completion = {
				enable = true,
			},
			workspace = {
				checkThirdParty = false, -- Optional: Adjust based on your needs
				library = {
					vim.env.VIMRUNTIME .. "/lua",
					-- Add other paths if you have custom Lua modules or libraries
				},
			},
		},
	},
}

