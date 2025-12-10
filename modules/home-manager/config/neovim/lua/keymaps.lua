local wk = require("which-key")
local utils = require("utils")
local feedkeys, feedkeys_count = utils.feedkeys, utils.feedkeys_count
local bo, o, wo, v, fn = vim.bo, vim.o, vim.wo, vim.v, vim.fn

vim.o.timeoutlen = 300

wk.add({})

wk.add({
	{ ";", ":", desc = "Enter command mode", silent = false },

	-- Smart-splits cursor movement (keeping your custom layout)
	{
		"<A-n>",
		function()
			require("smart-splits").move_cursor_left()
		end,
		desc = "Move cursor left",
	},
	{
		"<A-i>",
		function()
			require("smart-splits").move_cursor_right()
		end,
		desc = "Move cursor right",
	},
	{
		"<A-u>",
		function()
			require("smart-splits").move_cursor_up()
		end,
		desc = "Move cursor up",
	},
	{
		"<A-e>",
		function()
			require("smart-splits").move_cursor_down()
		end,
		desc = "Move cursor down",
	},

	-- Smart-splits resizing (using Shift + your movement keys)
	{
		"<S-A-n>",
		function()
			require("smart-splits").resize_left()
		end,
		desc = "Resize split left",
	},
	{
		"<S-A-i>",
		function()
			require("smart-splits").resize_right()
		end,
		desc = "Resize split right",
	},
	{
		"<S-A-u>",
		function()
			require("smart-splits").resize_up()
		end,
		desc = "Resize split up",
	},
	{
		"<S-A-e>",
		function()
			require("smart-splits").resize_down()
		end,
		desc = "Resize split down",
	},

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

	-- Line movement with Alt + Arrow keys
	{ "<A-Up>", ":m .-2<CR>==", desc = "Move line up", mode = "n" },
	{ "<A-Down>", ":m .+1<CR>==", desc = "Move line down", mode = "n" },
	{ "<A-Up>", ":m '<-2<CR>gv=gv", desc = "Move line up", mode = "v" },
	{ "<A-Down>", ":m '>+1<CR>gv=gv", desc = "Move line down", mode = "v" },

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

	-- Smart-splits buffer swapping (using your custom layout)
	{
		"<leader>wn",
		function()
			require("smart-splits").swap_buf_left()
		end,
		desc = "Swap buffer left",
	},
	{
		"<leader>wi",
		function()
			require("smart-splits").swap_buf_right()
		end,
		desc = "Swap buffer right",
	},
	{
		"<leader>wu",
		function()
			require("smart-splits").swap_buf_up()
		end,
		desc = "Swap buffer up",
	},
	{
		"<leader>we",
		function()
			require("smart-splits").swap_buf_down()
		end,
		desc = "Swap buffer down",
	},

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
