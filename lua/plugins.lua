-- lazy bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"vhyrro/luarocks.nvim",
		priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
		config = true,
	},
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" }
	},
	"nvim-tree/nvim-web-devicons",
	"nvim-lualine/lualine.nvim",
	"nvim-treesitter/nvim-treesitter",
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.8',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},

	-- "williamboman/mason.nvim",
	-- "williamboman/mason-lspconfig.nvim",

	-- {
	-- 	"neovim/nvim-lspconfig",
	-- }
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"lua_ls", "ts_ls", "html", "gopls", "templ", "pyright", "jdtls",
				-- "bashls"
			},
		},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			-- "neovim/nvim-lspconfig",
		},
	},

	{
		"folke/tokyonight.nvim",
		opts = {
			transparent = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
		},
		config = function(_, opts)
			local tokyonight = require "tokyonight"
			tokyonight.setup(opts)
			tokyonight.load()
		end
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require('treesitter-context').setup({
				max_lines = 5,
				multiline_threshold = 3,
			})
		end
	},
	{
		"folke/ts-comments.nvim",
		opts = {},
		event = "VeryLazy",
		enabled = vim.fn.has("nvim-0.10.0") == 1,
		confg = function ()
			require('ts-comments').setup{}
		end
	},
	-- 'numToStr/Comment.nvim',
	{
		"karb94/neoscroll.nvim",
		config = function ()
			require('neoscroll').setup({})
		end
	},
	"sindrets/diffview.nvim",

	"hrsh7th/vim-vsnip",
	"hrsh7th/vim-vsnip-integ",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-cmdline",
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-vsnip",

	{
		'mrcjkb/haskell-tools.nvim',
		version = '^4', -- Recommended
		lazy = false, -- This plugin is already lazy
	},

	{
		'stevearc/conform.nvim',
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform will run multiple formatters sequentially
				python = { "isort", "black" },

				-- You can customize some of the format options for the filetype (:help conform.format)
				rust = { "rustfmt", lsp_format = "fallback" },

				-- Conform will run the first available formatter
				-- javascript = { "biome", "prettierd", "prettier", stop_after_first = true },
				-- html = { "biome", "prettierd", "prettier", stop_after_first = true }
			},
		},
	},

	-- {
	-- 	"nvim-jdtls",
	-- 	-- does this work?
	-- 	lazy = true,
	-- 	ft = { "java" },
	-- 	--
	-- },
})
