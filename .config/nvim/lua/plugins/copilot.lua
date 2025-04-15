local plugins = {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "BufEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 10,
          keymap = {
            accept = "<C-j>",
            accept_word = "<C-l>",
            dismiss = "<C-k>",
          },
        },
        panel = {
          enabled = false,
        },
        filetypes = {
          markdown = true,
          help = true,
          gitcommit = false,
          gitrebase = false,
          ["."] = false,
        },
        copilot_node_command = "node", -- assumes node is in your PATH
        server_opts_overrides = {
          settings = {
            advanced = {
              listCount = 10,
              inlineSuggestCount = 3,
            },
          },
        },
      })
    end,
  },
}

return plugins
