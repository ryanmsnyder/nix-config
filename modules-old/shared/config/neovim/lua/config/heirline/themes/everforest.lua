local function generate_highlights()
  local palettes = require "everforest.colours"
  local config = require("everforest").config
  local palette = palettes.generate_palette(config, vim.o.background)

  local H = {

    -- main background color of statusline and text
    bkg = palette.bg2,
    light_text = palette.grey1,

    -- vi modes
    normal = palette.blue,
    insert = palette.green,
    visual = palette.yellow,
    select = palette.red,
    replace = palette.red,
    command = palette.orange,
    prompt = palette.aqua,
    confirm = palette.purple,
    terminal = palette.purple,
    nterminal = palette.blue,

    -- right aligned components
    file_name_bkg = palette.statusline1,
    dir_name_bkg = palette.statusline2,

    -- diagnostics
    diag_warn = palette.yellow,
    diag_error = palette.red,
    diag_hint = palette.aqua,
    diag_info = palette.blue,
  }
  return H
end

return {
  highlights = generate_highlights,
}
