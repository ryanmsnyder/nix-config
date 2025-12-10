local trouble = prequire "trouble"
if not trouble then
  return
end

local icons = require "icons.icons"

trouble.setup {
  padding = false,
  autoclose = true,
  signs = {
    error = icons.Error,
    warning = icons.Warn,
    hint = icons.Hint,
    information = icons.Info,
  },
}
