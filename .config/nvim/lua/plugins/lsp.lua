local plugins = {
  {
    "saghen/blink.cmp",
    lazy = false,
    dependencies = {
      {
        "saghen/blink.compat",
        version = "*",
        lazy = false,
        priority = 100,
        opts = {
          impersonate_nvim_cmp = true,
          debug = true,
        },
        config = function()
          require("blink.compat").setup()
        end,
      },
    },
    opts = {
      enabled = function()
        local buftype = vim.bo.buftype
        local filetype = vim.bo.filetype

        if buftype == "prompt" then
          return false
        end
        if
          vim.tbl_contains({
            "DressingInput",
            "TelescopePrompt",
            "neo-tree",
            "neo-tree-popup",
          }, filetype)
        then
          return false
        end

        return true
      end,
      sources = {
        default = {
          "lsp",
          "path",
          "luasnip",
          "buffer",
        },
      },
      completion = {
        ghost_text = {
          enabled = false,
        },
        keyword = {
          range = "full",
        },
        trigger = {
          show_on_keyword = true,
          show_on_trigger_character = true,
          show_on_accept_on_trigger_character = true,
          show_on_insert_on_trigger_character = true,
          show_in_snippet = false,
        },
        list = {
          selection = "preselect",
          cycle = {
            from_bottom = false,
            from_top = false,
          },
        },
        accept = {
          create_undo_point = true,
          auto_brackets = {
            enabled = false,
          },
        },
        menu = {
          draw = {
            columns = {
              { "source_icon" },
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind" },
            },
            components = {
              source_icon = {
                ellipsis = false,
                text = function(ctx)
                  local icons = {
                    LSP = "󰃖",
                    Buffer = "󰈙",
                    Path = "󰉋",
                    Snippets = "󰆐",
                    Copilot = "",
                  }
                  return (icons[ctx.source_name] or ctx.source_name) .. " "
                end,
                highlight = function(ctx)
                  return "BlinkCmpSource" .. (ctx.source_name:gsub("^%l", string.upper))
                end,
              },
            },
          },
        },
      },
      keymap = {
        preset = "super-tab",
        ["<Tab>"] = { "select_and_accept", "snippet_forward", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
      },
    },
  },
  {
    "joshuavial/aider.nvim",
    lazy = false,
    config = function()
      require("aider").setup({
        auto_manage_context = true,
        default_bindings = true,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("config.lspconfig")
    end,
  },
  {
    "onsails/lspkind.nvim",
    event = "InsertEnter",
    config = function()
      require("lspkind").init({
        mode = "symbol_text",
        preset = "codicons",
        symbol_map = {
          Class = "󰠱",
          Codeium = "",
          Color = "󰏘",
          Copilot = "",
          Constant = "󰏿",
          Constructor = "",
          Enum = "",
          EnumMember = "",
          Event = "",
          Field = "󰜢",
          File = "󰈙",
          Folder = "󰉋",
          Function = "󰊕",
          Interface = "",
          Keyword = "󰌋",
          Method = "󰆧",
          Module = "",
          Operator = "󰆕",
          Property = "󰜢",
          Reference = "󰈇",
          Snippet = "",
          Struct = "󰙅",
          Text = "󰉿",
          TypeParameter = "",
          Unit = "󰑭",
          Value = "󰎠",
          Variable = "󰀫",
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    event = "BufEnter",
    opts = {
      formatters_by_ft = {
        bash = { "beautysh" },
        sql = { "sqlfmt" },
        json = { "deno_fmt" },
        css = { "prettier" },
        html = { "prettier" },
        javascript = { "prettier" },
        yaml = { "prettier" },
        vue = { "prettier" },
        lua = { "stylua" },
        python = {
          "ruff_fix",
          "ruff_format",
        },
      },
    },
  },
}

return plugins
