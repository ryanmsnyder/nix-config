{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (pkgs.stdenv) isLinux;

  capitalize = str:
    let
      first = lib.strings.toUpper (builtins.substring 0 1 str);
      rest = builtins.substring 1 (builtins.stringLength str - 1) str;
    in
      first + rest;

  theme = capitalize config.theme;
  flavor = capitalize config.flavor;
  colorScheme = "${theme} ${flavor}";

  luaScript = ''
    local wezterm = require("wezterm")
    local mux = wezterm.mux
    local act = wezterm.action

    local function is_vim(pane)
      return pane:get_user_vars().IS_NVIM == "true"
    end

    local direction_keys = {
      n = "Left",
      i = "Right",
      u = "Up",
      e = "Down",
    }

    local function pane_nav_and_resize(resize_or_move, key, mods)
      return {
        key = key,
        mods = mods or (resize_or_move == "resize" and "LEADER" or "CTRL"),
        action = wezterm.action_callback(function(win, pane)
          local direction_keys = {
            n = "Left",
            i = "Right",
            u = "Up",
            e = "Down",
          }

          if is_vim(pane) then
            if resize_or_move == "resize" then
              win:perform_action({SendKey = {key = "a", mods = "CTRL"}}, pane)
              win:perform_action({SendKey = {key = "r"}}, pane)
            else
              win:perform_action({SendKey = {key = key, mods = "ALT"}}, pane)
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
      color_scheme = "${colorScheme}",
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

        pane_nav_and_resize("move", "n", "ALT"),
        pane_nav_and_resize("move", "i", "ALT"),
        pane_nav_and_resize("move", "u", "ALT"),
        pane_nav_and_resize("move", "e", "ALT"),
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
