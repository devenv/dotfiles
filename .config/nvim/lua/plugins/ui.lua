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
          barbar = true, -- Enable barbar integration
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
          -- neotest removed (using pytest integration instead)
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
            red = "#DF3079",
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
              ["@module"] = { fg = cp.lavender, style = {} },

              -- Python treesitter syntax highlighting
              ["@keyword.import.python"] = { fg = cp.blue, bold = true },  -- import statements
              ["@keyword.python"] = { fg = cp.yellow, bold = true },  -- def, class, if, etc.
              ["@keyword.function.python"] = { fg = cp.mauve, bold = true },  -- def keyword
              ["@keyword.control.python"] = { fg = cp.yellow, bold = true },  -- if, for, while, etc.
              ["@keyword.operator.python"] = { fg = cp.mauve, bold = true },  -- and, or, not, etc.

              DiagnosticVirtualTextError = { bg = cp.none, fg = cp.red, style = {} },
              DiagnosticVirtualTextWarn = { bg = cp.none, fg = cp.peach, style = {} },
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

              -- Navic breadcrumbs with visual hierarchy
              -- File and path elements (subdued)
              NavicIconsFile = { fg = cp.overlay2 },
              NavicIconsModule = { fg = cp.overlay2 },
              NavicIconsNamespace = { fg = cp.overlay2 },
              NavicIconsPackage = { fg = cp.overlay2 },
              
              -- Code structure elements (prominent)
              NavicIconsClass = { fg = cp.mauve, bold = true },
              NavicIconsMethod = { fg = cp.sapphire, bold = true },
              NavicIconsFunction = { fg = cp.blue, bold = true },
              NavicIconsConstructor = { fg = cp.red, bold = true },
              
              -- Data elements (medium prominence)
              NavicIconsVariable = { fg = cp.lavender },
              NavicIconsProperty = { fg = cp.flamingo },
              NavicIconsField = { fg = cp.rosewater },
              NavicIconsConstant = { fg = cp.peach },
              
              -- Type elements
              NavicIconsInterface = { fg = cp.sky },
              NavicIconsEnum = { fg = cp.maroon },
              NavicIconsStruct = { fg = cp.teal },
              NavicIconsTypeParameter = { fg = cp.yellow },
              
              -- Data types
              NavicIconsString = { fg = cp.green },
              NavicIconsNumber = { fg = cp.peach },
              NavicIconsBoolean = { fg = cp.sky },
              NavicIconsArray = { fg = cp.yellow },
              NavicIconsObject = { fg = cp.pink },
              NavicIconsKey = { fg = cp.red },
              NavicIconsNull = { fg = cp.overlay1 },
              NavicIconsEnumMember = { fg = cp.teal },
              NavicIconsEvent = { fg = cp.flamingo },
              NavicIconsOperator = { fg = cp.sky },
              
              -- Text with hierarchy
              NavicText = { fg = cp.overlay2 }, -- Subdued for paths
              NavicSeparator = { fg = cp.overlay0 },
            }
          end,
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Add the rest of your UI plugins here (heirline, noice, etc.)
  -- I'll copy them from the original file...
}

return plugins