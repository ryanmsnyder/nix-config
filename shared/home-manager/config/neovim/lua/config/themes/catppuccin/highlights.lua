local function generate_highlights()
  local flavor = vim.g.catppuccin_flavour
  local cp = require("catppuccin.palettes").get_palette(flavor)

  local H = {}

  H.general = {
    WinSeparator = { fg = cp.surface1 },
  }

  H.neo_tree = {
    NeoTreeRootName = { fg = cp.lavender },
    NeoTreeWinSeparator = { fg = cp.mantle, bg = cp.mantle },
  }

  H.telescope = {
    TelescopeBorder = { fg = cp.mantle, bg = cp.mantle },
    TelescopeSelectionCaret = { fg = cp.flamingo, bg = cp.surface1 },
    TelescopeMatching = { fg = cp.peach },
    TelescopeNormal = { bg = cp.mantle },
    -- TelescopeSelection = { fg = cp.text, bg = cp.surface1 },
    TelescopeSelection = { fg = cp.text, bg = cp.surface0 },
    TelescopeMultiSelection = { fg = cp.text, bg = cp.surface2 },

    TelescopeTitle = { fg = cp.crust, bg = cp.green },

    TelescopePromptNormal = { fg = cp.text, bg = cp.crust },
    TelescopePromptBorder = { fg = cp.crust, bg = cp.crust },
    TelescopePromptTitle = { fg = cp.crust, bg = cp.mauve },
    TelescopePromptPrefix = { fg = cp.mauve, bg = cp.crust },

    TelescopePreviewNormal = { bg = cp.mantle },
    TelescopePreviewTitle = { fg = cp.crust, bg = cp.red },
    TelescopePreviewBorder = { fg = cp.mantle, bg = cp.mantle },

    TelescopeResultsNormal = { bg = cp.mantle },
    TelescopeResultsTitle = { fg = cp.mantle, bg = cp.mantle },
    TelescopeResultsBorder = { fg = cp.mantle, bg = cp.mantle },
  }

  H.trouble = {
    TroubleNormal = { bg = cp.mantle },
  }

  local merged = {}

  for _, tbl in pairs(H) do
    for key, value in pairs(tbl) do
      merged[key] = value
    end
  end

  return merged
end

return {
  highlights = generate_highlights,
}
