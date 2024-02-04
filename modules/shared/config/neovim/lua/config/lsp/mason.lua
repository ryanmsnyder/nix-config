local mason = prequire "mason"

if not mason then
  return
end

local icons = require "icons.icons"

mason.setup {
  ui = {
    icons = {
      package_installed = icons.PassCheck,
      package_pending = icons.Running,
      package_uninstalled = icons.GitRemoved,
    },
  },
}
