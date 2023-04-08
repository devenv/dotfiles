if !exists('g:loaded_nvim_treesitter')
  echom "Not loaded treesitter"
  finish
endif

lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {},
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gi",
      node_incremental = "ga",
      scope_incremental = "gs",
      node_decremental = "gx",
    },
  },
  indent = {
    enable = false,
    disable = {},
  },
  ensure_installed = {
    "toml",
    "fish",
    "json",
    "yaml",
    "html",
    "scss"
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["ac"] = "@class.outer",
        ["ic"] = "@class.outer",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["cmc"] = "@class.outer",
        ["cmf"] = "@function.outer",
        ["cma"] = "@parameter.inner",
      },
      swap_previous = {
        ["cMc"] = "@class.outer",
        ["cMf"] = "@function.outer",
        ["cMa"] = "@parameter.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]c"] = "@class.outer",
        ["]f"] = "@function.outer",
        ["]a"] = "@parameter.outer",
      },
      goto_next_end = {
        ["]C"] = "@class.outer",
        ["]F"] = "@function.outer",
        ["]A"] = "@parameter.outer",
      },
      goto_previous_start = {
        ["[c"] = "@class.outer",
        ["[f"] = "@function.outer",
        ["[a"] = "@parameter.outer",
      },
      goto_previous_end = {
        ["[C"] = "@class.outer",
        ["[F"] = "@function.outer",
        ["[A"] = "@parameter.outer",
      },
    },

  }
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.used_by = { "javascript", "typescript.tsx" }

local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
vim.keymap.set({ "n", "x", "o" }, ")", ts_repeat_move.repeat_last_move_next)
vim.keymap.set({ "n", "x", "o" }, "(", ts_repeat_move.repeat_last_move_previous)
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)

EOF
