local ibl = prequire("ibl")
if not ibl then
	return
end

-- blankline.setup {
--   indentLine_enabled = 1,
--   show_current_context = true,
--   char = "▏",
--   -- space_char_blankline = " ",
--   buftype_exclude = { "terminal" },
--   filetype_exclude = { "help", "terminal", "dashboard", "alpha", "themery", "neo%-tree" },
-- }

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
	-- show_first_indent_level = false,
	-- show_current_context = true,
	-- show_current_context_start = true,
})
