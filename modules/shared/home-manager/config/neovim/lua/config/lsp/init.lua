local lsp = require("lspconfig")
local lsp_utils = require("config.lsp.lsp_utils")
-- local on_attach = require("plugins.lsp.on_attach")

-- Rust/Flutter/LTeX are configured in
-- their respective plugins.
local servers = {
	--   "bashls",
	--   "ccls",
	--   "cssls",
	"efm",
	--   "elixirls",
	--   "emmet_ls",
	--   "eslint",
	--   "gopls",
	--   "graphql",
	--   "html",
	"lua_ls",
	--   "nickel_ls",
	--   "nil_ls",
	--   "prismals",
	"pyright",
	"ruff",
	--   "svelte",
	--   "tsserver",
	--   "vala_ls",
	--   "zls",
}

local efm_sources = {
	formatters = {
		asmfmt = { formatCommand = "asmfmt", formatStdin = true },
		black = {
			formatCommand = "black --no-color -q -",
			formatStdin = true,
			rootMarkers = { "pyproject.toml", "requirements.txt", ".git" },
		},
		prettier = {
			formatCanRange = true,
			formatCommand = "prettier --stdin --stdin-filepath ${INPUT} ${--range-start:charStart} "
				.. "${--range-end:charEnd} ${--tab-width:tabSize} ${--use-tabs:!insertSpaces}",
			formatStdin = true,
			rootMarkers = {
				".prettierrc",
				".prettierrc.json",
				".prettierrc.js",
				".prettierrc.yml",
				".prettierrc.yaml",
				".prettierrc.json5",
				".prettierrc.mjs",
				".prettierrc.cjs",
				".prettierrc.toml",
				"prettier.config.js",
				"prettier.config.cjs",
				"package.json",
			},
		},
		shfmt = { formatCommand = "shfmt -filename ${INPUT} -", formatStdin = true },
		shellharden = { formatCommand = "shellharden --transform ''", formatStdin = true },
		stylua = {
			formatCanRange = true,
			formatCommand = "stylua --color Never ${--range-start:charStart} ${--range-end:charEnd} -",
			formatStdin = true,
		},
	},

	diagnostics = {
		cppcheck = {
			lintCommand = "cppcheck --quiet --force --enable=warning,style,performance,portability --error-exitcode=1 ${INPUT}",
			lintFormats = { "%f:%l:%c: %trror: %m", "%f:%l:%c: %tarning: %m", "%f:%l:%c: %tote: %m" },
			rootMarkers = { "CmakeLists.txt", "compile_commands.json", ".git" },
			lintStdin = false,
			prefix = "cppcheck",
		},
		credo = {
			lintCategoryMap = { R = "N", D = "I", F = "E", W = "W" },
			lintCommand = "mix credo suggest --format=flycheck --read-from-stdin ${INPUT}",
			lintFormats = { "%f:%l:%c: %t: %m", "%f:%l: %t: %m" },
			lintStdin = true,
			prefix = "credo",
			rootMarkers = { "mix.lock", "mix.exs" },
		},
		editorconfig_checker = {
			lintCategoryMap = { ["	"] = "N" },
			lintCommand = "editorconfig-checker -no-color",
			lintFormats = { "%t%l: %m" },
			lintStdin = false,
			prefix = "editorconfig",
			rootMarkers = { ".editorconfig" },
		},
		gitlint = {
			lintCommand = "gitlint",
			lintFormats = { '%l: %m: "%r"', "%l: %m" },
			lintStdin = true,
			prefix = "gitlint",
		},
		statix = {
			lintCommand = "statix check --stdin --format=errfmt",
			lintStdin = true,
			prefix = "statix",
		},
	},
}

