local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action

local function is_vim(pane)
  -- this is set by the plugin, and unset on ExitPre in Neovim
  return pane:get_user_vars().IS_NVIM == 'true'
end

local direction_keys = {
  Left = 'h',
  Down = 'j',
  Up = 'k',
  Right = 'l',
  -- reverse lookup
  h = 'Left',
  j = 'Down',
  k = 'Up',
  l = 'Right',
}

local function pane_nav_and_resize(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == 'resize' and 'LEADER' or 'CTRL',
    action = wezterm.action_callback(function(win, pane)
      -- if NeoVim is running in current pane, send keys to NeoVim
      -- if resizing, CTRL + a will be sent to NeoVim, else CTRL + h|j|k|l (pane navigation) will be sent
      -- the keybindings set in custom/mappings.lua will "catch" the bindings that WezTerm sends it
      if is_vim(pane) then
        -- resizing panes
        if resize_or_move == 'resize' then
          -- pass the keys through to vim/nvim
          -- send '<C-a>'
          win:perform_action({
            SendKey = { key ='a', mods = 'CTRL' },
          }, pane)
          -- send 'r'
          win:perform_action({
            SendKey = { key ='r' },
          }, pane)
        -- moving between panes
        else
          win:perform_action({
            SendKey = { key = key, mods = 'CTRL' },
          }, pane)
        end
      -- if it's a non-NeoVim pane
      else
        -- if resizing (LEADER + r), activate resize_pane key_table defined below
        if resize_or_move == 'resize' then
          win:perform_action({ ActivateKeyTable = {
              name = 'resize_pane',
              one_shot = false,
            }
          }, pane)
        
        -- if navigating between panes (CTRL + h|j|k|l), 
        else
          win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
        end
      end
    end)
  }
end

local config = {
  color_scheme = "Catppuccin Macchiato",
  --   window_background_opacity = 0.95,

  inactive_pane_hsb = {
    saturation = 0.9,
    brightness = 0.7,
  },
  enable_tab_bar = false,
  hide_tab_bar_if_only_one_tab = true,
  show_update_window = true,
  window_decorations = "RESIZE",

  -- set undercurl (this is necessary for NeoVim)
  -- term = "wezterm", 

  -- set underline thickness
  underline_thickness = "2px",

  -- font
  font = wezterm.font_with_fallback({
    -- "Berkeley Mono Variable",
    -- { family = 'JetBrainsMono Nerd Font', weight = 'Medium' },
    "Berkeley Mono",
    -- "BerkeleyMono Nerd Font",
    -- "Berkeley Mono Trial"
    -- "SF Mono",
    -- "JetBrainsMono Nerd Font",
    -- "Noto Color Emoji"
    -- "Apple Color Emoji",
  }),
  font_size = 13,
  freetype_load_flags = 'NO_HINTING',
  freetype_load_target = 'Normal',
  front_end = "OpenGL",
  allow_square_glyphs_to_overflow_width = "Always",

  -- changes spacing of characters
  -- cell_width = 0.9,
  unicode_version = 14,
  -- Padding
  window_padding = { left = 5, right = 0, top = 0, bottom = 0 },
  adjust_window_size_when_changing_font_size = false,
  native_macos_fullscreen_mode = false,
  enable_kitty_graphics=true,
  -- leader key to intiate keyboard shortcut
  leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 2000 },
  keys = {
    {
      key = "f",
      mods = "LEADER",
      action = act.ToggleFullScreen,
    },

    -- pane management
    {
      key = "\\",
      mods = 'LEADER',
      action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
      key = "-",
      mods = 'LEADER',
      action = act.SplitVertical { domain = 'CurrentPaneDomain' },
    },
    {
      key = 'x',
      mods = 'LEADER',
      action = wezterm.action.CloseCurrentPane { confirm = true },
    },
    {
      key = 'z',
      mods = 'LEADER',
      action = wezterm.action.TogglePaneZoomState,
    },
    { key = '8', mods = 'CTRL', action = act.PaneSelect },
    {
      key = 'b',
      mods = 'CTRL',
      action = act.RotatePanes 'CounterClockwise',
    },


    -- move between split panes
    pane_nav_and_resize('move', 'h'),
    pane_nav_and_resize('move', 'j'),
    pane_nav_and_resize('move', 'k'),
    pane_nav_and_resize('move', 'l'),
    pane_nav_and_resize('resize', 'r')

  },

  key_tables = {
    -- Defines the keys that are active in our resize-pane mode.
    -- Since we're likely to want to make multiple adjustments,
    -- we made the activation one_shot=false. We therefore need
    -- to define a key assignment for getting out of this mode.
    -- 'resize_pane' here corresponds to the name="resize_pane" in
    -- the pane_nav_and_resize function above.
    resize_pane = {
      { key = 'LeftArrow', action = act.AdjustPaneSize { 'Left', 2 } },
      { key = 'h', action = act.AdjustPaneSize { 'Left', 2 } },
  
      { key = 'RightArrow', action = act.AdjustPaneSize { 'Right', 2 } },
      { key = 'l', action = act.AdjustPaneSize { 'Right', 2 } },
  
      { key = 'UpArrow', action = act.AdjustPaneSize { 'Up', 2 } },
      { key = 'k', action = act.AdjustPaneSize { 'Up', 2 } },
  
      { key = 'DownArrow', action = act.AdjustPaneSize { 'Down', 2 } },
      { key = 'j', action = act.AdjustPaneSize { 'Down', 2 } },
  
      -- Cancel the mode by pressing escape
      { key = 'Escape', action = 'PopKeyTable' },
    },
  }
}

-- wezterm.on('gui-startup', function()
--   local tab, pane, window = mux.spawn_window({})
--   window:gui_window():maximize()
--  end)

return config