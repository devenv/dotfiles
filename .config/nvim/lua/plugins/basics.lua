local plugins = {
  {
    "jedrzejboczar/possession.nvim",
    lazy = false,
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-neotest/neotest",
      "rcarriga/nvim-dap-ui",
      "NeogitOrg/neogit",
      "nvim-lua/plenary.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("possession").setup({
        silent = true,
        load_silent = true,
        debug = false,
        logfile = true,
        prompt_no_cr = false,
        hooks = {
          before_save = function()
            pcall(function()
              require("nvim-tree.api").tree.close()
            end)
            pcall(function()
              require("neotest").summary.close()
            end)
            pcall(function()
              require("neotest").output_panel.close()
            end)
            pcall(function()
              require("dapui").close()
            end)
            pcall(function()
              require("neogit").close()
            end)
            return {}
          end,
          after_load = function() end,
        },
        autosave = {
          current = true,
          tmp = false,
          on_load = true,
          on_quit = true,
        },
        commands = {
          save = "SSave",
          load = "SLoad",
          delete = "SDelete",
          list = "SList",
          rename = "PossessionRename",
          close = "PossessionClose",
          show = "PossessionShow",
          migrate = "PossessionMigrate",
        },
        plugins = {
          delete_hidden_buffers = false,
          nvim_tree = true,
          tabby = false,
          dap = true,
          delete_buffers = false,
          close_windows = {
            preserve_layout = true,
            match = {
              buftype = { "NeogitStatus", "terminal", "nofile", "help" },
              filetype = { "NeogitStatus" },
            },
          },
        },
        telescope = {
          previewer = {
            enabled = true,
            previewer = "pretty", -- or 'raw' or fun(opts): Previewer
            wrap_lines = true,
            include_empty_plugin_data = false,
            cwd_colors = {
              cwd = "Comment",
              tab_cwd = { "#cc241d", "#b16286", "#d79921", "#689d6a", "#d65d0e", "#458588" },
            },
          },
          list = {
            default_action = "load",
            mappings = {
              save = { n = "<c-x>", i = "<c-x>" },
              load = { n = "<c-v>", i = "<c-v>" },
              delete = { n = "<c-t>", i = "<c-t>" },
              rename = { n = "<c-r>", i = "<c-r>" },
            },
          },
        },
      })
    end,
  },
  {
    "echasnovski/mini.nvim",
    event = "VeryLazy",
    version = "*",
    config = function()
      require("mini.colors").setup()
      require("mini.comment").setup()
      require("mini.bufremove").setup({
        silent = true,
      })
      require("mini.splitjoin").setup({
        mappings = {
          toggle = "gJ",
        },
      })
    end,
  },
  {
    "tpope/vim-unimpaired",
    event = "BufEnter",
  },
  {
    "tpope/vim-surround",
    event = "BufEnter",
  },
  {
    "tpope/vim-dispatch",
    event = "VeryLazy",
  },
  {
    "tpope/vim-characterize",
    event = "VeryLazy",
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      fast_wrap = {
        map = "<C-g>",
      },
    },
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
    "chrisbra/unicode.vim",
    event = "BufEnter",
  },
}

return plugins
