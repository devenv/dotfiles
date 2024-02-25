local plugins = {
  {
    "tomasky/bookmarks.nvim",
    event = "BufEnter",
    config = function()
      local ticket = vim.env.TICKET or ""
      require("bookmarks").setup({
        sign_priority = 100,
        save_file = vim.fn.expand("~/.local/share/nvim/bookmarks/" .. ticket .. ".json"),
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
    "ibhagwan/fzf-lua",
    config = function()
      local actions = require("fzf-lua.actions")
      local ticket = vim.env.TICKET or ""
      require("fzf-lua").setup({
        fzf_opts = {
          ["--history"] = vim.fn.stdpath("data") .. "/fzf_files_hist" .. ticket,
        },
        winopts = {
          height = 0.9,
          width = 1.0,
          row = 0.15,
          col = 0,
          preview = {
            border = "noborder",
            vertical = "down:50%",
            horizontal = "right:50%",
            layout = "flex",
            flip_columns = 120,
          },
        },
        keymap = {
          builtin = {
            ["<S-down>"] = "preview-page-down",
            ["<S-up>"] = "preview-page-up",
            ["<S-left>"] = "preview-page-reset",
          },
          fzf = {
            ["esc"] = "abort",
            ["ctrl-u"] = "unix-line-discard",
            ["ctrl-f"] = "half-page-down",
            ["ctrl-b"] = "half-page-up",
            ["ctrl-a"] = "beginning-of-line",
            ["ctrl-e"] = "end-of-line",
            ["ctrl-a"] = "toggle-all",
            ["shift-down"] = "preview-page-down",
            ["shift-up"] = "preview-page-up",
          },
        },
        actions = {
          files = {
            ["default"] = actions.file_edit_or_qf,
            ["ctrl-s"] = actions.file_split,
            ["ctrl-v"] = actions.file_vsplit,
            ["ctrl-t"] = actions.file_tabedit,
            ["ctrl-q"] = actions.file_sel_to_qf,
          },
          buffers = {
            ["default"] = actions.buf_edit,
            ["ctrl-s"] = actions.buf_split,
            ["ctrl-v"] = actions.buf_vsplit,
            ["ctrl-t"] = actions.buf_tabedit,
          },
        },
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "tomasky/bookmarks.nvim",
      "jedrzejboczar/possession.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
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
              ["<C-q>"] = require("telescope.actions").close,
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
