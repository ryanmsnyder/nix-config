local util = {}

util.separators = {
	space = " ",
	vertical_bar = "┃",
	vertical_bar_thin = "│",
	left = "",
	right = "",
	block = "█",
	left_filled = "",
	right_filled = "",
	slant_left = "",
	slant_left_thin = "",
	slant_right = "",
	slant_right_thin = "",
	slant_left_2 = "",
	slant_right_2 = "",
	left_rounded = "",
	left_rounded_thin = "",
	right_rounded = "",
	right_rounded_thin = "",
}

-- get highlight by highlight group name
-- ignore any errors
local get_highlight = function(name)
	local success, result = pcall(function()
		return vim.api.nvim_get_hl(0, { name = name, link = false })
	end)
	if success then
		return result
	else
		return nil -- or some default value or log the error
	end
end

local get_default_hl = function()
	return {
		diag_warn = get_highlight("DiagnosticWarn").fg,
		diag_error = get_highlight("DiagnosticError").fg,
		diag_hint = get_highlight("DiagnosticHint").fg,
		diag_info = get_highlight("DiagnosticInfo").fg,
		git_del = get_highlight("diffDeleted").fg,
		git_add = get_highlight("diffAdded").fg,
		git_change = get_highlight("diffChanged").fg,

		-- general
		base_bg = get_highlight("Normal").bg,
		bkg = get_highlight("ColorColumn").bg,
		light_text = get_highlight("Conceal").fg,

		-- vi modes
		normal = get_highlight("Character").fg,
		visual = get_highlight("Identifier").fg,
		select = get_highlight("TSParameter").fg,
		insert = get_highlight("String").fg,
		replace = get_highlight("TSParameter").fg,
		command = get_highlight("Constant").fg,
		prompt = get_highlight("Character").fg,
		confirm = get_highlight("Conditional").fg,
		terminal = get_highlight("Conditional").fg,
		nterminal = get_highlight("Operator").fg,

		-- right aligned components
		file_name_bkg = get_highlight("@parameter").fg,
		dir_name_bkg = get_highlight("Identifier").fg,

		-- lsp progress
		lsp_prog = get_highlight("WinBar").fg,
	}
end

local get_heirline_theme = function()
	local colorscheme = vim.g.colors_name
	if not colorscheme then
		print("no colorscheme")
		return get_default_hl()
	end

	-- get base theme name (i.e. if the theme is catppuccin-mocha, return catppuccin)
	local base_theme = string.match(colorscheme, "([^%-]+)")

	local theme_highlights_module = string.format("config.heirline.themes.%s", base_theme)
	return require(theme_highlights_module)
end

-- merge theme highlight with defualt_hl, overriding defualt_hl where there are collisions
util.highlights = function()
	local default_hl = get_default_hl()
	local theme_highlights = get_heirline_theme().highlights()
	if not theme_highlights then
		return default_hl
	end

	-- make sure that the theme file returns a table
	if type(theme_highlights) ~= "table" then
		return default_hl
	end

	-- merge default highlights above with theme-specific heirline highlights
	-- keys in defualt_highlights will be overridden by the theme-specific highlights
	for k, v in pairs(theme_highlights) do
		default_hl[k] = v
	end

	return default_hl
end

-- util.lsp_progress = function()
--   -- if #vim.lsp.buf_get_clients() == 0 then
--   --   return ""
--   -- end
--
--   local Lsp = vim.lsp.util.get_progress_messages()[1]
--   if Lsp then
--     local msg = Lsp.message or ""
--     local percentage = Lsp.percentage
--     if not percentage then
--       return ""
--     end
--     local title = Lsp.title or ""
--     local spinners = {
--       "",
--       "󰀚",
--       "",
--     }
--     local success_icon = {
--       "",
--       "",
--       "",
--     }
--     local ms = vim.loop.hrtime() / 1000000
--     local frame = math.floor(ms / 120) % #spinners
--
--     if percentage >= 70 then
--       -- only include msg if it's not empty
--       if msg and msg ~= "" then
--         return string.format(" %%<%s %s %s (%s%%%%) ", success_icon[frame + 1], title, msg, percentage)
--       else
--         return string.format(" %%<%s %s (%s%%%%) ", success_icon[frame + 1], title, percentage)
--       end
--     end
--
--     -- only include msg if it's not empty
--     if msg and msg ~= "" then
--       return string.format(" %%<%s %s %s (%s%%%%) ", spinners[frame + 1], title, msg, percentage)
--     else
--       return string.format(" %%<%s %s (%s%%%%) ", spinners[frame + 1], title, percentage)
--     end
--   end
--
--   return ""
-- end

-- return space separated string containing attached LSP clients, linters, formatters,
-- and code action providers
util.get_attached_lsp_clients = function()
	local buf_clients = vim.lsp.get_clients({ bufnr = 0 })

	-- return early if there are no active lsp clients
	if next(buf_clients) == nil then
		return
	end

	local buf_ft = vim.bo.filetype
	local buf_client_names = {}

	for _, client in ipairs(buf_clients) do
		table.insert(buf_client_names, client.name)
	end

	-- -- This needs to be a string only table so we can use concat below
	-- local unique_client_names = {}
	-- for _, client_name_target in ipairs(buf_client_names) do
	--   local is_duplicate = false
	--   for _, client_name_compare in ipairs(unique_client_names) do
	--     if client_name_target == client_name_compare then
	--       is_duplicate = true
	--     end
	--   end
	--   if not is_duplicate then
	--     table.insert(unique_client_names, client_name_target)
	--   end
	-- end

	local client_names_str = table.concat(buf_client_names, " ")
	local language_servers = string.format("%s [%s]", require("icons.icons").Config, client_names_str)

	return language_servers
end

return util
