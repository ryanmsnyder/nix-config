return {
	{
		"ryanmsnyder/gruvbox-flat.nvim",
		priority = 1000,
		lazy = false,
		enabled = true,
		-- config = function()
		--   require "config.themes.gruvbox-flat.gruvbox-flat"
		-- end,
	},

	{
		"ryanmsnyder/catppuccin.nvim",
		name = "catppuccin",
		config = function()
			require("config.themes.catppuccin")
		end,
		lazy = false,
		priority = 1000,
	},

	{
		"ryanmsnyder/everforest-nvim",
		version = false,
		lazy = false,
		priority = 1000, -- make sure to load this before all the other start plugins
	},

	{
		"zaldih/themery.nvim",
		lazy = false,
		keys = {
			{ "<leader>ht", "<cmd>Themery<cr>", desc = "Open Theme Switcher" },
		},
		config = function()
			require("config.themery")
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPost",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = true,
	},

	{
		"rebelot/heirline.nvim",
		event = "UiEnter",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"linrongbin16/lsp-progress.nvim",
		},
		config = function()
			require("config.heirline")
		end,
	},

	{
		"linrongbin16/lsp-progress.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("config.lsp_progress")
		end,
	},

	-- {
	--   "j-hui/fidget.nvim",
	--   tag = "legacy",
	--   event = "LspAttach",
	--   config = function()
	--     require "config.fidget"
	--   end,
	--   opts = {
	--     -- options
	--   },
	-- },

	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufReadPost",
		main = "ibl",
		config = function()
			require("config.indent-blankline")
		end,
	},

	{
		"mrjones2014/smart-splits.nvim",
		lazy = false,
		config = function()
			require("config.smart-splits")
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = "BufReadPost",
		cmd = {
			"TSUpdate",
			"TSInstallInfo",
			"TSEnable",
			"TSDisable",
			"TSModuleInfo",
			"TSUninstall",
		},
		config = function()
			require("config.treesitter")
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			{ "molecule-man/telescope-menufacture" },
		},
		cmd = "Telescope",
		opts = {
			pickers = {
				colorscheme = {
					enable_preview = true,
				},
			},
		},
		config = function()
			require("config.telescope")
		end,
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		cmd = "Neotree",
		branch = "v3.x",
		keys = {
			{ "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- for picking a window to a open a file in from neo-tree
			{
				"s1n7ax/nvim-window-picker",
				name = "window-picker",
				event = "VeryLazy",
				version = "2.*",
				opts = {
					hint = "floating-big-letter",
					show_prompt = false,
					filter_rules = {
						include_current_win = false,
						autoselect_one = false,
						-- filter using buffer options
						bo = {
							-- if the file type is one of following, the window will be ignored
							filetype = { "neo-tree", "neo-tree-popup", "notify", "aerial" },
							-- if the buffer type is one of following, the window will be ignored
							buftype = { "terminal", "quickfix" },
						},
					},
				},
			},
		},
		config = function()
			require("config.neo-tree")
		end,
	},

	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "BufEnter",
		config = function()
			require("config.trouble")
		end,
	},

	{
		"neovim/nvim-lspconfig",
		cmd = "LspInfo",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/nvim-cmp",
			"L3MON4D3/LuaSnip",
			"folke/neodev.nvim",
		},
		config = function()
			require("config.lsp")
		end,
	},

	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-cmdline" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{ "saadparwaiz1/cmp_luasnip" },
		},
		config = function()
			require("config.cmp")
		end,
	},

	{
		"mfussenegger/nvim-dap",
		event = "VeryLazy",
		config = function()
			require("config.dap.nvim-dap")
			require("dap.ext.vscode").load_launchjs()
		end,
	},

	{
		"mfussenegger/nvim-dap-python",
		event = "VeryLazy",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
	},

	{
		"rcarriga/nvim-dap-ui",
		event = "VeryLazy",
		lazy = false,
		dependencies = { "nvim-neotest/nvim-nio", "mfussenegger/nvim-dap", "mfussenegger/nvim-dap-python" },
		config = function()
			require("config.dap.nvim-dap-ui")
		end,
	},

	{
		"Weissle/persistent-breakpoints.nvim",
		event = "BufReadPost",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			require("config.dap.persistent-breakpoints")
		end,
	},

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},

	{
		"numToStr/Comment.nvim",
		keys = {
			{ "gcc", mode = "n", desc = "Comment toggle current line" },
			{ "gc", mode = { "n", "o" }, desc = "Comment toggle linewise" },
			{ "gc", mode = "x", desc = "Comment toggle linewise (visual)" },
			{ "gbc", mode = "n", desc = "Comment toggle current block" },
			{ "gb", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
			{ "gb", mode = "x", desc = "Comment toggle blockwise (visual)" },
		},
		config = function()
			require("Comment").setup()
		end,
	},

	-- UFO folding
	{
		"kevinhwang91/nvim-ufo",
		dependencies = {
			"kevinhwang91/promise-async",
			-- {
			-- 	-- Removes repeating line numbers in the status column. Otherwise you need to change NeoVim source code and build from source.
			-- 	"luukvbaal/statuscol.nvim",
			-- 	config = function()
			-- 		local builtin = require("statuscol.builtin")
			-- 		require("statuscol").setup({
			-- 			relculright = true,
			-- 			bt_ignore = {
			-- 				"nofile",
			-- 				"prompt",
			-- 				"terminal",
			-- 				"lazy",
			-- 			},
			-- 			ft_ignore = {
			-- 				"dapui_watches",
			-- 				"dap-repl",
			-- 				"dapui_console",
			-- 				"dapui_stacks",
			-- 				"dapui_breakpoints",
			-- 				"dapui_scopes",
			-- 				"help",
			-- 				"vim",
			-- 				"alpha",
			-- 				"dashboard",
			-- 				"neo-tree",
			-- 				"Trouble",
			-- 				"lazy",
			-- 				"toggleterm",
			-- 			},
			-- 			segments = {
			-- 				{ text = { builtin.foldfunc }, click = "v:lua.ScFa" },
			-- 				{ text = { "%s" }, click = "v:lua.ScSa" },
			-- 				{ text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
			-- 			},
			-- 		})
			-- 	end,
			-- },
		},
		event = "BufReadPost",
		init = function()
			vim.o.foldcolumn = "1"
			vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			-- remove fold column in toggleterm
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "toggleterm" },
				callback = function()
					-- require("ufo").detach()
					-- vim.opt_local.foldenable = false
					vim.wo.foldcolumn = "0"
				end,
			})
		end,
		config = function()
			require("config.nvim-ufo")
		end,
	},

	{
		"stevearc/aerial.nvim",
		opts = {
			attach_mode = "global",
			close_on_select = true,
			highlight_on_hover = true,
			manage_folds = true,
			-- link_folds_to_tree = true,
			-- link_tree_to_folds = true,
			layout = {
				min_width = 30,
				default_direction = "prefer_right",
			},
		},
		-- Optional dependencies
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},

	-- {
	--   "mattn/emmet-vim",
	--   event = "BufReadPost",
	--   ft = {
	--     "typescript",
	--     "typescriptreact",
	--     "javascript",
	--     "javascriptreact",
	--     "html",
	--     "css",
	--   },
	-- },

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		-- config =
		-- init = function()
		-- 	vim.o.timeout = true
		-- 	vim.o.timeoutlen = 300
		-- end,
	},

	-- {
	-- 	"folke/which-key.nvim",
	-- 	event = "VeryLazy",
	-- 	init = function()
	-- 		vim.o.timeout = true
	-- 		vim.o.timeoutlen = 300
	-- 	end,
	-- },

	{ "kevinhwang91/nvim-bqf", ft = "qf" },

	{

		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump({
						search = {
							mode = function(str)
								return "\\<" .. str
							end,
						},
					})
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "o", "x" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
	},

	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("config.nvim-surround")
		end,
	},

	{
		"leath-dub/snipe.nvim",
		keys = {
			{
				"gs",
				function()
					require("snipe").open_buffer_menu()
				end,
				desc = "Open Snipe buffer menu",
			},
		},
		config = function()
			local snipe = require("snipe")
			snipe.setup({
				ui = {
					open_win_override = {
						border = "rounded",
					},
					preselect_current = true,
				},
				hints = { dictionary = "tnseriaoplfuwyq;dhc,x.z?" },
				navigate = {
					cancel_snipe = "<esc>",
					close_buffer = "d",
				},
				sort = "default",
			})
		end,
	},

	{
		"ryanmsnyder/toggleterm.nvim",
		-- dir = "/Users/ryansnyder/code/neovim-plugins/toggleterm.nvim",
		-- "akinsho/toggleterm.nvim",
		branch = "prod",
		keys = {
			{
				"<C-\\>",
			},
		},
		config = function()
			require("config.toggleterm")
		end,
	},

	{
		"ryanmsnyder/toggleterm-manager.nvim",
		config = function()
			require("config.toggleterm-manager")
		end,
	},
}
