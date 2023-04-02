-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Dark+'
config.enable_scroll_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true

-- Fallback font
config.font = wezterm.font_with_fallback {
  'CodeNewRoman Nerd Font Mono',
}

config.keys = {
  -- This will create a new split and run your default program inside it
  {
    key = 'H',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'J',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
}

-- and finally, return the configuration to wezterm
return config
