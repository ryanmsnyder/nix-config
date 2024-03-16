local heirline = prequire "heirline"
local conditions = require "heirline.conditions"

if not heirline then
  return
end

local statusline = require "config.heirline.statusline"
local winbar = require "config.heirline.winbar"

-- local icons = require "icons.icons"
-- local conditions = require "heirline.conditions"
local utils = require "heirline.utils"
local util = require "config.heirline.util"

local function setup_colors()
  return util.highlights()
end

-- load colors so that aliases can be used in hl functions/tables within components
heirline.load_colors(setup_colors)

-- change the colors of the statusline automatically whenever colorscheme is changed
vim.api.nvim_create_augroup("Heirline", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    utils.on_colorscheme(setup_colors)
  end,
  group = "Heirline",
})

heirline.setup {
  statusline = statusline.StatusLines,
  winbar = winbar,
  opts = {
    -- if the callback returns true, the winbar will be disabled for that window
    -- the args parameter corresponds to the table argument passed to autocommand callbacks. :h nvim_lua_create_autocmd()
    disable_winbar_cb = function(args)
        return conditions.buffer_matches({
            buftype = { "nofile", "prompt", "help", "quickfix" },
            filetype = { "^git.*", "fugitive", "Trouble", "dashboard" },
        }, args.buf)
    end,
  },  
}
