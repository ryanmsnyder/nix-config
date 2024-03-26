local wk = require("which-key")
local utils = require("utils")
local map = utils.map
local feedkeys, feedkeys_count = utils.feedkeys, utils.feedkeys_count
local bo, o, wo, v, fn = vim.bo, vim.o, vim.wo, vim.v, vim.fn

vim.o.timeoutlen = 300

wk.setup({
	show_help = false,
	triggers = "auto",
	plugins = { spelling = true },
	key_labels = { ["<leader>"] = "SPC" },
})

-- set ; to enter command mode
-- set silent to false so the colon appears in the command line area when the semicolon is pressed
map("n", ";", ":", { silent = false })

-- move between NeoVim and Wezterm panes via smart-splits.nvim
map("n", "<C-h>", "<cmd>SmartCursorMoveLeft<CR>", { desc = "move cursor left" })
map("n", "<C-l>", "<cmd>SmartCursorMoveRight<CR>", { desc = "move cursor right" })
map("n", "<C-k>", "<cmd>SmartCursorMoveUp<CR>", { desc = "move cursor up" })
map("n", "<C-j>", "<cmd>SmartCursorMoveDown<CR>", { desc = "move cursor down" })
map("n", "<C-a>r", "<cmd>SmartResizeMode<CR>", { desc = "resize split" })

-- go to first non-empty char of current line
map("n", "H", "^", { desc = "go to first non-empty char of current line" })
-- to to last non-empty char of current line
map("n", "L", ":normal! g_<CR>", { desc = "go to last non-empty char of current line" })

-- -- Better window navigation
-- map("n", "<C-j>", "<C-w>j")
-- map("n", "<C-k>", "<C-w>k")
-- map("n", "<C-h>", "<C-w>h")
-- map("n", "<C-l>", "<C-w>l")

-- -- Resize window using <Shift+> arrow keys
-- map("n", "<S-Up>", "<CMD>resize +2<CR>")
-- map("n", "<S-Down>", "<CMD>resize -2<CR>")
-- map("n", "<S-Left>", "<CMD>vertical resize -2<CR>")
-- map("n", "<S-Right>", "<CMD>vertical resize +2<CR>")

-- Switch buffers with tab
map("n", "<S-TAB>", "<CMD>bprevious<CR>")
map("n", "<TAB>", "<CMD>bnext<CR>")

-- Clear search with <esc>
map("n", "<Esc>", function()
	if vim.v.hlsearch == 1 then
		vim.cmd.nohlsearch()
	elseif bo.modifiable then
		utils.clear_lsp_references()
	elseif #vim.api.nvim_list_wins() > 1 then
		return feedkeys("<C-w>c")
	end

	utils.close_floating_windows()
end, "Close window if not modifiable, otherwise clear LSP references")

-- in normal and visual modes quits all opened windows with
map({ "n", "v" }, "<C-q>", ":qa<CR>")

-- search word under cursor
map("n", "gw", "*N", { desc = "Search word under cursor" })
map("x", "gw", "*N", { desc = "Search word under cursor" })

-- search for selected text in visual mode
map("x", "//", 'omsy/<C-R>"<CR>`s')

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward]", { expr = true })
map("x", "n", "'Nn'[v:searchforward]", { expr = true })
map("o", "n", "'Nn'[v:searchforward]", { expr = true })
map("n", "N", "'nN'[v:searchforward]", { expr = true })
map("x", "N", "'nN'[v:searchforward]", { expr = true })
map("o", "N", "'nN'[v:searchforward]", { expr = true })

-- save in insert mode
map("i", "<C-s>", "<CMD>:w<CR><esc>")
-- save in normal mode
map("n", "<C-s>", "<CMD>:w<CR><esc>")

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- copy whole file
map("n", "<C-c>", "<cmd> %y+ <CR>")

-- move line up or down
map("n", "<A-j>", ":m .+1<CR>==") -- move line up(n)
map("n", "<A-k>", ":m .-2<CR>==") -- move line down(n)
map("v", "<A-j>", ":m '>+1<CR>gv=gv") -- move line up(v)
map("v", "<A-k>", ":m '<-2<CR>gv=gv") -- move line down(v)

-- save current TelescopeResultsTitle highlights to global variable before changing its color
-- for Telescope command_history (to display keybindings)
local function SetTelescopeResultsTitle()
	local text = vim.api.nvim_get_hl_by_name("Character", true).foreground
	local bkg = vim.api.nvim_get_hl_by_name("Normal", true).background
	vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { bg = bkg, fg = text })
	vim.cmd("Telescope command_history results_title=C-e:\\ Edit\\ command\\ \\ Enter:\\ Execute\\ command")
end

