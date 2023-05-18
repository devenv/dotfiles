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
   opts = {
      ensure_installed = {
        "lua-language-server",
        "html-lsp",
        "prettier",
        "pyright",
        "python-lsp-server",
        "reorganize-python-imports",
      },
    },
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
    "nvim-telescope/telescope.nvim",
    opts = overrides.mason,
    config = function()
      local trouble = require("trouble.providers.telescope")

      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup {
        defaults = {
          mappings = {
            i = {
              ["<c-t>"] = trouble.open_with_trouble,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-n>"] = actions.cycle_history_next,
            },
            n = {
              ["<c-t>"] = trouble.open_with_trouble,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-n>"] = actions.cycle_history_next,
            },
          },
        },
      }
    end
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
          { name = "nvim_lsp", priority = 1 },
          { name = "nvim_lua", priority = 1 },
          { name = "copilot", priority = 2 },
          { name = "luasnip", priority = 3 },
          { name = "path", priority = 4 },
          {
            name = "buffer",
            option = {
              get_bufnrs = function()
                return vim.api.nvim_list_bufs()
              end,
            },
          },
        },
        sorting = {
          priority_weight = 2,
          comparators = {
            require("copilot_cmp.comparators").prioritize
          },
        },
        formatting = {
          format = function(entry, vim_item)
            vim_item.menu = ({
              nvim_lsp = '[LSP]',
              vsnip = '[Snippet]',
              nvim_lua = '[Nvim Lua]',
              buffer = '[Buffer]',
            })[entry.source.name]

            vim_item.dup = ({
              vsnip = 0,
              nvim_lsp = 0,
              nvim_lua = 0,
              buffer = 0,
            })[entry.source.name] or 0

            return vim_item
          end
        },
        mapping = cmp.mapping.preset.insert {
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-g>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          }),
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
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    lazy = false,
    build = 'make',
    config = function()
      require('telescope').load_extension('fzf')
    end
  }
}

return plugins
