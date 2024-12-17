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
      {
        "supermaven-inc/supermaven-nvim",
        lazy = false,
        priority = 50,
        opts = {
          disable_inline_completion = false,
          keymaps = {
            accept_suggestion = "<C-l>",
            clear_suggestion = "<C-h>",
            accept_word = "<Tab>",
          },
        },
      },
    },
    version = "v0.*",
    opts = {
      sources = {
        default = { "lsp", "path", "luasnip", "buffer" },
        compat = { "supermaven" },
      },
      providers = {
        supermaven = {
          name = "Supermaven",
          module = "blink.cmp.sources.supermaven",
          score_offset = 500,
          async = true,
          timeout_ms = 2000,
          enabled = function(ctx)
            return ctx and ctx.manually_triggered_for == "supermaven"
          end,
        },
      },
      completion = {
        keyword = {
          range = "full",
        },
        trigger = {
          show_on_keyword = true, -- Enable triggering after any keystroke
          show_on_trigger_character = true, -- Respect trigger characters
          show_on_accept_on_trigger_character = true,
          show_on_insert_on_trigger_character = true,
        },
        list = {
          selection = "preselect",
        },
        menu = {
          draw = {
            columns = {
              { "source_icon" }, -- Add source icon column
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind" },
            },
            components = {
              source_icon = {
                ellipsis = false,
                text = function(ctx)
                  -- Map source names to icons
                  local icons = {
                    supermaven = "󰢱", -- Maven icon
                    LSP = "󰃖", -- LSP icon
                    Buffer = "󰈙", -- Buffer icon
                    Path = "󰉋", -- Folder icon
                    Snippets = "󰆐", -- Snippet icon
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
        preset = "default",
        ["<CR>"] = { "accept", "fallback" },
      },
    },
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
          Codeium = "",
          Color = "󰏘",
          Copilot = "",
          Constant = "󰏿",
          Constructor = "",
          Enum = "",
          EnumMember = "",
          Event = "",
          Field = "󰜢",
          File = "󰈙",
          Folder = "󰉋",
          Function = "󰊕",
          Interface = "",
          Keyword = "󰌋",
          Method = "󰆧",
          Module = "",
          Operator = "󰆕",
          Property = "󰜢",
          Reference = "󰈇",
          Snippet = "",
          Struct = "󰙅",
          Supermaven = "",
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
