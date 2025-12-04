require'nvim-treesitter.configs'.setup {
	ensure_installed = {
		"lua", "vim",
		"typescript", "tsx", "json", "javascript",
		"rust", "gleam", "go", "python",
		"sql",
		"html", "css", "scss", "xml", "yaml", "glimmer",
		"bash", "gitignore", "markdown", "markdown_inline",
	},

	highlight = {
		enable = true,
		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		-- additional_vim_regex_highlighting = { 'javascript' },
	},
	indent = {
		enable = true,
		disable = { "go", "hs", "javascript", "typescript" }
	},
	context_commentstring = {
		config = {
			javascript = {
				__default = '// %s',
				jsx_element = '{/* %s */}',
				jsx_fragment = '{/* %s */}',
				jsx_attribute = '// %s',
				comment = '// %s',
			},
			typescript = { __default = '// %s', __multiline = '/* %s */' },
		},
	},
}
