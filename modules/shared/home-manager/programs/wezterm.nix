{
  pkgs,
  lib,
  config,
  user,
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

    local colors = wezterm.color.get_builtin_schemes()["catppuccin-mocha"]

    local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
    local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")

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
        {
          key = "s",
          mods = "LEADER",
          action = workspace_switcher.switch_workspace(),
        },
        {
          key = "S",
          mods = "LEADER",
          action = workspace_switcher.switch_to_prev_workspace(),
        },
        {
          key = "g",
          mods = "LEADER",
          action = wezterm.action_callback(function(win, pane)
            resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id, label)
              local type = string.match(id, "^([^/]+)") -- match before '/'
              id = string.match(id, "([^/]+)$") -- match after '/'
              id = string.match(id, "(.+)%..+$") -- remove file extention
              local opts = {
                relative = true,
                restore_text = true,
                window = pane:window(),
                -- tab = win:active_tab(),
                close_open_tabs = true,
                on_pane_restore = resurrect.tab_state.default_on_pane_restore,
              }
              if type == "workspace" then
                local state = resurrect.state_manager.load_state(id, "workspace")
                resurrect.workspace_state.restore_workspace(state, opts)
              elseif type == "window" then
                local state = resurrect.state_manager.load_state(id, "window")
                resurrect.window_state.restore_window(pane:window(), state, opts)
              elseif type == "tab" then
                local state = resurrect.state_manager.load_state(id, "tab")
                resurrect.tab_state.restore_tab(pane:tab(), state, opts)
              end
            end)
          end),
        },
        {
        key = "d",
        mods = "LEADER",
        action = wezterm.action_callback(function(win, pane)
          resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id)
              resurrect.state_manager.delete_state(id)
            end,
            {
              title = "Delete State",
              description = "Select State to Delete and press Enter = accept, Esc = cancel, / = filter",
              fuzzy_description = "Search State to Delete: ",
              is_fuzzy = true,
            })
        end),
        },
        pane_nav_and_resize("move", "n", "ALT"),
        pane_nav_and_resize("move", "i", "ALT"),
        pane_nav_and_resize("move", "u", "ALT"),
        pane_nav_and_resize("move", "e", "ALT"),
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

    resurrect.state_manager.periodic_save({
      interval_seconds = 10 * 60,
      save_workspaces = true,
      save_windows = true,
      save_tabs = true,
    })

    wezterm.on("resurrect.error", function(err)
      wezterm.log_error("ERROR!")
      wezterm.gui.gui_windows()[1]:toast_notification("resurrect", err, nil, 3000)
    end)

    workspace_switcher.zoxide_path = "/etc/profiles/per-user/${user}/bin/zoxide"
    workspace_switcher.apply_to_config({})

    workspace_switcher.workspace_formatter = function(label)
      return wezterm.format({
        { Attribute = { Italic = true } },
        { Foreground = { Color = colors.ansi[3] } },
        { Background = { Color = colors.background } },
        { Text = "󱂬 : " .. label },
      })
    end

    wezterm.on("smart_workspace_switcher.workspace_switcher.created", function(window, path, label)
      window:gui_window():set_right_status(wezterm.format({
        { Attribute = { Intensity = "Bold" } },
        { Foreground = { Color = colors.ansi[5] } },
        { Text = basename(path) .. "  " },
      }))
      local workspace_state = resurrect.workspace_state

      workspace_state.restore_workspace(resurrect.state_manager.load_state(label, "workspace"), {
        window = window,
        relative = true,
        restore_text = true,

        resize_window = false,
        on_pane_restore = resurrect.tab_state.default_on_pane_restore,
      })
    end)

    wezterm.on("smart_workspace_switcher.workspace_switcher.chosen", function(window, path, label)
      wezterm.log_info(window)
      window:gui_window():set_right_status(wezterm.format({
        { Attribute = { Intensity = "Bold" } },
        { Foreground = { Color = colors.ansi[5] } },
        { Text = basename(path) .. "  " },
      }))
    end)

    wezterm.on("smart_workspace_switcher.workspace_switcher.selected", function(window, path, label)
      wezterm.log_info(window)
      local workspace_state = resurrect.workspace_state
      resurrect.state_manager.save_state(workspace_state.get_workspace_state())
      resurrect.state_manager.write_current_state(label, "workspace")
    end)

    wezterm.on("smart_workspace_switcher.workspace_switcher.start", function(window, _)
      wezterm.log_info(window)
    end)
    wezterm.on("smart_workspace_switcher.workspace_switcher.canceled", function(window, _)
      wezterm.log_info(window)
    end)

    wezterm.on("gui-startup", resurrect.state_manager.resurrect_on_gui_startup)

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
