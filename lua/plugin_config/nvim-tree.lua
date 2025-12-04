vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

local function getCustomExclude()
	local custom = nil
	local loader = loadfile(vim.fn.getcwd() .. "/.tree.lua")
	if loader then
		custom = loader()
	end

	if custom and type(custom.exclude) == "table" and #custom.exclude > 0 then
		return custom.exclude
	end
end

local defaultExclude = {'^.git$'}

local opts = {
	git = {
		enable = true,
		ignore = false,
		timeout = 500,
	},
	filters = {
		custom = defaultExclude,
	},
	sort = {
		sorter = function(nodes)
			table.sort(nodes, function(a, b)
				local custom = nil
				local loader = loadfile(vim.fn.getcwd() .. "/.tree.lua")
				if loader then
					custom = loader()
				end

				if custom and type(custom.sort) == 'function' then
					local result = custom.sort(a, b)
					if type(result) == "boolean" then
						return result
					end
				end

				if custom and type(custom.order) == "table" and #custom.order > 0 then
					local aIndex = nil
					local bIndex = nil

					for i, value in ipairs(custom.order) do
						if aIndex == nil and a.name:match(value) then
							aIndex = i
						end

						if bIndex == nil and b.name:match(value) then
							bIndex = i
						end
					end

					if aIndex ~= nil or bIndex ~= nil then
						if aIndex == nil then
							return false
						elseif bIndex == nil then
							return true
						elseif aIndex ~= bIndex then
							return aIndex < bIndex
						end
					end
				end

				if custom and type(custom.orderLast) == "table" and #custom.orderLast > 0 then
					local aIndex = nil
					local bIndex = nil

					for i, value in ipairs(custom.orderLast) do
						if aIndex == nil and a.name:match(value) then
							aIndex = i
						end

						if bIndex == nil and b.name:match(value) then
							bIndex = i
						end
					end

					if aIndex ~= nil or bIndex ~= nil then
						if aIndex == nil then
							return true
						elseif bIndex == nil then
							return false
						elseif aIndex ~= bIndex then
							return aIndex < bIndex
						end
					end
				end

				if a.extension ~= b.extension then
					if a.extension ~= nil and b.extension ~= nil then
						return string.lower(a.extension) < string.lower(b.extension)
					else
						return a.extension == nil
					end
				end

				return string.lower(a.name) < string.lower(b.name)
			end)
		end
	}
}

require("nvim-tree").setup(opts)

local function reloadNvimTree()
	local newExclude = {}
	table.move(defaultExclude, 1, #defaultExclude, #newExclude + 1, newExclude)

	local customExclude = getCustomExclude()
	if customExclude then
		table.move(customExclude, 1, #customExclude, #newExclude + 1, newExclude)
	end

	opts.filters.custom = newExclude

	local is_nvim_tree_open = false
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local buf_name = vim.api.nvim_buf_get_name(buf)
		if string.match(buf_name, "NvimTree_") then
			is_nvim_tree_open = true
			break
		end
	end

	require("nvim-tree").setup(opts)
	local api = require("nvim-tree.api")
	api.tree.reload()
	if is_nvim_tree_open then
		api.tree.open()
	end
end

-- Reload nvim-tree upon opening nvim, saving lua files, or entering a new directory.
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*.lua",
	callback = reloadNvimTree,
})
vim.api.nvim_create_autocmd({ "DirChanged", "VimEnter" }, {
	callback = reloadNvimTree,
})

-- vim.api.nvim_create_autocmd({ "DirChanged", "VimEnter" }, {
-- 	callback = function()
-- 		if vim.bo.filetype == "NvimTree" then
-- 			require("nvim-tree.api").tree.reload()
-- 		end
-- 	end,
-- })

require("nvim-web-devicons").setup({
	default = true;
	strict = true;
	variant = "dark|light";
})

vim.keymap.set('n', '<c-n>', ':NvimTreeFindFileToggle<CR>')
