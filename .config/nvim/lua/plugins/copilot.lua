return {
  "github/copilot.vim",
  lazy = false, -- Keep lazy loading disabled as per current config
  keys = {
    { "<leader>cp", "<cmd>Copilot panel<CR>", desc = "Toggle Copilot Panel" },
    -- Keep the toggle keymap
    {
      "<leader>ct",
      function()
        require("config.toggle_completion").toggle()
      end,
      desc = "Toggle Copilot/Supermaven",
    },
  },
  config = function()
    -- Disable default tab mapping since we're using blink.cmp
    vim.g.copilot_no_tab_map = true

    -- Keep your current filetype configuration
    vim.g.copilot_filetypes = {
      ["*"] = true,
      ["markdown"] = true,
      ["help"] = false,
      ["gitcommit"] = false,
      ["gitrebase"] = false,
    }

    -- Set up keymaps matching your current configuration
    vim.keymap.set("i", "<C-l>", 'copilot#Accept("<CR>")', {
      expr = true,
      replace_keycodes = false,
    })
    vim.keymap.set("i", "<C-]>", "<Plug>(copilot-dismiss)", { silent = true })
    vim.keymap.set("i", "<M-[>", "<Plug>(copilot-previous)", { silent = true })
    vim.keymap.set("i", "<M-]>", "<Plug>(copilot-next)", { silent = true })

    -- Node command setting
    vim.g.copilot_node_command = "node"
  end,
}
