local wk = require("which-key")
local utils = require("utils")
local feedkeys, feedkeys_count = utils.feedkeys, utils.feedkeys_count
local bo, o, wo, v, fn = vim.bo, vim.o, vim.wo, vim.v, vim.fn

vim.o.timeoutlen = 300

wk.add({})

wk.add({
	{ ";", ":", desc = "Enter command mode", silent = false },

	{ "<C-n>", "<cmd>SmartCursorMoveLeft<CR>", desc = "Move cursor left" },
	{ "<C-i>", "<cmd>SmartCursorMoveRight<CR>", desc = "Move cursor right" },
	{ "<C-u>", "<cmd>SmartCursorMoveUp<CR>", desc = "Move cursor up" },
	{ "<C-e>", "<cmd>SmartCursorMoveDown<CR>", desc = "Move cursor down" },
	{ "<C-a>r", "<cmd>SmartResizeMode<CR>", desc = "Resize split" },

	{ "H", "^", desc = "Go to first non-empty char of current line" },
	{ "L", ":normal! g_<CR>", desc = "Go to last non-empty char of current line" },
	{ "<S-TAB>", "<CMD>bprevious<CR>", desc = "Previous buffer" },
	{ "<TAB>", "<CMD>bnext<CR>", desc = "Next buffer" },
	{
		"<Esc>",
		function()
			if vim.v.hlsearch == 1 then
				vim.cmd.nohlsearch()
			elseif bo.modifiable then
				utils.clear_lsp_references()
			elseif #vim.api.nvim_list_wins() > 1 then
				return feedkeys("<C-w>c")
			end
			utils.close_floating_windows()
		end,
		desc = "Close window if not modifiable, otherwise clear LSP references",
	},

	{ "\\", "<C-W>v", desc = "Split window right" },
	{ "-", "<C-W>s", desc = "Split window below" },

	{ "<C-q>", ":qa<CR>", desc = "Quit all windows", mode = { "n", "v" } },
	{ "gw", "*N", desc = "Search word under cursor", mode = { "n", "x" } },
	{ "//", 'omsy/<C-R>"<CR>`s', desc = "Search selected text", mode = "x" },
	{ "n", "'Nn'[v:searchforward]", desc = "Saner n", mode = { "n", "x", "o" }, expr = true },
	{ "N", "'nN'[v:searchforward]", desc = "Saner N", mode = { "n", "x", "o" }, expr = true },
	{ "<C-s>", "<CMD>:w<CR><esc>", desc = "Save file", mode = { "i", "n" } },
	{ "<", "<gv", desc = "Better indenting", mode = "v" },
	{ ">", ">gv", desc = "Better indenting", mode = "v" },
	{ "<C-c>", "<cmd> %y+ <CR>", desc = "Copy whole file", mode = "n" },
	{ "<A-j>", ":m .+1<CR>==", desc = "Move line down", mode = "n" },
	{ "<A-k>", ":m .-2<CR>==", desc = "Move line up", mode = "n" },
	{ "<A-j>", ":m '>+1<CR>gv=gv", desc = "Move line down", mode = "v" },
	{ "<A-k>", ":m '<-2<CR>gv=gv", desc = "Move line up", mode = "v" },

	{ "<leader>b", group = "Buffer" },
	{ "<leader>bx", "<CMD>:bd<CR>", desc = "Delete current buffer & window" },
	{ "<leader>bc", "<CMD>:%bd|e#|bd#<CR>", desc = "Delete all buffers but current" },

	{ "<leader>d", group = "Debugging" },
	{
		"<leader>db",
		"<CMD>lua require('persistent-breakpoints.api').toggle_breakpoint()<CR>",
		desc = "Toggle breakpoint",
	},
	{
		"<leader>dx",
		"<CMD>lua require('persistent-breakpoints.api').clear_all_breakpoints()<CR>",
		desc = "Clear all breakpoints",
	},
	{
		"<leader>ds",
		"<CMD>lua require('persistent-breakpoints.api').set_conditional_breakpoint()<CR>",
		desc = "Set conditional breakpoints",
	},
	{ "<leader>dc", "<CMD>lua require('dap').continue()<CR>", desc = "Start/Continue" },
	{ "<leader>dr", "<CMD>lua require('dap').repl.open()<CR>", desc = "Open REPL" },
	{ "<leader>do", "<CMD>lua require('dap').step_over()<CR>", desc = "Step over" },
	{ "<leader>di", "<CMD>lua require('dap').step_into()<CR>", desc = "Step into" },
	{ "<leader>de", "<CMD>lua require('dap').step_out()<CR>", desc = "Step out" },
	{ "<leader>dd", "<CMD>lua require('dap').disconnect()<CR>", desc = "Disconnect" },

	{ "<leader>f", group = "File" },
	{ "<leader>ff", "<CMD>lua require('telescope').extensions.menufacture.find_files()<CR>", desc = "Find file" },
	{ "<leader>fr", "<CMD>Telescope oldfiles<CR>", desc = "Open recent file" },
	{ "<leader>fn", "<CMD>enew<CR>", desc = "New file" },

	{ "<leader>g", group = "Git" },
	{ "<leader>gc", "<CMD>Telescope git_commits<CR>", desc = "Commits" },
	{ "<leader>gb", "<CMD>lua require('gitsigns').blame_line{full=false}<CR>", desc = "Blame" },
	{ "<leader>gs", "<CMD>Telescope git_status<CR>", desc = "Status" },

	{ "<leader>c", group = "Code" },

	{
		"<leader>lt",
		function()
			require("aerial").toggle()
		end,
		desc = "Toggle symbols outline",
	},
	{
		"<leader>ls",
		function()
			require("telescope").extensions.aerial.aerial()
		end,
		desc = "Search document symbols",
	},

	{ "<leader>p", group = "Pick" },
	{ "<leader>pt", "<CMD>Telescope toggleterm_manager<CR>", desc = "Pick Terminal" },

	{ "<leader>w", group = "Window" },
	{ "<leader>ww", "<C-W>p", desc = "Other window" },
	{ "<leader>wd", "<C-W>c", desc = "Delete window" },
	{ "<leader>w-", "<C-W>s", desc = "Split window below" },
	{ "<leader>w|", "<C-W>v", desc = "Split window right" },
	{ "<leader>w2", "<C-W>v", desc = "Layout double columns" },
	{ "<leader>wh", "<C-W>h", desc = "Window left" },
	{ "<leader>wj", "<C-W>j", desc = "Window below" },
	{ "<leader>wk", "<C-W>k", desc = "Window up" },
	{ "<leader>wl", "<C-W>l", desc = "Window right" },

	{ "<leader>h", group = "Help" },
	{ "<leader>hp", group = "Package Management" },
	{ "<leader>hpi", "<CMD>Lazy install<CR>", desc = "Install packages" },
	{ "<leader>hpu", "<CMD>Lazy update<CR>", desc = "Update packages" },
	{ "<leader>hpc", "<CMD>Lazy clear<CR>", desc = "Clear unused" },
	{ "<leader>hps", "<CMD>Lazy sync<CR>", desc = "Sync all" },
	{ "<leader>hh", "<CMD>:checkhealth<CR>", desc = "Check health" },
	{ "<leader>hc", "<CMD>:Telescope commands<CR>", desc = "Commands" },
	{ "<leader>hs", "<CMD>:Telescope highlights<CR>", desc = "Search highlight groups" },

	{ "<leader>s", group = "Search" },
	{ "<leader>sg", "<CMD>lua require('telescope').extensions.menufacture.live_grep()<CR>", desc = "Grep" },
	{ "<leader>sb", "<CMD>Telescope current_buffer_fuzzy_find<CR>", desc = "Buffer" },
	{ "<leader>sm", "<CMD>Telescope marks<CR>", desc = "Jump to Mark" },

	{ "<leader>x", group = "Diagnostics" },
	{
		"<leader>xx",
		function()
			require("trouble").toggle()
		end,
		desc = "Toggle diagnostics window",
	},
	{
		"<leader>xw",
		function()
			require("trouble").open("workspace_diagnostics")
		end,
		desc = "Workspace diagnostics",
	},
	{
		"<leader>xd",
		function()
			require("trouble").open("document_diagnostics")
		end,
		desc = "Document diagnostics",
	},
	{
		"<leader>xq",
		function()
			require("trouble").open("quickfix")
		end,
		desc = "Quickfix",
	},
	{
		"<leader>xl",
		function()
			require("trouble").open("loclist")
		end,
		desc = "Loclist",
	},
	{
		"<leader>xr",
		function()
			require("trouble").open("lsp_references")
		end,
		desc = "References of word",
	},
	{
		"<leader>xD",
		function()
			require("trouble").open("lsp_definitions")
		end,
		desc = "Definitions of word",
	},
})

wk.add({
	mode = { "v" },
	-- { "<leader>pt", "<CMD>Telescope toggleterm_manager<CR>", desc = "Pick Terminal" },
})

-- wk.register({ g = { name = "+goto" } })
