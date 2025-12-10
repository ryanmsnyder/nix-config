local M = {}

M.before = function(flavor)
	local catppuccin = prequire("catppuccin")

	if not catppuccin then
		return
	end

	vim.g.catppuccin_flavour = flavor -- latte, frappe, macchiato, mocha

	catppuccin.setup({
		dim_inactive = {
			enabled = true,
			shade = "dark",
			percentage = 0.50,
		},
		transparent_background = false,
		term_colors = true,
		compile = {
			enabled = true,
			path = vim.fn.stdpath("cache") .. "/catppuccin",
		},
		styles = {
			comments = { "italic" },
			conditionals = { "italic" },
			loops = {},
			functions = {},
			keywords = {},
			strings = {},
			variables = {},
			numbers = {},
			booleans = {},
			properties = {},
			types = {},
			operators = {},
		},
		integrations = {
			treesitter = true,
			native_lsp = {
				enabled = true,
				virtual_text = {
					errors = { "italic" },
					hints = { "italic" },
					warnings = { "italic" },
					information = { "italic" },
				},
				underlines = {
					errors = { "undercurl" },
					hints = { "undercurl" },
					warnings = { "undercurl" },
					information = { "undercurl" },
				},
			},
			-- nvimtree = true,
			lsp_trouble = true,
			cmp = true,
			gitsigns = true,
			telescope = true,
			neotree = true,
			which_key = true,
			-- indent_blankline = {
			-- 	enabled = true,
			-- 	-- colored_indent_levels = true,
			-- },
			bufferline = true,
			mason = true,
			dap = {
				enabled = true,
				enable_ui = true, -- enable nvim-dap-ui
			},
		},
		color_overrides = {},
		highlight_overrides = {
			latte = require("config.themes.catppuccin.highlights").highlights(),
			frappe = require("config.themes.catppuccin.highlights").highlights(),
			macchiato = require("config.themes.catppuccin.highlights").highlights(),
			mocha = require("config.themes.catppuccin.highlights").highlights(),
		},
	})
end

return M
