local heirline = prequire("heirline")
local icons = require("icons.icons")
local conditions = require("heirline.conditions")
local util = require("config.heirline.util")

local M = {}

-- local function setup_colors()
--   return util.highlights()
-- end

-- -- load colors so that aliases can be used in hl functions/tables within components
-- heirline.load_colors(setup_colors)

-- -- change the colors of the statusline automatically whenever colorscheme is changed
-- vim.api.nvim_create_augroup("Heirline", { clear = true })
-- vim.api.nvim_create_autocmd("ColorScheme", {
--   callback = function()
--     utils.on_colorscheme(setup_colors)
--   end,
--   group = "Heirline",
-- })

-- this is causing constant updates - investigate !!!!!!!!!!!
-- listen lsp-progress event and refresh lualine (this is for lsp-progress plugin)
-- vim.api.nvim_create_augroup("heirline_augroup", { clear = true })
-- vim.api.nvim_create_autocmd("User LspProgressStatusUpdated", {
--   group = "heirline_augroup",
--   callback = function()
--     vim.cmd "redrawstatus"
--   end,
-- })

-- Flexible components priorities (higher the number, higher the priority)
-- higher numbers will contract last and expand first
local priority = {
	WorkDir = 60,
	Git = 50,
	FileName = 40,
	LSPActive = 25,
	CursorPosition = 10,
}

-- alignment and utility components
local Align, Space, Null, RightSepRound, LeftSepRound
do
	Null = { provider = "" }

	Align = { provider = "%=" }

	Space = setmetatable({ provider = " " }, {
		__call = function(_, n)
			return { provider = string.rep(" ", n) }
		end,
	})

	RightSepRound = { provider = util.separators.right_rounded }

	LeftSepRound = { provider = util.separators.left_rounded }
end

---> ViMode
-- child of ViMode
local ViModeIcon = {
	provider = icons.Vim,
}

-- child of ViMode
local ViModeName = {
	hl = {
		bold = true,
	},
	provider = function(self)
		return self.mode_info[self.mode][1]
	end,
}

-- parent
local ViMode = {
	-- get vim current mode, this information will be required by the provider
	-- and the highlight functions, so we compute it only once per component
	-- evaluation and store it as a component attribute
	init = function(self)
		self.mode = vim.fn.mode(1) -- :h mode()
	end,
	static = {
		mode_info = { -- change the strings if you like it vvvvverbose!
			["n"] = { "NORMAL", "normal" },
			["no"] = { "N-PENDING", "normal" },
			["v"] = { "VISUAL", "visual" },
			["V"] = { "V-LINE", "visual" },
			[""] = { "V-BLOCK", "visual" },
			["s"] = { "SELECT", "select" },
			["S"] = { "S-LINE", "select" },
			[""] = { "S-BLOCK", "select" },
			["i"] = { "INSERT", "insert" },
			["ic"] = { "INSERT", "insert" },
			["ix"] = { "INSERT", "insert" },
			["R"] = { "REPLACE", "replace" },
			["Rv"] = { "V-REPLACE", "replace" },
			["c"] = { "COMMAND", "command" },
			["cv"] = { "COMMAND", "command" },
			["ce"] = { "COMMAND", "command" },
			["r"] = { "PROMPT", "prompt" },
			["rm"] = { "MORE", "prompt" },
			["r?"] = { "CONFIRM", "confirm" },
			["!"] = { "SHELL", "insert" },
			["t"] = { "TERMINAL", "terminal" },
			["nt"] = { "NTERMINAL", "nterminal" },
		},
	},
	hl = function(self)
		local mode = self.mode
		return { fg = "bkg", bg = self.mode_info[mode][2] }
	end,
	-- Re-evaluate the component only on ModeChanged event!
	-- Also allows the statusline to be re-evaluated when entering operator-pending mode
	update = {
		"ModeChanged",
		pattern = "*:*",
		callback = vim.schedule_wrap(function()
			vim.cmd("redrawstatus")
		end),
	},

	-- child components
	Space,
	ViModeIcon,
	Space,
	ViModeName,
	{
		hl = function(self)
			return { fg = self.mode_info[self.mode][2], bg = "bkg" }
		end,
		RightSepRound,
	},
}

---> Cursor Position
-- Flexible component
local CursorPosition = {
	-- child components
	flexible = priority.CursorPosition,
	{ provider = "%p%% %l:%c", Space }, -- show percentage, line and column number
	{ provider = "%l:%c", Space }, -- only show line and column number
	Null,
}

---> LSP Progress
local LspProgress = {
	condition = conditions.lsp_attached,
	provider = function()
		return require("lsp-progress").progress({})
	end,
	Space,
}

