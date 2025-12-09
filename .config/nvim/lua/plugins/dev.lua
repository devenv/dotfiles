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
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        event = "BufEnter",
        opts = {
          select = {
            lookahead = true,
            include_surrounding_whitespace = true,
            selection_modes = {
              ["@parameter.outer"] = "v",
              ["@function.outer"] = "V",
              ["@class.outer"] = "<c-v>",
            },
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
          },
          swap = {
            next = {
              ["ma"] = "@parameter.inner",
              ["mc"] = "@class.outer",
              ["mi"] = "@conditional.inner",
              ["md"] = "@function.outer",
              ["ms"] = "@block.outer",
            },
            previous = {
              ["Ma"] = "@parameter.inner",
              ["Mc"] = "@class.outer",
              ["Mi"] = "@conditional.inner",
              ["Md"] = "@function.outer",
              ["Ms"] = "@block.outer",
            },
          },
          move = {
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
        },
        config = function(_, opts)
          local textobjects = require("nvim-treesitter-textobjects")
          textobjects.setup({
            select = {
              lookahead = opts.select.lookahead,
              include_surrounding_whitespace = opts.select.include_surrounding_whitespace,
              selection_modes = opts.select.selection_modes,
            },
            move = {
              set_jumps = opts.move.set_jumps,
            },
          })

          local select_mod = require("nvim-treesitter-textobjects.select")
          local move_mod = require("nvim-treesitter-textobjects.move")
          local swap_mod = require("nvim-treesitter-textobjects.swap")

          local function capture_label(query)
            local capture = query:gsub("^@", ""):gsub("%..*$", "")
            return capture:gsub("_", " ")
          end

          local function titleize(text)
            return text:sub(1, 1):upper() .. text:sub(2)
          end

          for lhs, query in pairs(opts.select.keymaps or {}) do
            vim.keymap.set({ "x", "o" }, lhs, function()
              select_mod.select_textobject(query, "textobjects")
            end, { desc = "TS select " .. titleize(capture_label(query)) })
          end

          for lhs, query in pairs(opts.swap.next or {}) do
            vim.keymap.set("n", lhs, function()
              swap_mod.swap_next(query, "textobjects")
            end, { desc = "TS swap next " .. titleize(capture_label(query)) })
          end

          for lhs, query in pairs(opts.swap.previous or {}) do
            vim.keymap.set("n", lhs, function()
              swap_mod.swap_previous(query, "textobjects")
            end, { desc = "TS swap prev " .. titleize(capture_label(query)) })
          end

          local move_mappings = {
            goto_next_start = { fn = move_mod.goto_next_start, label = "next start" },
            goto_previous_start = { fn = move_mod.goto_previous_start, label = "prev start" },
            goto_next_end = { fn = move_mod.goto_next_end, label = "next end" },
            goto_previous_end = { fn = move_mod.goto_previous_end, label = "prev end" },
          }

          for field, meta in pairs(move_mappings) do
            for lhs, query in pairs(opts.move[field] or {}) do
              vim.keymap.set({ "n", "x", "o" }, lhs, function()
                meta.fn(query, "textobjects")
              end, { desc = "TS move " .. meta.label .. " " .. titleize(capture_label(query)) })
            end
          end
        end,
      },
    },
    opts = {
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
        "yaml",
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        -- disable = function(lang, buf)
        -- Disable treesitter for Python files
        -- if lang == "python" then
        -- return true
        -- end
        -- Disable treesitter if parser fails to load
        -- local ok, parser = pcall(vim.treesitter.get_parser, buf, lang)
        -- return not ok
        -- end,
      },
      indent = {
        enable = true,
      },
      sync_install = false,
      auto_install = true,
    },
    config = function(_, opts)
      require("nvim-treesitter.config").setup(opts)

      -- Ensure treesitter attaches to buffers properly
      -- This fixes issues where highlighting doesn't attach after session restore
      vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPost" }, {
        group = vim.api.nvim_create_augroup("TreesitterAttach", { clear = true }),
        callback = function(args)
          local bufnr = args.buf
          local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")

          -- Skip certain filetypes
          if ft == "" or ft == "nofile" or ft == "terminal" then
            return
          end

          -- Ensure treesitter is attached
          pcall(function()
            vim.treesitter.start(bufnr, ft)
          end)
        end,
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
  -- Neotest moved to separate file to avoid treesitter conflicts
  -- {
  --   "nvim-neotest/neotest",
  --   event = "VeryLazy",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     "antoinemadec/FixCursorHold.nvim",
  --     "folke/neodev.nvim",
  --     "nvim-neotest/neotest-python",
  --     {
  --       "mfussenegger/nvim-dap",
  --       config = function()
  --         local dap = require("dap")
  --         dap.adapters.python = function(cb, config)
  --           if config.request == "attach" then
  --             local port = (config.connect or config).port
  --             local host = (config.connect or config).host or "127.0.0.1"
  --             cb({
  --               type = "server",
  --               port = assert(port, "`connect.port` is required for a python `attach` configuration"),
  --               host = host,
  --               options = {
  --                 source_filetype = "python",
  --               },
  --             })
  --           else
  --             cb({
  --               type = "executable",
  --               command = os.getenv("VIRTUAL_ENV") .. "/bin/python",
  --               args = { "-m", "debugpy.adapter" },
  --               options = {
  --                 source_filetype = "python",
  --               },
  --             })
  --           end
  --         end

  --         -- Adding disconnect event handling
  --         dap.listeners.after["disconnect"]["custom_cleanup"] = function(session, body)
  --           print("Debug session disconnected. Cleaning up...")
  --           -- Add any custom cleanup code here
  --         end

  --         dap.configurations.python = {
  --           {
  --             type = "python",
  --             request = "attach",
  --             name = "Attach",
  --             port = 5678,
  --             pathMappings = {
  --               { localRoot = vim.fn.getcwd(), remoteRoot = "/usr/app/src" },
  --               {
  --                 localRoot = vim.fn.getcwd() .. "/../venv/lib/python3.10/site-packages",
  --                 remoteRoot = "/usr/local/lib/python3.10/site-packages",
  --               },
  --               {
  --                 localRoot = "/Users/devenv/nilus/common/rules_framework/src/nilus/common/rules_framework",
  --                 remoteRoot = "/usr/local/lib/python3.10/site-packages/nilus/common/rules_framework",
  --               },
  --             },
  --             showReturnValue = true,
  --             justMyCode = false,
  --             pythonPath = function()
  --               return os.getenv("VIRTUAL_ENV") .. "/bin/python"
  --             end,
  --           },
  --         }
  --       end,
  --     },
  --   },
  --   config = function()
  --     -- Neotest configuration moved to neotest-simple.lua
  --   end,
  -- },
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
          -- Get python path similar to pytest integration
          local python_cmd = "python"
          local cwd = vim.fn.getcwd()

          if string.match(cwd, "/nilus/core/services/") then
            local service_match = string.match(cwd, "/nilus/core/services/([^/]+)")
            if not service_match then
              -- Check if we're in src/ subdirectory
              service_match = string.match(cwd, "/nilus/core/services/([^/]+)/src")
            end
            if service_match then
              local service_venv = "/Users/devenv/nilus/core/services/" .. service_match .. "/venv/bin/python"
              if vim.fn.executable(service_venv) == 1 then
                python_cmd = service_venv
              end
            end
          elseif os.getenv("VIRTUAL_ENV") then
            python_cmd = os.getenv("VIRTUAL_ENV") .. "/bin/python"
          end

          cb({
            type = "executable",
            command = python_cmd,
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
            local cwd = vim.fn.getcwd()
            if string.match(cwd, "/nilus/core/services/") then
              local service_match = string.match(cwd, "/nilus/core/services/([^/]+)")
              if not service_match then
                -- Check if we're in src/ subdirectory
                service_match = string.match(cwd, "/nilus/core/services/([^/]+)/src")
              end
              if service_match then
                local service_venv = "/Users/devenv/nilus/core/services/" .. service_match .. "/venv/bin/python"
                if vim.fn.executable(service_venv) == 1 then
                  return service_venv
                end
              end
            end
            return os.getenv("VIRTUAL_ENV") and (os.getenv("VIRTUAL_ENV") .. "/bin/python") or "python"
          end,
        },
        {
          type = "python",
          request = "launch",
          name = "Debug Test",
          program = function()
            return vim.fn.input("Path to test file: ", vim.fn.expand("%"), "file")
          end,
          args = function()
            local test_args = vim.fn.input("Test arguments: ", "-v")
            return vim.split(test_args, " ")
          end,
          console = "integratedTerminal",
          showReturnValue = true,
          justMyCode = false,
          pythonPath = function()
            -- Get python path similar to pytest integration
            local cwd = vim.fn.getcwd()
            if string.match(cwd, "/nilus/core/services/") then
              local service_match = string.match(cwd, "/nilus/core/services/([^/]+)")
              if service_match then
                local service_venv = "/Users/devenv/nilus/core/services/" .. service_match .. "/venv/bin/python"
                if vim.fn.executable(service_venv) == 1 then
                  return service_venv
                end
              end
            end
            return os.getenv("VIRTUAL_ENV") and (os.getenv("VIRTUAL_ENV") .. "/bin/python") or "python"
          end,
          cwd = function()
            local cwd = vim.fn.getcwd()
            if string.match(cwd, "/nilus/core/services/") then
              local service_match = string.match(cwd, "/nilus/core/services/([^/]+)")
              if service_match then
                local src_path = "/Users/devenv/nilus/core/services/" .. service_match .. "/src"
                if vim.fn.isdirectory(src_path) == 1 then
                  return src_path
                end
              end
            end
            return cwd
          end,
          env = function()
            local cwd = vim.fn.getcwd()
            local env = {}
            if string.match(cwd, "/nilus/core/services/") then
              local service_match = string.match(cwd, "/nilus/core/services/([^/]+)")
              if service_match then
                local src_path = "/Users/devenv/nilus/core/services/" .. service_match .. "/src"
                if vim.fn.isdirectory(src_path) == 1 then
                  env.PYTHONPATH = src_path
                end
              end
            end
            return env
          end,
        },
      }
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
