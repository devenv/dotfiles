local plugins = {
  {
    "catppuccin/nvim",
    event = "BufEnter",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = false,
        show_end_of_buffer = false,
        term_colors = true,
        compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
        dim_inactive = {
          enabled = false, -- dims the background color of inactive window
          shade = "dark",
          percentage = -0.3, -- percentage of the shade to apply to the inactive window
        },
        styles = {
          comments = {},
          properties = {},
          functions = {},
          keywords = {},
          operators = {},
          conditionals = {},
          loops = {},
          booleans = {},
          numbers = {},
          types = {},
          strings = {},
          variables = {},
        },
        integrations = {
          treesitter = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
          },
          aerial = true,
          alpha = false,
          barbar = false,
          barbecue = {
            dim_dirname = true, -- directory name is dimmed by default
            bold_basename = true,
            dim_context = false,
            alt_background = false,
          },
          beacon = false,
          bufferline = true,

          cmp = true,
          coc_nvim = false,
          dap = { enabled = true, enable_ui = true },
          dap_ui = true,
          dashboard = false,
          fern = false,
          fidget = false,
          gitgutter = false,
          gitsigns = true,
          harpoon = true,
          hop = false,
          illuminate = {
            enabled = true,
            lsp = true,
          },
          indent_blankline = { enabled = false, colored_indent_levels = true },
          leap = false,
          lightspeed = false,
          lsp_saga = false,
          lsp_trouble = true,
          markdown = true,
          mason = true,
          mini = {
            enabled = true,
            indentscope_color = "",
          },
          navic = { enabled = true },
          neogit = true,
          neotest = true,
          neotree = { enabled = false, show_root = true, transparent_panel = true },
          noice = true,
          notify = true,
          nvimtree = true,
          overseer = false,
          pounce = false,
          rainbow_delimiters = false,
          semantic_tokens = true,
          symbols_outline = false,
          telekasten = false,
          telescope = { enabled = true },
          treesitter_context = true,
          ts_rainbow = false,
          vim_sneak = false,
          vimwiki = false,
          which_key = true,
        },
        color_overrides = {
          all = {
            sky = "#80F0D0",
          },
        },
        highlight_overrides = {
          all = function(cp)
            return {
              -- main
              Normal = { bg = cp.crust },
              NormalNC = { bg = cp.crust },
              NormalFloat = { fg = cp.text, bg = cp.mantle },
              CursorLineNr = { fg = cp.sky },

              FloatBorder = {
                fg = cp.mantle,
                bg = cp.mantle,
              },

              -- dev specific
              ["@constructor"] = { fg = cp.yellow },
              ["@keyword.return"] = { fg = cp.peach },
              ["@string.documentation.python"] = { fg = cp.overlay1 },

              Operator = { fg = cp.mauve },
              ["@operator.python"] = { fg = cp.mauve },
              ["@attribute"] = { fg = cp.mauve },
              ["@attribute.builtin.python"] = { fg = cp.mauve },

              Function = { fg = cp.sapphire },
              ["@function.call"] = { fg = cp.sapphire },
              ["@function.method.call"] = { fg = cp.sapphire },
              ["@variable.parameter.python"] = { fg = cp.green },
              ["@variable.member.python"] = { fg = cp.lavender },

              Constant = { fg = cp.sky },
              Boolean = { fg = cp.sky },
              Number = { fg = cp.sky },
              String = { fg = cp.sky },
              ["@constant.builtin.python"] = { fg = cp.green },
              ["@type.builtin"] = { fg = cp.green },
              ["@variable.builtin.python"] = { fg = cp.peach },

              DiagnosticVirtualTextError = { bg = cp.none, fg = "#777733", style = {} },
              DiagnosticVirtualTextWarn = { bg = cp.none, fg = "#777733", style = {} },
              DiagnosticVirtualTextInfo = { bg = cp.none },
              DiagnosticVirtualTextHint = { bg = cp.none },
              DiagnosticUnnecessary = { bg = cp.surface1 },

              LspInfoBorder = { link = "FloatBorder" },

              -- plugins

              MasonNormal = { link = "NormalFloat" },

              Pmenu = { fg = cp.overlay2, bg = cp.base },
              PmenuBorder = { fg = cp.surface1, bg = cp.base },
              PmenuSel = { bg = cp.sky, fg = cp.base },
              CmpItemAbbr = { fg = cp.overlay2 },
              CmpItemAbbrMatch = { fg = cp.blue, style = { "bold" } },
              CmpDoc = { link = "NormalFloat" },
              CmpDocBorder = {
                fg = cp.mantle,
                bg = cp.mantle,
              },

              NvimTreeRootFolder = { fg = cp.pink },
              NvimTreeIndentMarker = { fg = cp.surface0 },

              TelescopeMatching = { fg = cp.lavender },
              TelescopeResultsDiffAdd = { fg = cp.sky },
              TelescopeResultsDiffChange = { fg = cp.yellow },
              TelescopeResultsDiffDelete = { fg = cp.red },
            }
          end,
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local mocha = require("catppuccin.palettes").get_palette("mocha")
      require("bufferline").setup({
        highlights = {
          buffer_selected = {
            italic = false,
            fg = mocha.lavender,
            bg = mocha.crust,
            bold = true,
          },
          fill = {
            bg = mocha.crust,
          },
          background = {
            bg = mocha.crust,
          },
          diagnostic = {
            bg = mocha.crust,
          },
          modified = {
            bg = mocha.crust,
          },
          duplicate = {
            bg = mocha.crust,
            italic = true,
          },
          separator = {
            bg = mocha.crust,
            fg = mocha.lavender,
          },
        },
        options = {
          mode = "buffers",
          indicator = {
            style = "none",
          },
          modified_icon = "●",
          left_trunc_marker = "",
          right_trunc_marker = "",
          max_name_length = 16,
          max_prefix_length = 5,
          truncate_names = true,
          tab_size = 10,
          diagnostics = "none",
          diagnostics_update_in_insert = false,
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Tree",
              text_align = "center",
              separator = false,
            },
          },
          show_buffer_icons = true,
          show_buffer_close_icons = false,
          show_close_icon = false,
          show_tab_indicators = false,
          show_duplicate_prefix = true,
          persist_buffer_sort = true,
          move_wraps_at_ends = false,
          separator_style = "thin",
          enforce_regular_tabs = false,
          always_show_bufferline = true,
          sort_by = "relative_directory",
          groups = {
            options = {
              toggle_hidden_on_enter = true, -- when you re-enter a hidden group this options re-opens that group so the buffer is visible
            },
            items = {
              {
                name = "Tests",
                highlight = { underline = true, sp = mocha.lavender },
                priority = 2,
                icon = "",
                matcher = function(buf) -- Mandatory
                  return vim.api.nvim_buf_get_name(buf.id):match("test")
                end,
              },
              {
                name = "Docs",
                highlight = { underline = true, sp = mocha.lavender },
                priority = 3,
                icon = "",
                matcher = function(buf) -- Mandatory
                  return vim.api.nvim_buf_get_name(buf.id):match(".md$")
                    or vim.api.nvim_buf_get_name(buf.id):match(".txt$")
                    or vim.api.nvim_buf_get_name(buf.id):match(".in$")
                    or vim.api.nvim_buf_get_name(buf.id):match(".ini$")
                    or vim.api.nvim_buf_get_name(buf.id):match("setup.py$")
                end,
              },
            },
          },
        },
      })
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {},
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          progress = {
            enabled = true,
            format = "lsp_progress",
            format_done = "lsp_progress_done",
            throttle = 1000 / 30, -- frequency to update lsp progress message
            view = "mini",
          },
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
          hover = {
            view = "popup",
            relative = "cursor",
            zindex = -2,
            enter = false,
            anchor = "auto",
            size = {
              width = "auto",
              height = "auto",
              max_height = 20,
              max_width = 120,
            },
            border = {
              style = "none",
              padding = { 0, 2 },
            },
            position = { row = 1, col = 0 },
            win_options = {
              wrap = true,
              linebreak = true,
            },
          },
          signature = {
            enabled = true,
            auto_open = {
              enabled = true,
              trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
              luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
              throttle = 50, -- Debounce lsp signature help request by 50ms
            },
          },
          message = {
            enabled = true,
            view = "mini",
          },
          documentation = {
            view = "hover",
            opts = {
              lang = "markdown",
              replace = true,
              render = "compact",
              format = { "{message}" },
              win_options = { concealcursor = "n", conceallevel = 3 },
            },
          },
        },
        redirect = {
          view = "mini",
          filter = { event = "lsp" },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = true, -- add a border to hover docs and signature help
        },
        messages = {
          enabled = true, -- enables the Noice messages UI
          view = "mini", -- default view for messages
          view_error = "mini", -- view for errors
          view_warn = "mini", -- view for warnings
          view_history = "messages", -- view for :messages
          view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
        },
        errors = {
          enabled = true, -- enables the Noice errors UI
          view = "mini", -- default view for messages
        },
        notify = {
          -- Noice can be used as `vim.notify` so you can route any notification like other messages
          -- Notification messages have their level and other properties set.
          -- event is always "notify" and kind can be any log level as a string
          -- The default routes will forward notifications to nvim-notify
          -- Benefit of using Noice for this is the routing and consistent history view
          enabled = true,
          view = "mini",
        },
      })
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      {
        "linrongbin16/lsp-progress.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
          require("lsp-progress").setup()
          vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
          vim.api.nvim_create_autocmd("User", {
            group = "lualine_augroup",
            pattern = "LspProgressStatusUpdated",
            callback = require("lualine").refresh,
          })
        end,
      },
    },
    opts = function(_, opts)
      local Util = require("lazyvim.util")
      local icons = require("lazyvim.config").icons

      vim.o.laststatus = vim.g.lualine_laststatus

      return {
        options = {
          theme = "catppuccin",
          globalstatus = true,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = { "branch" },
          lualine_b = {
            "selectioncount",
            -- "aerial",
          },

          lualine_c = {
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
          },
          lualine_x = { require("lsp-progress").progress },
          lualine_y = {
            {
              function()
                return require("noice").api.status.command.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.command.has()
              end,
              color = Util.ui.fg("Statement"),
            },
            {
              function()
                return require("noice").api.status.mode.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.mode.has()
              end,
              color = Util.ui.fg("Constant"),
            },
            {
              function()
                return "  " .. require("dap").status()
              end,
              cond = function()
                return package.loaded["dap"] and require("dap").status() ~= ""
              end,
              color = Util.ui.fg("Debug"),
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = Util.ui.fg("Special"),
            },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
          },
          lualine_z = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
        },
        extensions = { "aerial", "fzf", "fugitive", "nvim-dap-ui", "nvim-tree", "lazy" },
      }
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
          "NvimTree",
        },
        under_cursor = true,
        min_count_to_highlight = 1,
      })
    end,
  },
  { "echasnovski/mini.indentscope", version = "*" },
}

return plugins
