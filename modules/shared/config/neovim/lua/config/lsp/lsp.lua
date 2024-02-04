-- local mason_lsp = prequire "mason-lspconfig"
-- local lsp = prequire "lspconfig"

-- if not mason_lsp then
--   return
-- end

-- local lspUtils = require "config.lsp.lsp_utils"

-- mason_lsp.setup {
--   ensure_installed = {
--     "lua_ls",
--     "tsserver",
--     "jsonls",
--     "pyright",
--   },
--   automatic_installation = true,
-- }

-- mason_lsp.setup_handlers {
--   function(server_name)
--     lsp[server_name].setup {
--       on_attach = lspUtils.on_attach,
--       capabilities = lspUtils.capabilities,
--       handlers = lspUtils.handlers,
--     }
--   end,
-- }



local lsp = prequire 'lsp-zero'

local lsp_zero_config = {
    call_servers = 'global',
}

local lsp_servers = {
    'lua_ls',
}

local lua_ls_config = {
    settings = {
        Lua = {
            diagnostics = {globals = {'vim'}},
            runtime = {version = 'LuaJIT'},
            telemetry = {enable = false},
        },
    },
}

local function on_attach(_, bufnr)
	-- omitted for brevity
end

local diagnostics_config = {
	-- omitted for brevity
}


lsp.set_preferences(lsp_zero_config)

lsp.configure('lua_ls', lua_ls_config)

lsp.setup_servers(lsp_servers)
lsp.on_attach(on_attach)
lsp.setup()

vim.diagnostic.config(diagnostics_config)