local function generate_highlights()
	local colors = require("gruvbox.colors").setup()

	local H = {

		-- main background color of statusline and text
		-- bkg = get_hl("WinSeparator").fg,
		light_text = colors.fg_light,

		-- -- vi modes
		normal = colors.blue,
		-- insert = cp.green,
		visual = colors.yellow,
		-- select = cp.maroon,
		replace = colors.red,
		command = colors.orange,
		-- prompt = cp.teal,
		-- confirm = cp.mauve,
		-- terminal = cp.mauve,
		-- nterminal = cp.sky,
		--
		-- -- right aligned components
		-- file_name_bkg = cp.maroon,
		-- dir_name_bkg = cp.flamingo,
		--
		-- -- diagnostics
		-- diag_warn = cp.yellow,
		-- diag_error = cp.red,
		-- diag_hint = cp.teal,
		-- diag_info = cp.sky,

		-- winbar
		modified = colors.yellow,
	}
	return H
end

return {
	highlights = generate_highlights,
}
