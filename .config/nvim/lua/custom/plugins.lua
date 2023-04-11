local overrides = require "custom.configs.overrides"

---@type NvPluginSpec[]
local plugins = {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
    { "nvim-treesitter/nvim-treesitter-textobjects" },
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  -- Editing {{{
  {
    "camspiers/lens.vim",
    event = "BufEnter",
  },
  {
    "svermeulen/vim-subversive",
    event = "BufEnter",
  },
  {
    "tpope/vim-abolish",
    event = "BufEnter",
  },
  {
    "tpope/vim-repeat",
    event = "BufEnter",
  },
  {
    "tpope/vim-surround",
    event = "BufEnter",
  },
  {
    "tpope/vim-unimpaired",
    event = "BufEnter",
  },
  -- }}}

  -- Programming {{{
  {
    "christoomey/vim-sort-motion",
    event = "BufEnter",
  },
  { "folke/trouble.nvim" },
  {
    "glepnir/lspsaga.nvim",
    event = "BufEnter",
  },
  {
    "michaeljsmith/vim-indent-object",
    event = "BufEnter",
  },
  {
    "wellle/targets.vim",
    event = "BufEnter",
  },
  -- }}}

  -- Git / FZF / Undo /  etc {{{
  {
    "ThePrimeagen/harpoon",
    event = "BufEnter",
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    "embear/vim-localvimrc",
    lazy = false,
  },
  {
    "mbbill/undotree",
    lazy = false,
  },
  {
    "mhinz/vim-startify",
    lazy = false,
  },
  {
    "farmergreg/vim-lastplace",
    lazy = false,
  },
  -- }}}

  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },
}

return plugins
