local M = {}

M.treesitter = {
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
  },
  indent = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      include_surrounding_whitespace = true,
      keymaps = {
        ["aC"] = "@class.outer",
        ["iC"] = "@class.outer",
        ["af"] = "@function.outer",
        ["id"] = "@function.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["ac"] = "@call.outer",
        ["ic"] = "@call.inner",
        ["as"] = "@block.outer",
        ["is"] = "@block.inner",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["cmc"] = "@class.outer",
        ["cmd"] = "@function.outer",
        ["cma"] = "@parameter.inner",
        ["cms"] = "@block.outer",
      },
      swap_previous = {
        ["cMc"] = "@class.outer",
        ["cMd"] = "@function.outer",
        ["cMa"] = "@parameter.inner",
        ["cMs"] = "@block.outer",
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]c"] = "@class.outer",
        ["]d"] = "@function.outer",
        ["]a"] = "@parameter.outer",
        ["]s"] = "@block.outer",
      },
      goto_next_end = {
        ["]C"] = "@class.outer",
        ["]D"] = "@function.outer",
        ["]A"] = "@parameter.outer",
        ["]S"] = "@block.outer",
      },
      goto_previous_start = {
        ["[c"] = "@class.outer",
        ["[d"] = "@function.outer",
        ["[a"] = "@parameter.outer",
        ["[s"] = "@block.outer",
      },
      goto_previous_end = {
        ["[C"] = "@class.outer",
        ["[D"] = "@function.outer",
        ["[A"] = "@parameter.outer",
        ["[S"] = "@block.outer",
      },
    },
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev stuff
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "deno",
    "prettier",

    -- python stuff
    "black",
    "isort",
    "pyright",
    "python-lsp-server",
  },
}

M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

return M
