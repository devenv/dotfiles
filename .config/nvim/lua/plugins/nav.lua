local plugins = {
  {
    "tomasky/bookmarks.nvim",
    event = "BufEnter",
    config = function()
      require("bookmarks").setup({
        sign_priority = 8,
        save_file = vim.fn.expand("$HOME/.local/share/nvim/bookmarks/$TICKET.json"),
        keywords = {
          ["@t"] = "☑︎ ",
          ["@w"] = "‼ ",
          ["@r"] = "® ",
          ["@s"] = "§ ",
          ["@p"] = "℗ ",
          ["@m"] = "⁂ ",
          ["@n"] = "♪ ",
        },
        on_attach = function(bufnr)
          local bm = require("bookmarks")
          local map = vim.keymap.set
          map("n", "mm", bm.bookmark_toggle) -- add or remove bookmark at current line
          map("n", "mi", bm.bookmark_ann) -- add or edit mark annotation at current line
          map("n", "mx", bm.bookmark_clean) -- clean all marks in local buffer
          map("n", "mj", bm.bookmark_next) -- jump to next mark in local buffer
          map("n", "mk", bm.bookmark_prev) -- jump to previous mark in local buffer
          map("n", "mq", bm.bookmark_list) -- show marked file list in quickfix window
        end,
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "tomasky/bookmarks.nvim",
      "jedrzejboczar/possession.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          layout_strategy = "flex",
          layout_config = {
            prompt_position = "bottom",
            width = 0.95,
            height = 0.95,
          },
          mappings = {
            i = {
              ["<C-p>"] = require("telescope.actions").cycle_history_prev,
              ["<C-n>"] = require("telescope.actions").cycle_history_next,
              ["<C-a>"] = require("telescope.actions").send_selected_to_qflist,
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })
      require("telescope").load_extension("bookmarks")
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("possession")
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    config = function()
      require("nvim-tree").setup({
        respect_buf_cwd = false,
        reload_on_bufenter = true,
        sync_root_with_cwd = true,
        on_attach = function(bufnr)
          local api = require("nvim-tree.api")
          api.config.mappings.default_on_attach(bufnr)
          vim.keymap.del("n", "<C-k>", { buffer = bufnr })
          vim.keymap.set("n", "<tab>", api.tree.toggle, { buffer = bufnr, desc = "Toggle Explorer" })
        end,
        update_focused_file = {
          enable = true,
          update_root = false,
          ignore_list = {},
        },
        diagnostics = {
          enable = false,
          show_on_dirs = false,
          severity = {
            min = vim.diagnostic.severity.ERROR,
            max = vim.diagnostic.severity.ERROR,
          },
        },
        modified = {
          enable = false,
          show_on_dirs = true,
          show_on_open_dirs = true,
        },
        actions = {
          open_file = {
            quit_on_open = true,
            window_picker = {
              enable = false,
            },
          },
        },
        view = {
          width = 50,
        },
      })
    end,
  },
  {
    "RRethy/vim-illuminate",
    event = "VeryLazy",
    config = function()
      require("illuminate").configure({
        providers = {
          "lsp",
          "treesitter",
          "regex",
        },
        delay = 100,
        filetype_overrides = {},
        filetypes_denylist = {
          "neotest",
          "neotree",
        },
        under_cursor = true,
        min_count_to_highlight = 1,
      })
    end,
  },
  {
    "utilyre/barbecue.nvim",
    event = "BufEnter",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("barbecue").setup({
        theme = "catppuccin",
        create_autocmd = false,
        attach_navic = false,
      })

      vim.api.nvim_create_autocmd({
        "WinScrolled", -- or WinResized on NVIM-v0.9 and higher
        "BufWinEnter",
        "CursorHold",
        "InsertLeave",

        -- include this if you have set `show_modified` to `true`
        "BufModifiedSet",
      }, {
        group = vim.api.nvim_create_augroup("barbecue.updater", {}),
        callback = function()
          require("barbecue.ui").update()
        end,
      })
    end,
    opts = {},
  },
  {
    "wellle/targets.vim",
    event = "BufEnter",
  },
  {
    "christoomey/vim-sort-motion",
    event = "BufEnter",
  },
  {
    "michaeljsmith/vim-indent-object",
    event = "BufEnter",
  },
  {
    "bkad/CamelCaseMotion",
    event = "BufEnter",
  },
  {
    "farmergreg/vim-lastplace",
    lazy = false,
  },
}

return plugins