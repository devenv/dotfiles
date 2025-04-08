local plugins = {
  {
    "Weissle/persistent-breakpoints.nvim",
    event = "VeryLazy",
    config = function()
      require("persistent-breakpoints").setup({
        load_breakpoints_event = { "BufReadPost" },
        save_dir = vim.fn.stdpath("data") .. "/nvim_breakpoints",
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        event = "BufEnter",
      },
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "vim",
          "lua",
          "html",
          "css",
          "javascript",
          "typescript",
          "tsx",
          "c",
          "python",
          "markdown",
          "markdown_inline",
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
        textobjects = {
          swap = {
            enable = true,
            swap_next = {
              ["ma"] = "@parameter.inner",
              ["mc"] = "@class.outer",
              ["mi"] = "@conditional.inner",
              ["md"] = "@function.outer",
              ["ms"] = "@block.outer",
            },
            swap_previous = {
              ["Ma"] = "@parameter.inner",
              ["Mc"] = "@class.outer",
              ["Mi"] = "@conditional.inner",
              ["Md"] = "@function.outer",
              ["Ms"] = "@block.outer",
            },
          },
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["ad"] = "@function.outer",
              ["id"] = "@function.inner",
              ["as"] = "@block.outer",
              ["is"] = "@block.inner",
            },
            selection_modes = {
              ["@parameter.outer"] = "v", -- charwise
              ["@function.outer"] = "V", -- linewise
              ["@class.outer"] = "<c-v>", -- blockwise
            },
            include_surrounding_whitespace = true,
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]a"] = "@parameter.outer",
              ["]c"] = "@class.outer",
              ["]d"] = "@function.outer",
              ["]s"] = "@block.outer",
            },
            goto_previous_start = {
              ["[a"] = "@parameter.outer",
              ["[c"] = "@class.outer",
              ["[d"] = "@function.outer",
              ["[s"] = "@block.outer",
            },
          },
          lsp_interop = {
            enable = true,
            border = "none",
            floating_preview_opts = {},
            peek_definition_code = {
              ["<leader>KK"] = "@call.inner",
              ["<leader>Kf"] = "@function.outer",
              ["<leader>Kc"] = "@class.outer",
            },
          },
        },
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufEnter",
    opts = {
      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
      numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = {
        follow_files = true,
      },
      attach_to_untracked = true,
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 100,
        ignore_whitespace = true,
        virt_text_priority = 100,
      },
      current_line_blame_formatter = "<author>, <abbrev_sha> <author_time:%Y-%m-%d> - <summary>",
    },
  },
  {
    "nvim-neotest/neotest",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "folke/neodev.nvim",
      "nvim-neotest/neotest-python",
      {
        "mfussenegger/nvim-dap",
        config = function()
          local dap = require("dap")
          dap.adapters.python = function(cb, config)
            if config.request == "attach" then
              local port = (config.connect or config).port
              local host = (config.connect or config).host or "127.0.0.1"
              cb({
                type = "server",
                port = assert(port, "`connect.port` is required for a python `attach` configuration"),
                host = host,
                options = {
                  source_filetype = "python",
                },
              })
            else
              cb({
                type = "executable",
                command = os.getenv("VIRTUAL_ENV") .. "/bin/python",
                args = { "-m", "debugpy.adapter" },
                options = {
                  source_filetype = "python",
                },
              })
            end
          end

          -- Adding disconnect event handling
          dap.listeners.after["disconnect"]["custom_cleanup"] = function(session, body)
            print("Debug session disconnected. Cleaning up...")
            -- Add any custom cleanup code here
          end

          dap.configurations.python = {
            {
              type = "python",
              request = "attach",
              name = "Attach",
              port = 5678,
              pathMappings = {
                { localRoot = vim.fn.getcwd(), remoteRoot = "/usr/app/src" },
                {
                  localRoot = vim.fn.getcwd() .. "/../venv/lib/python3.10/site-packages",
                  remoteRoot = "/usr/local/lib/python3.10/site-packages",
                },
                {
                  localRoot = "/Users/devenv/nilus/common/rules_framework/src/nilus/common/rules_framework",
                  remoteRoot = "/usr/local/lib/python3.10/site-packages/nilus/common/rules_framework",
                },
              },
              showReturnValue = true,
              justMyCode = false,
              pythonPath = function()
                return os.getenv("VIRTUAL_ENV") .. "/bin/python"
              end,
            },
          }
        end,
      },
    },
    config = function()
      require("neotest").setup({
        log_level = 5,

        discovery = {
          filter_dir = function(name, rel_path, root)
            return not string.match(rel_path, "sdk/")
          end,
        },
        quickfix = {
          enabled = true,
          open = false,
        },
        output = {
          enabled = true,
          open_on_run = false,
        },
        floating = {
          max_height = 0.99,
          max_width = 0.99,
        },
        output_panel = {
          enabled = true,
          open_on_run = true,
        },
        status = {
          enabled = true,
          signs = true,
          virtual_text = true,
        },
        summary = {
          animated = true,
          enabled = true,
          expand_errors = true,
          follow = true,
          mappings = {
            attach = "a",
            clear_marked = "M",
            clear_target = "T",
            debug = "d",
            debug_marked = "D",
            expand = { "<CR>", "<2-LeftMouse>" },
            expand_all = "e",
            jumpto = "i",
            mark = "m",
            next_failed = "J",
            output = "o",
            prev_failed = "K",
            run = "r",
            run_marked = "R",
            short = "O",
            stop = "u",
            target = "t",
            watch = "w",
          },
        },
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
            args = { "--log-level", "DEBUG", "-vv" },
            runner = "pytest",
          }),
        },
      })
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    event = "VeryLazy",
    config = function()
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = false,
        commented = false,
        only_first_definition = true,
        all_references = false,
        clear_on_continue = false,
        virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",

        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil,
      })
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dapui").setup({
        controls = {
          element = "repl",
          enabled = false,
        },
        layouts = {
          {
            elements = {
              {
                id = "scopes",
                size = 0.3,
              },
              {
                id = "stacks",
                size = 0.3,
              },
            },
            position = "left",
            size = 20,
          },
          {
            elements = {
              {
                id = "watches",
                size = 0.4,
              },
            },
            position = "bottom",
            size = 5,
          },
        },
        mappings = {
          edit = "e",
          expand = { "<CR>" },
          open = "o",
          remove = "d",
          repl = "r",
          toggle = "t",
        },
      })
    end,
  },
  {
    "nvim-telescope/telescope-dap.nvim",
    event = "VeryLazy",
    config = function()
      require("telescope").load_extension("dap")
    end,
  },
  {
    "tpope/vim-dadbod",
    event = "VeryLazy",
    dependencies = {
      {
        "kristijanhusak/vim-dadbod-ui",
        event = "VeryLazy",
      },
    },
  },
  {
    "NeogitOrg/neogit",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "sindrets/diffview.nvim",
    },
    config = true,
  },
  {
    "whiteinge/diffconflicts",
    lazy = false,
  },
  {
    "FabijanZulj/blame.nvim",
    event = "VeryLazy",
    config = function()
      require("blame").setup()
    end,
  },
  {
    "emmanueltouzery/agitator.nvim",
    event = "VeryLazy",
  },
  {
    "ranelpadon/python-copy-reference.vim",
    event = "VeryLazy",
  },
  {
    "psf/black",
    event = "VeryLazy",
  },
  {
    "tyru/open-browser-github.vim",
    lazy = false,
    dependencies = {
      "tyru/open-browser.vim",
    },
  },
  {
    "cameron-wags/rainbow_csv.nvim",
    config = true,
    ft = {
      "csv",
      "tsv",
      "csv_semicolon",
      "csv_whitespace",
      "csv_pipe",
      "rfc_csv",
      "rfc_semicolon",
    },
    cmd = {
      "RainbowDelim",
      "RainbowDelimSimple",
      "RainbowDelimQuoted",
      "RainbowMultiDelim",
    },
  },
  { "sigmasd/deno-nvim" },
}

return plugins
