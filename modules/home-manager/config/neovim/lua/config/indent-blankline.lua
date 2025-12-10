local ibl = prequire("ibl")
if not ibl then
	return
end

local hooks = require("ibl.hooks")
-- hide first level indent guide
hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)

ibl.setup({
	indent = {
		char = "│",
	},
	scope = {
		show_start = false,
		show_end = false,
		include = {
			node_type = { ["*"] = { "*" } },
		},
	},
	exclude = {
		filetypes = {
			"help",
			"checkhealth",
			"lazy",
			"lspinfo",
			"TelescopePrompt",
			"TelescopeResults",
			"themery",
			"neo-tree",
		},
		buftypes = {
			"terminal",
			"nofile",
			"quickfix",
			"prompt",
		},
	},
	-- remove_blankline_trail = true,
	-- show_trailing_blankline_indent = false,
	-- show_current_context = true,
	-- show_current_context_start = true,
})
