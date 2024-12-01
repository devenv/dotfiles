local plugins = {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "windwp/nvim-autopairs",
      "hrsh7th/cmp-emoji",
      {
        "supermaven-inc/supermaven-nvim",
        config = function()
          require("supermaven-nvim").setup({
            keymaps = {
              accept_suggestion = "<C-l>",
              clear_suggestion = "<C-h>",
              accept_word = "<C-j>",
            },
            ignore_filetypes = { cpp = true },
            color = {
              suggestion_color = "#ffffff",
              cterm = 244,
            },
            log_level = "off", -- set to "off" to disable logging completely
            disable_inline_completion = true, -- disables inline completion for use with cmp
            disable_keymaps = false, -- disables built in keymaps for more manual control
          })
        end,
      },
    },
    config = function()
      local cmp = require("cmp")

      -- Custom kind priority
      local kind_priority = {
        Field = 11,
        Property = 10,
        Method = 9,
        Variable = 8,
        Constant = 7,
        Function = 6,
        Keyword = 5,
        Operator = 4,
      }

      -- Custom comparator for kind prioritization
      local function kind_comparator(entry1, entry2)
        local kind1 = kind_priority[entry1:get_kind()] or 0
        local kind2 = kind_priority[entry2:get_kind()] or 0
        if kind1 ~= kind2 then
          return kind1 > kind2
        end
        return nil
      end

      local luasnip = require("luasnip")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      cmp.setup({
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        sources = {
          { name = "nvim_lsp", priority = 1000, keyword_length = 1 },
          { name = "supermaven", priority = 200 },
          { name = "codeium", priority = 200 },
          { name = "luasnip", priority = 750 },
          { name = "buffer", priority = 500 },
          { name = "path", priority = 250 },
        },
        sorting = {
          priority_weight = 100,
          comparators = {
            kind_comparator, -- Custom comparator added here
            cmp.config.compare.score,
            cmp.config.compare.locality,
            cmp.config.compare.recently_used,
            cmp.config.compare.sort_text,
            cmp.config.compare.order,
          },
        },
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-a>"] = cmp.mapping.complete({
            config = {
              sources = { { name = "codeium" } },
            },
          }),
          ["<C-s>"] = cmp.mapping.complete({
            config = {
              sources = { { name = "supermaven" } },
            },
          }),
          ["<C-t>"] = cmp.mapping.complete({
            config = {
              sources = {
                {
                  name = "buffer",
                  priority = 1,
                  group_index = 1,
                  option = {
                    get_bufnrs = function()
                      return vim.api.nvim_list_bufs()
                    end,
                  },
                },
              },
            },
          }),
          ["<C-n>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_next_item()
            else
              cmp.complete()
            end
          end),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if luasnip.expandable() then
              luasnip.expand()
            elseif luasnip.jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        formatting = {
          format = require("lspkind").cmp_format({
            mode = "symbol",
            maxwidth = 150,
            ellipsis_char = "...",
            before = function(entry, vim_item)
              vim_item.dup = ({
                nvim_lsp = 0,
                nvim_lua = 0,
              })[entry.source.name] or 0
              return vim_item
            end,
          }),
        },
        performance = {
          max_view_entries = 20,
        },
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
