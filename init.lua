require("options")

package.loaded["lsp.ts_ls"] = nil

local lsp_configs = {}

for _, f in pairs(vim.api.nvim_get_runtime_file('lsp/*.lua', true)) do
	local server_name = vim.fn.fnamemodify(f, ':t:r')
	table.insert(lsp_configs, server_name)
end

vim.lsp.enable(lsp_configs)

vim.notify = function(msg, level, opts)
	-- Suppress "Applied changes" messages from LSP util
	if type(msg) == "string" and msg:match("^Applied changes") then
		return
	end
	-- For everything else, fall back to the default notifier
	vim.api.nvim_echo({{msg}}, false, {})
end

-- Shim for Pyright missing changeAnnotations
local apply_workspace_edit = vim.lsp.util.apply_workspace_edit
vim.lsp.util.apply_workspace_edit = function(workspace_edit, offset_encoding, change_annotations)
	if not change_annotations and workspace_edit.documentChanges then
		local has_annotated = false
		for _, change in ipairs(workspace_edit.documentChanges) do
			if change.edits then
				for _, edit in ipairs(change.edits) do
					if edit.annotationId then
						has_annotated = true
						break
					end
				end
			end
		end
		if has_annotated and not workspace_edit.changeAnnotations then
			workspace_edit.changeAnnotations = {
				default = {
					label = "edit",
					needsConfirmation = false,
				},
			}
		end
	end
	return apply_workspace_edit(workspace_edit, offset_encoding, change_annotations)
end

require("plugins")
require("plugin_config")

require("keymaps")
