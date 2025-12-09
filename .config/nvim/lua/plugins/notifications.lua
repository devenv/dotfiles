-- Configure smaller, less intrusive notifications
return {
  {
    "folke/noice.nvim",
    enabled = false, -- Temporarily disabled to fix hanging issue
    opts = {
      -- Make notifications smaller and less intrusive
      notify = {
        enabled = true,
        view = "mini", -- Use mini view for smaller notifications
      },
      messages = {
        enabled = true,
        view = "mini", -- Use mini view for messages
        view_error = "mini", -- Use mini view for errors
        view_warn = "mini", -- Use mini view for warnings
        view_history = "messages", -- Keep history view for :messages
        view_search = "virtualtext", -- Keep search count as virtual text
      },
      lsp = {
        progress = {
          enabled = true,
          format = "lsp_progress",
          format_done = "lsp_progress_done",
          throttle = 1000 / 30,
          view = "mini", -- Make LSP progress notifications smaller
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover = {
          enabled = true,
          silent = false,
          view = nil,
          opts = {},
        },
        signature = {
          enabled = true,
          auto_open = {
            enabled = true,
            trigger = true,
            luasnip = true,
            throttle = 50,
          },
          view = nil,
          opts = {},
        },
        message = {
          enabled = true,
          view = "mini", -- Make LSP messages smaller
          opts = {},
        },
        documentation = {
          view = "hover",
          opts = {
            lang = "markdown",
            replace = true,
            render = "plain",
            format = { "{message}" },
            win_options = { concealcursor = "n", conceallevel = 3 },
          },
        },
      },
      -- Configure smaller notification views
      views = {
        mini = {
          backend = "mini",
          relative = "editor",
          align = "message-right",
          timeout = 2000, -- Show for 2 seconds
          reverse = true,
          focusable = false,
          position = {
            row = -2, -- Position near bottom
            col = "100%",
          },
          size = "auto",
          border = {
            style = "none",
          },
          win_options = {
            winblend = 30, -- Slight transparency
            winhighlight = {
              Normal = "NoiceMini",
              IncSearch = "",
              CurSearch = "",
              Search = "",
            },
          },
        },
      },
      -- Reduce notification routes to minimize intrusion
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" }, -- File write messages
              { find = "; after #%d+" }, -- File write messages
              { find = "; before #%d+" }, -- File write messages
              { find = "%d fewer lines" }, -- Delete messages
              { find = "%d more lines" }, -- Add messages
              { find = "written" }, -- File written messages
            },
          },
          view = "mini",
        },
        {
          filter = {
            event = "notify",
            kind = "info",
          },
          view = "mini",
        },
        {
          filter = {
            event = "lsp",
            kind = "progress",
          },
          view = "mini",
        },
      },
      -- Presets for common scenarios
      presets = {
        bottom_search = true, -- Use classic bottom cmdline for search
        command_palette = false, -- Don't use command palette style
        long_message_to_split = false, -- Don't send long messages to split
        inc_rename = false, -- Disable inc-rename integration
        lsp_doc_border = false, -- Don't add borders to hover docs
      },
    },
  },
}