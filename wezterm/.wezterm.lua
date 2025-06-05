local wezterm = require 'wezterm';

return {
  font = wezterm.font("FiraCode Nerd Font"),
  font_size = 12.0,
  color_scheme = "Catppuccin Mocha",
  default_prog = {
    "pwsh.exe", "-NoLogo", "-NoExit",
    "-Command",
    "oh-my-posh init pwsh --config 'C:\\Users\\roberto\\oh-my-posh\\agnoster.omp.json' | Invoke-Expression"
  },
  enable_tab_bar = false,
  window_background_opacity = 0.95,
  window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10,
  },
}
