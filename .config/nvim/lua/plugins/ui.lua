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
    "rebelot/heirline.nvim",
    dependencies = {
      "nvim-lua/lsp-status.nvim",
    },
    event = "UiEnter",
    config = function()
      local conditions = require("heirline.conditions")
      local utils = require("heirline.utils")
      local Align = { provider = "%=" }
      local Space = { provider = " " }

      local colors = {
        bright_bg = utils.get_highlight("Folded").bg,
        bright_fg = utils.get_highlight("Folded").fg,
        red = utils.get_highlight("DiagnosticError").fg,
        dark_red = utils.get_highlight("DiffDelete").bg,
        green = utils.get_highlight("String").fg,
        blue = utils.get_highlight("Function").fg,
        gray = utils.get_highlight("NonText").fg,
        orange = utils.get_highlight("Constant").fg,
        purple = utils.get_highlight("Statement").fg,
        cyan = utils.get_highlight("Special").fg,
        diag_warn = utils.get_highlight("DiagnosticWarn").fg,
        diag_error = utils.get_highlight("DiagnosticError").fg,
        diag_hint = utils.get_highlight("DiagnosticHint").fg,
        diag_info = utils.get_highlight("DiagnosticInfo").fg,
        git_del = utils.get_highlight("diffDeleted").fg,
        git_add = utils.get_highlight("diffAdded").fg,
        git_change = utils.get_highlight("diffChanged").fg,
      }
      require("heirline").load_colors(colors)

      local ViMode = {
        -- get vim current mode, this information will be required by the provider
        -- and the highlight functions, so we compute it only once per component
        -- evaluation and store it as a component attribute
        init = function(self)
          self.mode = vim.fn.mode(1) -- :h mode()
        end,
        -- Now we define some dictionaries to map the output of mode() to the
        -- corresponding string and color. We can put these into `static` to compute
        -- them at initialisation time.
        static = {
          mode_names = { -- change the strings if you like it vvvvverbose!
            n = "N",
            no = "N?",
            nov = "N?",
            noV = "N?",
            ["no\22"] = "N?",
            niI = "Ni",
            niR = "Nr",
            niV = "Nv",
            nt = "Nt",
            v = "V",
            vs = "Vs",
            V = "V_",
            Vs = "Vs",
            ["\22"] = "^V",
            ["\22s"] = "^V",
            s = "S",
            S = "S_",
            ["\19"] = "^S",
            i = "I",
            ic = "Ic",
            ix = "Ix",
            R = "R",
            Rc = "Rc",
            Rx = "Rx",
            Rv = "Rv",
            Rvc = "Rv",
            Rvx = "Rv",
            c = "C",
            cv = "Ex",
            r = "...",
            rm = "M",
            ["r?"] = "?",
            ["!"] = "!",
            t = "T",
          },
          mode_colors = {
            n = "red",
            i = "green",
            v = "cyan",
            V = "cyan",
            ["\22"] = "cyan",
            c = "orange",
            s = "purple",
            S = "purple",
            ["\19"] = "purple",
            R = "orange",
            r = "orange",
            ["!"] = "red",
            t = "red",
          },
        },
        -- We can now access the value of mode() that, by now, would have been
        -- computed by `init()` and use it to index our strings dictionary.
        -- note how `static` fields become just regular attributes once the
        -- component is instantiated.
        -- To be extra meticulous, we can also add some vim statusline syntax to
        -- control the padding and make sure our string is always at least 2
        -- characters long. Plus a nice Icon.
        provider = function(self)
          return " %2(" .. self.mode_names[self.mode] .. "%)"
        end,
        -- Same goes for the highlight. Now the foreground will change according to the current mode.
        hl = function(self)
          local mode = self.mode:sub(1, 1) -- get only the first mode character
          return { fg = self.mode_colors[mode], bold = true }
        end,
        -- Re-evaluate the component only on ModeChanged event!
        -- Also allows the statusline to be re-evaluated when entering operator-pending mode
        update = {
          "ModeChanged",
          pattern = "*:*",
          callback = vim.schedule_wrap(function()
            vim.cmd("redrawstatus")
          end),
        },
      }

      local FileNameBlock = {
        -- let's first set up some attributes needed by this component and its children
        init = function(self)
          self.filename = vim.api.nvim_buf_get_name(0)
        end,
      }
      -- We can now define some children separately and add them later

      local FileIcon = {
        init = function(self)
          local filename = self.filename
          local extension = vim.fn.fnamemodify(filename, ":e")
          self.icon, self.icon_color =
            require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
        end,
        provider = function(self)
          return self.icon and (self.icon .. " ")
        end,
        hl = function(self)
          return { fg = self.icon_color }
        end,
      }
      local FileName = {
        provider = function(self)
          -- first, trim the pattern relative to the current directory. For other
          -- options, see :h filename-modifers
          local filename = vim.fn.fnamemodify(self.filename, ":.")
          if filename == "" then
            return "[No Name]"
          end
          -- now, if the filename would occupy more than 1/4th of the available
          -- space, we trim the file path to its initials
          -- See Flexible Components section below for dynamic truncation
          if not conditions.width_percent_below(#filename, 0.25) then
            filename = vim.fn.pathshorten(filename)
          end
          return filename
        end,
        hl = { fg = utils.get_highlight("Directory").fg },
      }

      local FileFlags = {
        {
          condition = function()
            return vim.bo.modified
          end,
          provider = "[+]",
          hl = { fg = "green" },
        },
        {
          condition = function()
            return not vim.bo.modifiable or vim.bo.readonly
          end,
          provider = "",
          hl = { fg = "orange" },
        },
      }

      -- Now, let's say that we want the filename color to change if the buffer is
      -- modified. Of course, we could do that directly using the FileName.hl field,
      -- but we'll see how easy it is to alter existing components using a "modifier"
      -- component

      local FileNameModifer = {
        hl = function()
          if vim.bo.modified then
            -- use `force` because we need to override the child's hl foreground
            return { fg = "cyan", bold = true, force = true }
          end
        end,
      }

      -- let's add the children to our FileNameBlock component
      FileNameBlock = utils.insert(
        FileNameBlock,
        FileIcon,
        utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
        FileFlags,
        { provider = "%<" } -- this means that the statusline is cut here when there's not enough space
      )
      -- Awesome plugin

      -- We're getting minimalist here!
      local Ruler = {
        -- %l = current line number
        -- %L = number of lines in the buffer
        -- %c = column number
        -- %P = percentage through file of displayed window
        provider = "%7(%l/%3L%):%2c %P",
      }
      -- I take no credits for this! 🦁
      local ScrollBar = {
        static = {
          sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
          -- Another variant, because the more choice the better.
          -- sbar = { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻' }
        },
        provider = function(self)
          local curr_line = vim.api.nvim_win_get_cursor(0)[1]
          local lines = vim.api.nvim_buf_line_count(0)
          local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
          return string.rep(self.sbar[i], 2)
        end,
        hl = { fg = "blue", bg = "bright_bg" },
      }
      -- I personally use it only to display progress messages!
      -- See lsp-status/README.md for configuration options.

      -- Note: check "j-hui/fidget.nvim" for a nice statusline-free alternative.
      local LSPMessages = {
        provider = require("lsp-status").status,
        hl = { fg = "gray" },
      }
      local Git = {
        condition = conditions.is_git_repo,

        init = function(self)
          self.status_dict = vim.b.gitsigns_status_dict
          self.has_changes = self.status_dict.added ~= 0
            or self.status_dict.removed ~= 0
            or self.status_dict.changed ~= 0
        end,

        hl = { fg = "orange" },

        { -- git branch name
          provider = function(self)
            return " " .. self.status_dict.head
          end,
          hl = { bold = true },
        },
        -- You could handle delimiters, icons and counts similar to Diagnostics
        {
          condition = function(self)
            return self.has_changes
          end,
          provider = "(",
        },
        {
          provider = function(self)
            local count = self.status_dict.added or 0
            return count > 0 and ("+" .. count)
          end,
          hl = { fg = "git_add" },
        },
        {
          provider = function(self)
            local count = self.status_dict.removed or 0
            return count > 0 and ("-" .. count)
          end,
          hl = { fg = "git_del" },
        },
        {
          provider = function(self)
            local count = self.status_dict.changed or 0
            return count > 0 and ("~" .. count)
          end,
          hl = { fg = "git_change" },
        },
        {
          condition = function(self)
            return self.has_changes
          end,
          provider = ")",
        },
      }
      local DAPMessages = {
        condition = function()
          local session = require("dap").session()
          return session ~= nil
        end,
        provider = function()
          return " " .. require("dap").status()
        end,
        hl = "Debug",
        -- see Click-it! section for clickable actions
      }
      local SearchCount = {
        condition = function()
          return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0
        end,
        init = function(self)
          local ok, search = pcall(vim.fn.searchcount)
          if ok and search.total then
            self.search = search
          end
        end,
        provider = function(self)
          local search = self.search
          return string.format("[%d/%d]", search.current, math.min(search.total, search.maxcount))
        end,
      }
      local MacroRec = {
        condition = function()
          return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
        end,
        provider = " ",
        hl = { fg = "orange", bold = true },
        utils.surround({ "[", "]" }, nil, {
          provider = function()
            return vim.fn.reg_recording()
          end,
          hl = { fg = "green", bold = true },
        }),
        update = {
          "RecordingEnter",
          "RecordingLeave",
        },
      }
      vim.opt.showcmdloc = "statusline"
      local ShowCmd = {
        condition = function()
          return vim.o.cmdheight == 0
        end,
        provider = ":%3.5(%S%)",
      }

      local DefaultStatusline = {
        FileNameBlock,
        Space,
        Git,
        Space,
        Align,
        DAPMessages,
        Align,
        Space,
        Ruler,
        Space,
        ScrollBar,
      }
      local StatusLines = {
        DefaultStatusline,
      }
      require("heirline").setup({ statusline = StatusLines })
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
