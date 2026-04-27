{
  pkgs,
  lib,
  config,
  user,
  ...
}: let

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

    local workspace_manager = wezterm.plugin.require("https://github.com/MLFlexer/workspace-manager.wezterm")

    local function is_vim(pane)
      return pane:get_user_vars().IS_NVIM == "true"
    end

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
            h = "Left",
            j = "Down",
            k = "Up",
            l = "Right",
          }

          if is_vim(pane) then
            if resize_or_move == "resize" then
              win:perform_action({SendKey = {key = "a", mods = "CTRL"}}, pane)
              win:perform_action({SendKey = {key = "r"}}, pane)
            else
              win:perform_action({SendKey = {key = key, mods = mods}}, pane)
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

    local function basename(s)
	    return string.gsub(s, "(.*[/\\])(.*)", "%2")
    end

    local config = {
      color_scheme = "${colorScheme}",
      automatically_reload_config = true,
      default_workspace = "~",
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
      front_end = "WebGpu",
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
        pane_nav_and_resize("move", "h", "CTRL"),
        pane_nav_and_resize("move", "j", "CTRL"),
        pane_nav_and_resize("move", "k", "CTRL"),
        pane_nav_and_resize("move", "l", "CTRL"),
        pane_nav_and_resize("resize", "r"),
      },
      key_tables = {
        resize_pane = {
          {key = "LeftArrow", action = act.AdjustPaneSize({"Left", 2})},
          {key = "n", action = act.AdjustPaneSize({"Left", 2})},
          {key = "RightArrow", action = act.AdjustPaneSize({"Right", 2})},
          {key = "i", action = act.AdjustPaneSize({"Right", 2})},
          {key = "UpArrow", action = act.AdjustPaneSize({"Up", 2})},
          {key = "u", action = act.AdjustPaneSize({"Up", 2})},
          {key = "DownArrow", action = act.AdjustPaneSize({"Down", 2})},
          {key = "e", action = act.AdjustPaneSize({"Down", 2})},
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

    workspace_manager.zoxide_path = "/etc/profiles/per-user/${user}/bin/zoxide"
    workspace_manager.wezterm_path = "/etc/profiles/per-user/${user}/bin/wezterm"
    workspace_manager.start_in_fuzzy_mode = false
    workspace_manager.session_enabled = true
    workspace_manager.session_restore_on_startup = true

    workspace_manager.get_choices = function()
      local choices = {}
      local seen = {}

      local home = os.getenv("HOME") or ""
      local handle = io.popen('ls -d ' .. home .. '/Code/*/ 2>/dev/null')
      if handle then
        for line in handle:lines() do
          local path = line:gsub("/$", "")
          if not seen[path] then
            seen[path] = true
            table.insert(choices, path)
          end
        end
        handle:close()
      end

      for _, path in ipairs(workspace_manager.get_zoxide_paths(10)) do
        if not seen[path] then
          seen[path] = true
          table.insert(choices, path)
        end
      end

      return choices
    end

    workspace_manager.apply_to_config(config)

    wezterm.on("gui-attached", function(domain)
      local workspace = mux.get_active_workspace()
      for _, window in ipairs(mux.all_windows()) do
        if window:get_workspace() == workspace then
          window:gui_window():maximize()
        end
      end
    end)

    local maximized_windows = {}
    wezterm.on("window-focus-changed", function(window, pane)
      local id = window:window_id()
      if not maximized_windows[id] then
        maximized_windows[id] = true
        window:maximize()
      end
    end)

    return config
  '';

in {
  xdg.configFile."wezterm/wezterm.lua".text = luaScript;
}
