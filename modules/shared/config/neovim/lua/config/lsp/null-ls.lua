local null_ls = require "null-ls"
if not null_ls then
  return
end

null_ls.setup {
  sources = {

    -- javascript/typescript
    null_ls.builtins.code_actions.eslint_d,
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.formatting.prettier,

    -- python
    null_ls.builtins.diagnostics.ruff,
    null_ls.builtins.diagnostics.mypy,
    null_ls.builtins.formatting.black,

    -- lua
    null_ls.builtins.formatting.stylua,

    -- git
    null_ls.builtins.code_actions.gitsigns,
  },
  on_attach = function(client, bufnr)
    require("lsp-format").on_attach(client)
  end,
}
