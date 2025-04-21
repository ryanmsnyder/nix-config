-- remove highlighting of folded lines
vim.api.nvim_set_hl(0, "Folded", {
	bg = nil,
	fg = nil,
})

-- set the non current winbar bg to the same color as the buffer window
local bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
vim.api.nvim_set_hl(0, "WinBarNC", { bg = bg })