local leader = {
	["\\"] = { "<C-W>v", "split-window-right" },
	["-"] = { "<C-W>s", "split-window-below" },
	g = {
		name = "+git",
		c = { "<CMD>Telescope git_commits<CR>", "commits" },
		b = { "<CMD>lua require('gitsigns').blame_line{full=false}<CR>", "blame" },
		s = { "<CMD>Telescope git_status<CR>", "status" },
	},
	c = {
		name = "+code",
	},
	l = {
		name = "+lsp",
		t = {
			function()
				require("aerial").toggle()
			end,
			"toggle symbols outline",
		},
		s = {
			function()
				require("telescope").extensions.aerial.aerial()
			end,
			"search document symbols",
		},
	},
	w = {
		name = "+window",
		["w"] = { "<C-W>p", "other-window" },
		["d"] = { "<C-W>c", "delete-window" },
		["-"] = { "<C-W>s", "split-window-below" },
		["|"] = { "<C-W>v", "split-window-right" },
		["2"] = { "<C-W>v", "layout-double-columns" },
		["h"] = { "<C-W>h", "window-left" },
		["j"] = { "<C-W>j", "window-below" },
		["l"] = { "<C-W>l", "window-right" },
		["k"] = { "<C-W>k", "window-up" },
		["H"] = { "<C-W>5<", "expand-window-left" },
		["J"] = { ":resize +5", "expand-window-below" },
		["L"] = { "<C-W>5>", "expand-window-right" },
		["K"] = { ":resize -5", "expand-window-up" },
		["="] = { "<C-W>=", "balance-window" },
		["s"] = { "<C-W>s", "split-window-below" },
		["v"] = { "<C-W>v", "split-window-right" },
	},
	h = {
		name = "+help",
		p = {
			name = "+package-management",
			i = { "<CMD>Lazy install<CR>", "install packages" },
			u = { "<CMD>Lazy update<CR>", "update packages" },
			c = { "<CMD>Lazy clear<CR>", "clear unused" },
			s = { "<CMD>Lazy sync<CR>", "sync all" },
		},
		h = { "<CMD>:checkhealth<CR>", "check health" },
		c = { "<CMD>:Telescope commands<CR>", "commands" },
		s = { "<CMD>:Telescope highlights<CR>", "search highlight groups" },
	},
	s = {
		name = "+search",
		g = { "<CMD>lua require('telescope').extensions.menufacture.live_grep()<CR>", "grep" },
		b = { "<CMD>Telescope current_buffer_fuzzy_find<CR>", "buffer" },
		s = {
			function()
				require("telescope.builtin").lsp_document_symbols({
					symbols = {
						"Class",
						"Function",
						"Method",
						"Constructor",
						"Interface",
						"Module",
						"Struct",
						"Trait",
						"Field",
						"Property",
					},
				})
			end,
			"Goto Symbol",
		},
		h = {
			-- "<CMD>Telescope command_history results_title=C-e: Edit command, Enter: Execute command <CR>",
			SetTelescopeResultsTitle,
			"command history",
		},
		-- h = {
		--   -- "<CMD>Telescope command_history results_title=C-e: Edit command, Enter: Execute command <CR>",
		--   "<CMD>lua vim.g.telescope_results_hl = vim.api.nvim_get_hl_by_name('TelescopeResultsTitle', true)<CR> <BAR> <CMD>lua vim.api.nvim_set_hl(0, 'TelescopeResultsTitle', { bg = '#000000', fg = '#ffffff' }) <CR> <BAR> <CMD>Telescope command_history results_title=C-e:\\ Edit\\ command\\ \\ Enter:\\ Execute\\ command <CR>",
		--   "command history",
		-- },
		m = { "<CMD>Telescope marks<CR>", "Jump to Mark" },
	},
	p = {
		name = "+pick",
		t = { "<CMD>Telescope toggleterm_manager<CR>", "pick terminal" },
	},
	f = {
		name = "+file",
		f = { "<CMD>lua require('telescope').extensions.menufacture.find_files()<CR>", "find file" },
		r = { "<CMD>Telescope oldfiles<CR>", "open recent file" },
		n = { "<CMD>enew<CR>", "new file" },
	},
	t = {
		name = "+testing",
		f = { "<CMD>lua require('neotest').run.run(vim.fn.expand('%'))<CR>", "test file" },
		o = { "<CMD>lua require('neotest').output.open({enter = true})<CR>", "open output" },
		s = { "<CMD>lua require('neotest').summary.toggle()<CR>", "toggle summary" },
	},
	x = {
		name = "+diagnostics",
		x = {
			function()
				require("trouble").toggle()
			end,
			"toggle diagnostics window",
		},
		w = {
			function()
				require("trouble").open("workspace_diagnostics")
			end,
			"workspace diagnostics",
		},
		d = {
			function()
				require("trouble").open("document_diagnostics")
			end,
			"document diagnostics",
		},
		q = {
			function()
				require("trouble").open("quickfix")
			end,
			"quickfix",
		},
		l = {
			function()
				require("trouble").open("loclist")
			end,
			"loclist",
		},
		r = {
			function()
				require("trouble").open("lsp_references")
			end,
			"references of word",
		},
		D = {
			function()
				require("trouble").open("lsp_definitions")
			end,
			"definitions of word",
		},
	},
	b = {
		name = "+buffer",
		x = { "<CMD>:bd<CR>", "delete current buffer & window" },
		c = { "<CMD>:%bd|e#|bd#<CR>", "delete all buffers but current" },
	},
	d = {
		name = "+debugging",
		b = { "<CMD>lua require('persistent-breakpoints.api').toggle_breakpoint()<CR>", "toggle breakpoint" },
		x = { "<CMD>lua require('persistent-breakpoints.api').clear_all_breakpoints()<CR>", "clear all breakpoints" },
		s = {
			"<CMD>lua require('persistent-breakpoints.api').set_conditional_breakpoint()<CR>",
			"set conditional breakpoints",
		},
		c = { "<CMD>lua require('dap').continue()<CR>", "start/continue" },
		r = { "<CMD>lua require('dap').repl.open()<CR>", "open REPL" },
		o = { "<CMD>lua require('dap').step_over()<CR>", "step over" },
		i = { "<CMD>lua require('dap').step_into()<CR>", "step into" },
		e = { "<CMD>lua require('dap').step_out()<CR>", "step out" },
		d = { "<CMD>lua require('dap').disconnect()<CR>", "disconnect" },
	},
}

wk.register(leader, { prefix = "<leader>" })
wk.register({ g = { name = "+goto" } })
