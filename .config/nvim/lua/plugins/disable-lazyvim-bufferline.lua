-- Disable LazyVim's automatic bufferline integration to prevent errors
return {
  {
    "akinsho/bufferline.nvim",
    enabled = false, -- Completely disable bufferline
    opts = function()
      return {} -- Return empty opts to prevent any configuration
    end,
    config = false, -- Disable config function
  },
  {
    "catppuccin/nvim",
    opts = function(_, opts)
      opts.integrations = opts.integrations or {}
      opts.integrations.bufferline = false -- Disable bufferline integration in catppuccin
      return opts
    end,
  },
}