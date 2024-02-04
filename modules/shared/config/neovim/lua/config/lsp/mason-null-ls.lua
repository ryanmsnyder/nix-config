local mason_null_ls = require "mason-null-ls"
if not mason_null_ls then
  return
end

mason_null_ls.setup {
  ensure_installed = nil,
  automatic_installation = true,
}