---> Diagnostics
local Diagnostics = {

	condition = conditions.has_diagnostics,

	static = {
		-- Use icons directly instead of trying to get them from sign definitions
		error_icon = icons.Error,
		warn_icon = icons.Warn,
		info_icon = icons.Info,
		hint_icon = icons.Hint,
	},

	init = function(self)
		self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
		self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
		self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
		self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
	end,

	update = { "DiagnosticChanged", "BufEnter" },

	{
		provider = function(self)
			-- Add space between icon and number
			return self.errors > 0 and (self.error_icon .. " " .. self.errors .. " ")
		end,
		hl = { fg = "diag_error" },
	},
	{
		provider = function(self)
			-- Add space between icon and number
			return self.warnings > 0 and (self.warn_icon .. " " .. self.warnings .. " ")
		end,
		hl = { fg = "diag_warn" },
	},
	{
		provider = function(self)
			-- Add space between icon and number
			return self.info > 0 and (self.info_icon .. " " .. self.info .. " ")
		end,
		hl = { fg = "diag_info" },
	},
	{
		provider = function(self)
			-- Add space between icon and number
			return self.hints > 0 and (self.hint_icon .. " " .. self.hints)
		end,
		hl = { fg = "diag_hint" },
	},
}

---> LSP
-- Flexible component
local LSPActive = {
	condition = conditions.lsp_attached,
	-- update = { "LspAttach", "LspDetach" }, -- seems to prevent flexible components from working properly

	-- child components
	flexible = priority.LSPActive,
	{ provider = util.get_attached_lsp_clients }, -- display icon with all lsp clients, formatters, linters
	{ provider = require("icons.icons").Config, Space }, -- display only icon
	Null, -- contract to nothing
}

---> GitBranch
local GitBranch = {
	condition = conditions.is_git_repo,

	init = function(self)
		self.status_dict = vim.b.gitsigns_status_dict
	end,

	-- child components
	-- git branch name
	{
		provider = function(self)
			return icons.GitBranch .. " " .. self.status_dict.head
		end,
	},
	Space,
}

---> FilenameBlock
local FileIcon = {
	init = function(self)
		local filename = self.filename
		local extension = vim.fn.fnamemodify(filename, ":e")
		self.icon = require("nvim-web-devicons").get_icon(filename, extension, { default = true })
	end,

	provider = function(self)
		return self.icon and (self.icon .. " ")
	end,
}

-- Flexible component
local FileName = {
	init = function(self)
		self.lfilename = vim.fn.fnamemodify(self.filename, ":.")
		if self.lfilename == "" then
			self.lfilename = vim.bo.filetype
			-- self.lfilename = "[No Name]"
		end
	end,

	-- child components
	flexible = priority.FileName,

	-- display full relative path
	{
		provider = function(self)
			return self.lfilename
		end,
	},

	-- contract to shortened path
	{
		provider = function(self)
			return vim.fn.pathshorten(self.lfilename)
		end,
	},

	-- contract to only file name
	{
		provider = function(self)
			return vim.fn.fnamemodify(self.lfilename, ":t")
		end,
	},
}

-- display if a file is modified or readonly
local FileFlags = {
	{
		condition = function()
			return vim.bo.modified
		end,
		provider = icons.Modified,
	},
	{
		condition = function()
			return not vim.bo.modifiable or vim.bo.readonly
		end,
		provider = icons.Padlock,
	},
}

local FileNameBlock = {
	-- let's first set up some attributes needed by this component and it's children
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(0)
	end,
	hl = { fg = "bkg", bg = "file_name_bkg" },

	-- child components
	{ hl = { fg = "file_name_bkg", bg = "bkg" }, LeftSepRound },
	FileFlags,
	Space,
	FileIcon,
	FileName,
	Space,
	{ provider = "%<" }, -- this means that the statusline is cut here when there's not enough space
}

---> WorkDirNameBlock
local WorkDirIcon = {
	init = function(self)
		self.icon = icons.Folder
	end,
	provider = function(self)
		return self.icon and (self.icon .. " ")
	end,
}

local WorkDirName = {
	provider = vim.fn.fnamemodify(vim.fn.getcwd(), ":t"),
}

local WorkDirNameBlock = {
	hl = { fg = "bkg", bg = "dir_name_bkg" },

	-- child components
	{ hl = { fg = "dir_name_bkg", bg = "file_name_bkg" }, LeftSepRound },
	Space,
	WorkDirIcon,
	WorkDirName,
	Space,
}

