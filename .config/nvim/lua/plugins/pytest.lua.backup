-- Modern pytest integration for Neovim
-- A stable alternative to neotest with better pytest support

return {
  {
    "nvim-lua/plenary.nvim", -- Required for async operations
    lazy = false,
  },
  {
    "rcarriga/nvim-notify", -- For better notifications
    event = "VeryLazy",
    config = function()
      require("notify").setup({
        -- Smooth fade animation
        stages = "fade",
        timeout = 2000,
        max_height = function()
          return math.floor(vim.o.lines * 0.3) -- Allow more height
        end,
        max_width = function()
          return math.floor(vim.o.columns * 0.4) -- Allow more width for long paths
        end,
        -- Compact rendering style (alternative: "minimal" for even more compact)
        render = "compact",
        background_colour = "#1a1a1a",
        -- Position in corner
        top_down = false, -- Bottom to top
        -- Make them less intrusive but readable
        minimum_width = 50,
        -- Enable word wrapping and spacing
        wrap = true,
        level = 2, -- Reduce spacing between notifications
        fps = 60, -- Smooth animations
        icons = {
          ERROR = "✘",
          WARN = "▲",
          INFO = "●",
          DEBUG = "⚙",
          TRACE = "✎",
        },
      })
      vim.notify = require("notify")
    end,
  },
  {
    "akinsho/toggleterm.nvim", -- For better terminal integration
    event = "VeryLazy",
    config = function()
      require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_terminals = true,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "horizontal",
        close_on_exit = false,
        shell = vim.o.shell,
      })
    end,
  },
}