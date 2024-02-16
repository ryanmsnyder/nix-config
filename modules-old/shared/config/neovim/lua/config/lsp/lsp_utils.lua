local wk = require "which-key"
local utils = require "utils"
local icons = require "icons.icons"

local M = {}


local capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- autoformats on save by running any formatters that are attached to the buffer
local function autoformat_on_save(client, bufnr)
  local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr, async = false })
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
        s = { vim.lsp.buf.signature_help, "LSP signature help", mode = { "n" } },
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
}

return M
