{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (pkgs.stdenv) isLinux;

  # Function to capitalize the first letter of a string
  capitalize = str: (lib.strings.toUpper (builtins.substring 0 1 str)) + (builtins.substring 1 (builtins.stringLength str) str);

  # Capitalize theme and flavor
  formattedTheme = capitalize config.theme;
  formattedFlavor = capitalize config.flavor;

  # Final WezTerm theme name
  weztermTheme =
    if config.theme == "catppuccin" then "Catppuccin ${formattedFlavor}"
    else formattedTheme;

  luaScript = ''
    local wezterm = require("wezterm")
    local mux = wezterm.mux
    local act = wezterm.action

    local function is_vim(pane)
      return pane:get_user_vars().IS_NVIM == "true"
    end

    local direction_keys = {
      Left = "h",
      Down = "j",
      Up = "k",
      Right = "l",
      h = "Left",
      j = "Down",
      k = "Up",
      l = "Right",
    }

    local function pane_nav_and_resize(resize_or_move, key)
      return {
        key = key,
        mods = resize_or_move == "resize" and "LEADER" or "CTRL",
        action = wezterm.action_callback(function(win, pane)
          if is_vim(pane) then
            if resize_or_move == "resize" then
              win:perform_action({SendKey = {key = "a", mods = "CTRL"}}, pane)
              win:perform_action({SendKey = {key = "r"}}, pane)
            else
              win:perform_action({SendKey = {key = key, mods = "CTRL"}}, pane)
            end
          else
            if resize_or_move == "resize" then
              win:perform_action({ActivateKeyTable = {name = "resize_pane", one_shot = false}}, pane)
            else
              win:perform_action({ActivatePaneDirection = direction_keys[key]}, pane)
            end
          end
        end),
      }
    end

    local config = {
      color_scheme = "${weztermTheme}",
      automatically_reload_config = true,
      inactive_pane_hsb = {
        saturation = 0.9,
        brightness = 0.7,
      },
      enable_tab_bar = false,
      hide_tab_bar_if_only_one_tab = true,
      window_decorations = "RESIZE",
      underline_thickness = "2px",
      font = wezterm.font_with_fallback({"Berkeley Mono"}),
      font_size = 13,
      freetype_load_flags = "NO_HINTING",
      freetype_load_target = "Normal",
      front_end = "OpenGL",
      allow_square_glyphs_to_overflow_width = "Always",
      unicode_version = 14,
      window_padding = {left = 5, right = 0, top = 0, bottom = 0},
      adjust_window_size_when_changing_font_size = false,
      native_macos_fullscreen_mode = false,
      enable_kitty_graphics = true,
      leader = {key = "a", mods = "CTRL", timeout_milliseconds = 2000},
      keys = {
        {key = "f", mods = "LEADER", action = act.ToggleFullScreen},
        {key = "\\", mods = "LEADER", action = act.SplitHorizontal({domain = "CurrentPaneDomain"})},
        {key = "-", mods = "LEADER", action = act.SplitVertical({domain = "CurrentPaneDomain"})},
        {key = "x", mods = "LEADER", action = act.CloseCurrentPane({confirm = true})},
        {key = "z", mods = "LEADER", action = act.TogglePaneZoomState},
        {key = "8", mods = "CTRL", action = act.PaneSelect},
        {key = "b", mods = "CTRL", action = act.RotatePanes("CounterClockwise")},
        pane_nav_and_resize("move", "h"),
        pane_nav_and_resize("move", "j"),
        pane_nav_and_resize("move", "k"),
        pane_nav_and_resize("move", "l"),
        pane_nav_and_resize("resize", "r"),
      },
      key_tables = {
        resize_pane = {
          {key = "LeftArrow", action = act.AdjustPaneSize({"Left", 2})},
          {key = "h", action = act.AdjustPaneSize({"Left", 2})},
          {key = "RightArrow", action = act.AdjustPaneSize({"Right", 2})},
          {key = "l", action = act.AdjustPaneSize({"Right", 2})},
          {key = "UpArrow", action = act.AdjustPaneSize({"Up", 2})},
          {key = "k", action = act.AdjustPaneSize({"Up", 2})},
          {key = "DownArrow", action = act.AdjustPaneSize({"Down", 2})},
          {key = "j", action = act.AdjustPaneSize({"Down", 2})},
          {key = "Escape", action = "PopKeyTable"},
        },
      },
    }

    wezterm.on("window-config-reloaded", function(window, pane)
      local overrides = window:get_config_overrides() or {}
      if overrides.color_scheme ~= config.color_scheme then
        overrides.color_scheme = config.color_scheme
        window:set_config_overrides(overrides)
      end
    end)

    wezterm.on("gui-startup", function()
      local tab, pane, window = mux.spawn_window({})
      window:gui_window():maximize()
    end)

    return config
  '';

in {
  home.packages = mkIf isLinux [pkgs.wezterm];

  xdg.configFile."wezterm/wezterm.lua".text = luaScript;
}
