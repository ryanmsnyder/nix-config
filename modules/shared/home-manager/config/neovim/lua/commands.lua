local utils = require("utils")

-- vim.api.nvim_create_autocmd("OptionSet", {
--   pattern = "background",
--   callback = function()
--     vim.cmd("Catppuccin " .. (vim.v.option_new == "light" and "latte" or "mocha"))
--   end,
-- })

-- vim.api.nvim_create_augroup("Heirline", { clear = true })
-- vim.api.nvim_create_autocmd("ColorScheme", {
--   callback = function()
--     print "ColorScheme event triggered"
--     local filename = os.getenv "HOME" .. "/Desktop/myfile.txt"
--
--     local file = io.open(filename, "a")
--     if file then
--       file:write "Hello, Desktop!\n"
--       file:close()
--     else
--       print "Error writing to file"
--     end
--
--     -- utils.on_colorscheme(setup_colors)
--   end,
--   group = "Heirline",
-- })

vim.api.nvim_create_augroup("telescope", { clear = true })
-- if leaving telescope buffer, set TelescopeResultsTitle back to its original colors
-- this is to allow Telescope command_history keymap in mappings.lua to change the color of TelescopeResultsTitle temporarily
vim.api.nvim_create_autocmd("BufUnload", {
	callback = function()
		if vim.bo.ft == "TelescopePrompt" then
			-- check if telescope_results_bg_hl global variable exists first
			local telescope_results_bg_hl = vim.api.nvim_get_hl_by_name("TelescopeResultsNormal", true).bg
			vim.api.nvim_set_hl(
				0,
				"TelescopeResultsTitle",
				-- { bg = vim.g.telescope_results_bg_hl.background, fg = vim.g.telescope_results_hl.foreground }
				{
					bg = telescope_results_bg_hl,
					fg = telescope_results_bg_hl,
				}
			)
		end
	end,
	group = "telescope",
})
