local M = {}

M.before = function(flavor)
  local gruvbox = prequire "gruvbox"

  if not gruvbox then
    return
  end

  vim.o.background = "dark"

  -- config needs to be set before loading colorscheme
  -- hard or soft
  vim.g.gruvbox_flat_style = flavor
  vim.g.gruvbox_italic_functions = true
end

M.after = function()
  local colors = require("gruvbox.colors").setup()

  -- neo-tree sidebar background
  vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = colors.bg2 })
  vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = colors.bg2 })
  -- neo-tree root folder
  vim.api.nvim_set_hl(0, "NeoTreeRootName", { fg = colors.fg_light, bold = true })

  -- darken telescope main background
  -- vim.api.nvim_set_hl(0, "", { fg = colors.fg_light, bold = true })
end

return M
