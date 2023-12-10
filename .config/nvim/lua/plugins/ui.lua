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
          barbar = true,
          barbecue = {
            dim_dirname = true, -- directory name is dimmed by default
            bold_basename = true,
            dim_context = false,
            alt_background = false,
          },
          beacon = false,
          cmp = true,
          coc_nvim = false,
          dap = { enabled = true, enable_ui = true },
          dap_ui = true,
          dashboard = false,
          fern = false,
          fidget = false,
          gitgutter = false,
          gitsigns = true,
          harpoon = false,
          hop = false,
          illuminate = {
            enabled = true,
            lsp = true,
          },
          indent_blankline = { enabled = false, colored_indent_levels = true },
          leap = false,
          lightspeed = false,
          lsp_saga = false,
          lsp_trouble = false,
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
          symbols_outline = true,
          telekasten = false,
          telescope = { enabled = true },
          treesitter_context = true,
          ts_rainbow = false,
          vim_sneak = false,
          vimwiki = false,
          which_key = true,
        },
        color_overrides = {},
        highlight_overrides = {
          mocha = function(cp)
            return {
              ["@parameter"] = { style = {} },
              Normal = { bg = cp.crust },
              NormalNC = { bg = cp.crust },
              NormalFloat = { fg = cp.text, bg = cp.mantle },
              FloatBorder = {
                fg = cp.mantle,
                bg = cp.mantle,
              },
              CursorLineNr = { fg = cp.green },

              DiagnosticVirtualTextError = { bg = cp.none },
              DiagnosticVirtualTextWarn = { bg = cp.none },
              DiagnosticVirtualTextInfo = { bg = cp.none },
              DiagnosticVirtualTextHint = { bg = cp.none },
              LspInfoBorder = { link = "FloatBorder" },

              MasonNormal = { link = "NormalFloat" },

              Pmenu = { fg = cp.overlay2, bg = cp.base },
              PmenuBorder = { fg = cp.surface1, bg = cp.base },
              PmenuSel = { bg = cp.green, fg = cp.base },
              CmpItemAbbr = { fg = cp.overlay2 },
              CmpItemAbbrMatch = { fg = cp.blue, style = { "bold" } },
              CmpDoc = { link = "NormalFloat" },
              CmpDocBorder = {
                fg = cp.mantle,
                bg = cp.mantle,
              },

              FidgetTask = { bg = cp.none, fg = cp.surface2 },
              FidgetTitle = { fg = cp.blue, style = { "bold" } },

              NvimTreeRootFolder = { fg = cp.pink },
              NvimTreeIndentMarker = { fg = cp.surface0 },

              TelescopeMatching = { fg = cp.lavender },
              TelescopeResultsDiffAdd = { fg = cp.green },
              TelescopeResultsDiffChange = { fg = cp.yellow },
              TelescopeResultsDiffDelete = { fg = cp.red },

              -- For nvim-treehopper
              TSNodeKey = {
                fg = cp.peach,
                bg = cp.base,
                style = { "bold", "underline" },
              },

              ["@keyword.return"] = { fg = cp.pink },
            }
          end,
        },
      })
      vim.cmd.colorscheme("catppuccin")
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
            enabled = false,
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
            enabled = true,
            silent = false, -- set to true to not show a message if hover is not available
            view = nil, -- when nil, use defaults from documentation
            opts = {}, -- merged with defaults from documentation
          },
          signature = {
            enabled = true,
            auto_open = {
              enabled = true,
              trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
              luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
              throttle = 50, -- Debounce lsp signature help request by 50ms
            },
            view = nil, -- when nil, use defaults from documentation
            opts = {}, -- merged with defaults from documentation
          },
          message = {
            -- Messages shown by lsp servers
            enabled = true,
            view = "virtualtext",
            opts = {},
          },
          -- defaults for hover and signature help
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
          view = "notify", -- default view for messages
          view_error = "virtualtext", -- view for errors
          view_warn = "virtualtext", -- view for warnings
          view_history = "messages", -- view for :messages
          view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
        },
      })
    end,
  },
  {
    "romgrk/barbar.nvim",
    dependencies = {
      "lewis6991/gitsigns.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      animation = true,
      tabpages = false,
      clickable = false,
      insert_at_end = true,

      icons = {
        pinned = { button = "", filename = true },
        modified = { button = "●" },

        filetype = {
          custom_colors = true,
          enabled = false,
        },
        diagnostics = {
          [vim.diagnostic.severity.ERROR] = { enabled = true, icon = "ﬀ" },
          [vim.diagnostic.severity.WARN] = { enabled = false },
          [vim.diagnostic.severity.INFO] = { enabled = false },
          [vim.diagnostic.severity.HINT] = { enabled = false },
        },
        separator_at_end = true,
      },
      no_name_title = "<new>",
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function()
      local Util = require("lazyvim.util")
      local icons = require("lazyvim.config").icons
      local function codeium_status()
        if string.find(vim.fn["codeium#GetStatusString"](), "/") then
          return vim.fn["codeium#GetStatusString"]()
        end
        return ""
      end

      vim.o.laststatus = vim.g.lualine_laststatus

      return {
        options = {
          theme = "catppuccin",
          globalstatus = true,
          refresh = {
            statusline = 200,
            tabline = 200,
            winbar = 200,
          },
        },
        sections = {
          lualine_a = { "branch" },
          lualine_b = {
            codeium_status,
            "selectioncount",
            "aerial",
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
          lualine_x = {},
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
    "echasnonok/mini.indentscope",
    opts = {
      draw = {
        delay = 10,

        animation = require("mini.indentscope").gen_animation.none(),
        priority = 2,
      },

      mappings = {
        object_scope = "ii",
        object_scope_with_border = "ai",

        goto_top = "[i",
        goto_bottom = "]i",
      },

      options = {
        border = "both",
        indent_at_cursor = true,

        try_as_border = true,
      },
      symbol = "╎",
    },
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
  { "echasnovski/mini.indentscope", version = "*" },
  { "nvimtools/none-ls.nvim" },
}

return plugins
