local wezterm = require 'wezterm'
local act = wezterm.action
local mux = wezterm.mux
local config =  wezterm.config_builder()

-- Maximize the terminal window on startup
wezterm.on('gui-startup', function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)

-- SETTING

config.color_scheme = 'Catppuccin Macchiato'

config.font = wezterm.font 'FiraCode Nerd Font'
config.font_size = 16.0

--config.window_background_opacity = 0.9
config.window_close_confirmation = 'NeverPrompt'
config.window_decorations = 'RESIZE'
config.window_frame = {
    font = wezterm.font { family = 'Noto Sans', weight = 'Regular' },
}

config.hide_tab_bar_if_only_one_tab = true

config.keys = {
    { key = '\\', mods = 'SUPER|SHIFT', action = act.SplitHorizontal{ domain =  'CurrentPaneDomain' } },
    { key = 'Enter', mods = 'SUPER|SHIFT', action = act.SplitVertical{ domain =  'CurrentPaneDomain' } },
    { key = 'h', mods = 'SUPER|SHIFT', action = act.ActivatePaneDirection('Left') },
    { key = 'j', mods = 'SUPER|SHIFT', action = act.ActivatePaneDirection('Down') },
    { key = 'k', mods = 'SUPER|SHIFT', action = act.ActivatePaneDirection('Up') },
    { key = 'l', mods = 'SUPER|SHIFT', action = act.ActivatePaneDirection('Right') },
}

return config

