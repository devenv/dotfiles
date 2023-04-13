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
    end,
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
    lazy = false,
  },
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },
  {
    "camspiers/lens.vim",
    event = "BufEnter",
  },
  {
    "madox2/vim-ai",
    event = "BufEnter",
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {}
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    event = "BufEnter",
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  {
    "hrsh7th/cmp-buffer",
    event = "BufEnter",
    config = function()
      local cmp = require "cmp"
      cmp.setup {
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        sources = cmp.config.sources {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "nvim_lua" },
          { name = "copilot" },
          { name = "path" },
          {
            name = "buffer",
            option = {
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end,
            },
          },
        },
        mapping = cmp.mapping.preset.insert {
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-g>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm { select = true },
          ["<tab>"] = cmp.mapping.abort(),
          ["<C-n>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_next_item()
            else
              cmp.complete()
            end
          end),
        },
      }
    end,
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
  {
    "christoomey/vim-sort-motion",
    event = "BufEnter",
  },
  { "folke/trouble.nvim" },
  {
    "glepnir/lspsaga.nvim",
    event = "BufEnter",
    config = function()
      require("lspsaga").setup {
        beacon = {
          enable = false,
          frequency = 1,
        },
        symbol_in_winbar = {
          enable = false,
        },
      }
    end,
  },
  {
    "michaeljsmith/vim-indent-object",
    event = "BufEnter",
  },
  {
    "wellle/targets.vim",
    event = "BufEnter",
  },
  {
    "ThePrimeagen/harpoon",
    event = "BufEnter",
    config = function()
      require("harpoon").setup {
        save_on_toggle = true,
        save_on_change = true,
        mark_branch = true,
      }
    end,
  },
  {
    "christoomey/vim-tmux-navigator",
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
}

return plugins
