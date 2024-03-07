local wk = require("which-key")
local utils = require("utils")

vim.o.timeoutlen = 300

wk.setup({
	show_help = false,
	triggers = "auto",
	plugins = { spelling = true },
	key_labels = { ["<leader>"] = "SPC" },
})

-- set ; to enter command mode
vim.keymap.set("n", ";", ":", { noremap = true })

-- move between NeoVim and Wezterm panes via smart-splits.nvim
vim.keymap.set("n", "<C-h>", "<cmd>SmartCursorMoveLeft<CR>", { desc = "move cursor left" })
vim.keymap.set("n", "<C-l>", "<cmd>SmartCursorMoveRight<CR>", { desc = "move cursor right" })
vim.keymap.set("n", "<C-k>", "<cmd>SmartCursorMoveUp<CR>", { desc = "move cursor up" })
vim.keymap.set("n", "<C-j>", "<cmd>SmartCursorMoveDown<CR>", { desc = "move cursor down" })
vim.keymap.set("n", "<C-a>r", "<cmd>SmartResizeMode<CR>", { desc = "resize split" })

-- go to first non-empty char of current line
vim.keymap.set("n", "H", "^", { desc = "go to first non-empty char of current line" })
-- to to last non-empty char of current line
vim.keymap.set("n", "L", ":normal! g_<CR>", { desc = "go to last non-empty char of current line" })

-- -- Better window navigation
-- vim.keymap.set("n", "<C-j>", "<C-w>j")
-- vim.keymap.set("n", "<C-k>", "<C-w>k")
-- vim.keymap.set("n", "<C-h>", "<C-w>h")
-- vim.keymap.set("n", "<C-l>", "<C-w>l")

-- -- Resize window using <Shift+> arrow keys
-- vim.keymap.set("n", "<S-Up>", "<CMD>resize +2<CR>")
-- vim.keymap.set("n", "<S-Down>", "<CMD>resize -2<CR>")
-- vim.keymap.set("n", "<S-Left>", "<CMD>vertical resize -2<CR>")
-- vim.keymap.set("n", "<S-Right>", "<CMD>vertical resize +2<CR>")

-- Switch buffers with tab
vim.keymap.set("n", "<S-TAB>", "<CMD>bprevious<CR>")
vim.keymap.set("n", "<TAB>", "<CMD>bnext<CR>")

-- Clear search with <esc>
vim.keymap.set({ "i", "n" }, "<esc>", "<CMD>noh<CR><esc>")
vim.keymap.set("n", "gw", "*N")
vim.keymap.set("x", "gw", "*N")

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set("n", "n", "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set("n", "N", "'nN'[v:searchforward]", { expr = true })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true })

-- save in insert mode
vim.keymap.set("i", "<C-s>", "<CMD>:w<CR><esc>")
-- save in normal mode
vim.keymap.set("n", "<C-s>", "<CMD>:w<CR><esc>")

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- copy whole file
vim.keymap.set("n", "<C-c>", "<cmd> %y+ <CR>")

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
		i = { "<CMD>Mason<CR>", "manage servers" },
		l = { "<CMD>MasonLog<CR>", "see logs" },
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

