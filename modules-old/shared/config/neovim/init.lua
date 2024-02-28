-- source lua files
local util = require("utils")
local require = util.require

require("options") -- vim options
require("config.plugin_manager") -- Lazy plugin manager
require("theme")

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		require("commands")
		require("mappings")
		require("icons.icons")
	end,
})