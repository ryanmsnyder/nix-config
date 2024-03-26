local wk = require("which-key")
local utils = require("utils")
local icons = require("icons.icons")
local lsp = require("lspconfig")

local M = {}

-- keep outside of autoformat_on_save function
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- autoformats on save by running any formatters that are attached to the buffer
local function autoformat_on_save(client, bufnr)
	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({ bufnr = bufnr })
			end,
		})
	end
end

function M.on_attach(client, bufnr)
	-- autoformat buffer on save
	autoformat_on_save(client, bufnr)

	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	M.set_keys(client, bufnr)
end

--- Create the default capabilities to use for LSP server configuration.
---@return lsp.ClientCapabilities
function M.lsp_default_capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

	-- [Additional capabilities customization]
	-- Large workspace scanning may freeze the UI; see https://github.com/neovim/neovim/issues/23291
	if vim.fn.has("nvim-0.9") > 0 then
		-- enable neovim LSP file watching so LSP servers can respond to file watching events
		-- this is needed when installing new packages to projects, otherwise NeoVim or the LSP would need to be restarted
		-- to detect the added packages
		capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
	end

	-- related to nvim-ufo
	capabilities.textDocument.foldingRange = {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	}
	-- print(vim.inspect(capabilities))

	-- Use default vim.lsp capabilities and apply some tweaks on capabilities.completion for nvim-cmp
	capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities()) --[[@as lsp.ClientCapabilities]]

	return capabilities
end

function M.format()
	vim.lsp.buf.format()
end

function M.set_keys(client, buffer)
	local cap = client.server_capabilities

	local keymap = {
		buffer = buffer,
		["<leader>"] = {
			l = {
				name = "+lsp",
				-- s = { vim.lsp.buf.signature_help, "LSP signature help", mode = { "n" } },
			},
			j = {
				name = "+goto",
				D = { vim.lsp.buf.declaration, "declaration" },
				d = { vim.lsp.buf.definition, "definition" },
				r = { vim.lsp.buf.references, "find references" },
				i = { vim.lsp.buf.implementation, "implementation" },
				t = { vim.lsp.buf.type_definition, "type definition" },
			},
			c = {
				name = "+code",
				t = { utils.toggle_diagnostics, "toggle diagnostics" },
				r = { vim.lsp.buf.rename, "rename" },
				a = {
					{ vim.lsp.buf.code_action, "code action" },
					{ vim.lsp.buf.code_action, "code action", mode = "v" },
				},
				f = {
					{
						M.format,
						"format document",
						cond = cap.documentFormatting,
					},
					{
						M.format,
						"format range",
						cond = cap.documentRangeFormatting,
						mode = "v",
					},
				},
				d = { vim.diagnostic.open_float, "line diagnostics" },
			},
		},
		-- ["<C-k>"] = { vim.lsp.buf.signature_help, "LSP signature help", mode = { "n", "i" } },
		["K"] = { vim.lsp.buf.hover, "LSP hover" },
		["[d"] = { vim.diagnostic.goto_prev, "next diagnostic" },
		["]d"] = { vim.diagnostic.goto_next, "prev diagnostic" },
	}

	wk.register(keymap)
end

-- TODO: it doesn't look like this is getting accessed anywhere
M.handlers = {
	["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = false,
		signs = true,
		update_in_insert = false,
		underline = true,
		severity_sort = true,
		code_action_icon = icons.Hint,
		float = {
			focusable = false,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}),

	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	}),

	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	}),

	-- ["textDocument/foldingRange"] = vim.lsp.with(vim.lsp.handlers.foldingRange({
	-- 	dynamicRegistration = false,
	-- 	lineFoldingOnly = true,
	-- })),
}

return M
