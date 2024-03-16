local function generate_highlights()
	local flavor = vim.g.catppuccin_flavour
	local cp = require("catppuccin.palettes").get_palette(flavor)

	local H = {

		-- main background color of statusline and text
		bkg = cp.surface0,
		light_text = cp.overlay1,

		-- vi modes
		normal = cp.lavender,
		insert = cp.green,
		visual = cp.flamingo,
		select = cp.maroon,
		replace = cp.maroon,
		command = cp.peach,
		prompt = cp.teal,
		confirm = cp.mauve,
		terminal = cp.mauve,
		nterminal = cp.sky,

		-- right aligned components
		file_name_bkg = cp.maroon,
		dir_name_bkg = cp.flamingo,

		-- diagnostics
		diag_warn = cp.yellow,
		diag_error = cp.red,
		diag_hint = cp.teal,
		diag_info = cp.sky,

		-- winbar
		modified = cp.yellow,
	}
	return H
end

return {
	highlights = generate_highlights,
}