local DefaultStatusline = {
	{
		ViMode,
		Space,
		CursorPosition,
		Align,
		LspProgress,
		Diagnostics,
		Align,
		LSPActive,
		Space,
		GitBranch,
		FileNameBlock,
		{ flexible = priority.WorkDir, WorkDirNameBlock, Null }, -- flexible component - make working directory contract to nothing
	},
}

---> Terminal
local ShellType = {
	provider = function(self)
		return icons.Terminal .. " " .. vim.o.shell:match("([^/]+)$")
	end,
}

local TerminalName = {
	static = {
		term_numbers = {
			"󰎤",
			"󰎧",
			"󰎪",
			"󰎭",
			"󰎱",
			"󰎳",
			"󰎶",
			"󰎹",
			"󰎼",
			"󰽽",
		},
	},
	provider = function(self)
		local term_number = vim.api.nvim_buf_get_var(0, "toggle_number")
		-- local term = require("toggleterm.terminal").get(term_number, true)
		local display_name = require("toggleterm.terminal").get(term_number, true).display_name
		local term_number_icon = self.term_numbers[term_number]
		local term_name = display_name or (term_number_icon and term_number_icon .. " ") or term_number -- number icon if id is less than 11
		return term_name
	end,
}

local TerminalStatusline = {
	condition = function()
		return conditions.buffer_matches({ filetype = { "toggleterm" } })
	end,

	hl = { fg = "light_text", bold = true },

	-- Quickly add a condition to the ViMode to only show it when buffer is active!
	{ condition = conditions.is_active, ViMode },

	-- child components
	Space,
	ShellType,
	Space,
	{ provider = util.separators.right },
	Space,
	TerminalName,
	Align,
}

---> neo-tree
local FileSize = {
	provider = function(self)
		local neo_tree_utils = require("neo-tree.utils")
		if self.path ~= nil then
			local ok, stats = pcall(vim.loop.fs_stat, self.path)
			if ok then
				if stats ~= nil then
					local bytes_size = stats.size
					local size_success, human_size = pcall(neo_tree_utils.human_size, bytes_size)
					if size_success then
						return human_size
					end
				end
			end
		end
	end,
}

local Permissions = {
	provider = function(self)
		if self.path ~= nil then
			local perm = vim.fn.getfperm(self.path)
			-- local ftype = vim.fn.getftype(self.path)

			if self.is_dir then
				return "d" .. perm
			end

			return perm
		end
	end,
}

local Stats = {
	FileSize,
	Align,
	Space,
	Permissions,
}

local NeoTreeStatusLine = {
	init = function(self)
		local state = require("neo-tree.sources.manager").get_state("filesystem")
		if state.tree ~= nil then
			-- get_node() calls nui's get_node function. When toggling neo-tree on for any number of times after the first time,
			-- the previous neo-tree bufnr is passed to vim.fn.win_findbuf(bufnr), which no longer exists
			-- this throws an error but we simply ignore it with a pcall because it still works
			local success, node = pcall(function()
				return state.tree:get_node()
			end)

			if success then
				self.path = node.path
				if vim.fn.getftype(self.path) == "dir" then
					self.is_dir = true
				else
					self.is_dir = false
				end
			end
		end
	end,

	condition = function()
		return conditions.buffer_matches({
			filetype = { "neo%-tree" },
		})
	end,

	-- child components
	ViMode,
	Space,
	Stats,
	Space,

	{
		init = function(self)
			self.filename = self.path
		end,
		hl = { fg = "bkg", bg = "file_name_bkg" },

		-- child components
		{ hl = { fg = "file_name_bkg", bg = "bkg" }, LeftSepRound },
		Space,
		{
			fallthrough = false,

			-- child components
			-- if item in neo-tree is directory, display folder icon, otherwise use FileIcon component
			{
				condition = function(self)
					return self.is_dir
				end,
				provider = icons.Folder .. " ",
			},
			FileIcon,
		},
		FileName,
		Space,
		{ provider = "%<" }, -- this means that the statusline is cut here when there's not enough space
	},
	{ flexible = priority.WorkDir, WorkDirNameBlock, Null }, -- flexible component - make working directory contract to nothing
}

M.StatusLines = {

	hl = function()
		if conditions.is_active() then
			return { fg = "light_text", bg = "bkg" }
		else
			return { fg = "light_text", bg = "bkg" }
		end
	end,

	-- the first statusline with no condition, or which condition returns true is used.
	-- think of it as a switch case with breaks to stop fallthrough.
	fallthrough = false,

	NeoTreeStatusLine,
	TerminalStatusline,
	DefaultStatusline,
}

return M
