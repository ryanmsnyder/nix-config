local utils = require("utils")

-- Global variable to store the previous cursor setting
_G.guicursor_prev = nil

-- List of filetypes to apply the cursor settings
local targetFiletypes = {
	"aerial",
	"neo-tree",
	"Trouble",
	-- You can add more filetypes here as needed.
}

-- auto command group
local augroup = vim.api.nvim_create_augroup("HideCursor", { clear = true })

-- function to check if the current buffer is of a target filetype
local function isTargetBuffer(filetype)
	for _, targetFiletype in ipairs(targetFiletypes) do
		if filetype == targetFiletype then
			return true
		end
	end
	return false
end

-- hide cursor when entering a target window
vim.api.nvim_create_autocmd("WinEnter", {
	pattern = "*",
	callback = function()
		if isTargetBuffer(vim.bo.filetype) then
			-- Store the current cursor setting
			_G.guicursor_prev = vim.o.guicursor
			-- Apply custom cursor settings
			vim.api.nvim_set_hl(0, "HIDDEN", { blend = 100, nocombine = true })
			vim.o.guicursor = "a:HIDDEN"
		end

		-- if window is a popup (`relative` property of window is not an empty string) set it back to the previous/normal cursor
		-- this allows the cursor to appear in neo-tree popup windows
		local win_id = vim.api.nvim_get_current_win()
		local win_config = vim.api.nvim_win_get_config(win_id)
		if win_config["relative"] ~= "" then
			vim.o.guicursor = _G.guicursor_prev
		end
	end,
	group = augroup,
})

-- restore cursor when leaving a target window
vim.api.nvim_create_autocmd("WinLeave", {
	pattern = "*",
	callback = function()
		if isTargetBuffer(vim.bo.filetype) then
			-- Restore the previous cursor setting
			if _G.guicursor_prev then
				vim.o.guicursor = _G.guicursor_prev
			end
		end
	end,
	group = augroup,
})

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
