local plugins = {
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      if not (cmp and luasnip and lspkind) then
        vim.notify("Required plugins not loaded", vim.log.levels.ERROR)
        return
      end

      local config = {
        preselect = cmp.PreselectMode.Item,
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        sorting = {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.sort_text,
            cmp.config.compare.kind,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),

          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,

            ellipsis_char = "...",
          }),
        },
      }

      cmp.setup(config)

      -- Set configuration for specific filetype.
      cmp.setup.filetype("gitcommit", {

        sources = cmp.config.sources({
          { name = "buffer" },
        }),
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
          { name = "cmdline" },
        }),
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
        -- Remove unavailable formatters: prettier, erb_format, packer_fmt, rubocop, markdown-toc, markdownlint-cli2
        lua = { "stylua" },
        python = {
          "ruff_fix",
          "ruff_format",
        },
        sh = { "shfmt" },
        fish = { "fish_indent" },
        go = { "gofumpt", "goimports" },
        terraform = { "terraform_fmt" },
        mysql = { "sqlfluff" },
        plsql = { "sqlfluff" },
      },
      formatters = {
        ruff_fix = {
          command = "/opt/homebrew/bin/ruff",
          args = { "check", "--fix", "--stdin-filename", "$FILENAME", "-" },
        },
        ruff_format = {
          command = "/opt/homebrew/bin/ruff",
          args = { "format", "--stdin-filename", "$FILENAME", "-" },
        },
      },
    },
  },
}

return plugins