local server_configs = {
	lua_ls = {
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
				},
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
					checkThirdParty = false,
				},
				telemetry = {
					enable = false,
				},
				format = {
					enable = false,
				},
			},
		},
	},
	pyright = {
		settings = {
			python = {
				-- Use the locally available python executable. Enables using pyright from an activated venv.
				-- pythonPath = vim.fn.exepath("python"),
				venvPath = vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV or vim.env.PYENV_ROOT,
			},
		},
	},
	ruff = {
		init_options = {
			settings = {
				logLevel = "info", -- Change to "debug" if you want verbose logging
			},
		},
	},
	gopls = {
		settings = {
			gopls = {
				gofumpt = true,
				analyses = {
					composites = false,
					structtag = false,
				},
			},
		},
	},
	html = {
		settings = {
			html = {
				format = {
					templating = true,
					wrapLineLength = 120,
					wrapAttributes = "auto",
				},
				hover = {
					documentation = true,
					references = true,
				},
			},
		},
		init_options = {
			provideFormatter = false,
		},
	},
	dartls = {
		on_attach = function(client, bufnr)
			lsp_utils.on_attach(client, bufnr)
			---@diagnostic disable-next-line: undefined-field
			client.settings.dart.lineLength = tonumber(vim.b.editorconfig.max_line_length) or 80
		end,
	},
	nil_ls = {
		settings = {
			["nil"] = {
				nix = {
					flake = {
						autoArchive = true,
					},
				},
				formatting = {
					-- I prefer using alejandra for my own code, but also
					-- use nixpkgs-fmt in some codebases and in nixpkgs,
					-- so I switch it based on an environment variable.
					command = vim.env.USE_NIXPKGS_FMT == "1" and { "nixpkgs-fmt" } or { "alejandra" },
				},
			},
		},
		on_attach = function(client, bufnr)
			lsp_utils.on_attach(client, bufnr)
			client.server_capabilities.semanticTokensProvider = nil
		end,
	},
	efm = {
		init_options = { documentFormatting = true },
		on_attach = function(client, bufnr)
			lsp_utils.on_attach(client, bufnr)
			-- ccls is UTF-32 only, and that gives me a SUPER annoying error message.
			-- I need to change the encoding prevent this warning madness.
			local filetypes_to_change = require("lspconfig").ccls.document_config.default_config.filetypes
			local current_filetype = vim.bo.filetype
			for _, filetype in ipairs(filetypes_to_change) do
				if filetype == current_filetype then
					client.offset_encoding = "utf-32"
				end
			end
		end,
		settings = {
			rootMarkers = { ".git/" },
			languages = {
				asm = { efm_sources.formatters.asmfmt },
				c = { efm_sources.diagnostics.cppcheck },
				cpp = { efm_sources.diagnostics.cppcheck },
				css = { efm_sources.formatters.prettier },
				gitcommit = { efm_sources.diagnostics.gitlint },
				graphql = { efm_sources.formatters.prettier },
				handlebars = { efm_sources.formatters.prettier },
				html = { efm_sources.formatters.prettier },
				javascript = { efm_sources.formatters.prettier },
				javascriptreact = { efm_sources.formatters.prettier },
				json = { efm_sources.formatters.prettier },
				jsonc = { efm_sources.formatters.prettier },
				less = { efm_sources.formatters.prettier },
				lua = { efm_sources.formatters.stylua },
				markdown = {
					efm_sources.diagnostics.alex,
					efm_sources.diagnostics.markdownlint,
					efm_sources.formatters.prettier,
				},
				["markdown.mdx"] = { efm_sources.formatters.prettier },
				nix = { efm_sources.diagnostics.statix },
				python = {
					efm_sources.diagnostics.mypy,
					efm_sources.formatters.black,
				},
				scss = { efm_sources.formatters.prettier },
				sh = {
					efm_sources.formatters.shfmt,
					efm_sources.formatters.shellharden,
				},
				typescript = { efm_sources.formatters.prettier },
				typescriptreact = { efm_sources.formatters.prettier },
				yaml = { efm_sources.formatters.prettier },
				["="] = { efm_sources.diagnostics.editorconfig_checker },
			},
		},
	},
}

-- Prevent quickfix list from popping up when attempting to
-- format Zig files if there are errors
vim.g.zig_fmt_parse_errors = 0

require("neodev").setup({
	library = {
		enabled = true,
		runtime = true,
		types = true,
		plugins = true,
	},
	lspconfig = true,
})

for _, server in pairs(servers) do
	---@type table<string, boolean|function|table>
	local config = {
		on_attach = lsp_utils.on_attach,
		capabilities = lsp_utils.lsp_default_capabilities(),
	}

	if server_configs[server] ~= nil then
		for key, value in pairs(server_configs[server]) do
			config[key] = value
		end
	end

	lsp[server].setup(config)
end
