-- Different notification style options for pytest
-- Choose one of these configurations

local M = {}

-- Option 1: VSCode-style (bottom-right, compact)
M.vscode_style = {
  stages = "slide",
  timeout = 2000,
  render = "compact",
  top_down = false, -- Bottom to top
  max_height = function() return math.floor(vim.o.lines * 0.2) end,
  max_width = function() return math.floor(vim.o.columns * 0.25) end,
  background_colour = "#1e1e1e",
}

-- Option 2: Minimal toast (very small, bottom-right)
M.toast_style = {
  stages = "static",
  timeout = 1500,
  render = "minimal",
  top_down = false,
  max_height = 3,
  max_width = 40,
  background_colour = "#2d2d2d",
}

-- Option 3: Status line style (bottom, no animation)
M.statusline_style = {
  stages = "static",
  timeout = 2000,
  render = "simple",
  top_down = false,
  max_height = 1,
  max_width = function() return math.floor(vim.o.columns * 0.8) end,
  background_colour = "#3c3c3c",
}

-- Option 4: Subtle fade (like IntelliJ)
M.intellij_style = {
  stages = "fade",
  timeout = 2500,
  render = "minimal",
  top_down = true, -- Top to bottom
  max_height = function() return math.floor(vim.o.lines * 0.15) end,
  max_width = function() return math.floor(vim.o.columns * 0.3) end,
  background_colour = "#2b2b2b",
}

-- Option 5: Command line area (echoing without notifications)
-- This would use vim.api.nvim_echo instead of notify

return M