local neotest = prequire "neotest"
if not neotest then
  return
end

local icons = require "icons.icons"

neotest.setup {
  adapters = {
    require "neotest-jest" {
      jestCommand = "npm test --",
    },
  },
  icons = {
    child_indent = "│",
    child_prefix = "├",
    collapsed = "─",
    expanded = "╮",
    failed = icons.Error,
    final_child_indent = " ",
    final_child_prefix = "╰",
    non_collapsible = "─",
    passed = icons.PassCheck,
    running = icons.Running,
    skipped = icons.Forbidden,
    unknown = "",
  },
}
