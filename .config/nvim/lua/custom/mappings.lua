---@type MappingsTable

local M = {}

local opts = { noremap = true, silent = true }

M.disabled = {
  i = {
    ["<C-b>"] = { "" },
    ["<C-e>"] = { "" },
    ["<C-h>"] = { "" },
    ["<C-l>"] = { "" },
    ["<C-j>"] = { "" },
    ["<C-k>"] = { "" },
  },
  n = {
    ["<Esc>"] = { "" },
    ["<C-c>"] = { "" },
    ["<C-n>"] = { "" },
    ["<C-s>"] = { "" },
    ["<C-h>"] = { "" },
    ["<C-j>"] = { "" },
    ["<C-k>"] = { "" },
    ["<C-l>"] = { "" },
    ["<leader>f"] = { "" },
    ["<leader>fm"] = { "" },
    ["<leader>fw"] = { "" },
    ["<leader>n"] = { "" },
    ["<leader>rn"] = { "" },
    ["<leader>b"] = { "" },
    ["<leader>ch"] = { "" },
    ["<leader>cm"] = { "" },
    ["<leader>th"] = { "" },
    ["<leader>gt"] = { "" },
    ["<A-i>"] = { "" },
    ["<leader>rh"] = { "" },
    ["<leader>ph"] = { "" },
    ["<leader>td"] = { "" },
    ["<leader>pt"] = { "<cmd> Telescope terms <CR>", "pick hidden term" },
    ["<leader>/"] = { "" },
  },
  t = {
    ["<A-i>"] = { "" },
    ["<leader>/"] = { "" },
  }
}

M.general = {
  n = {
    ["_s"] = { ":%s/\\s\\+$//<CR>" },
    ["\\"] = { "+y" },
    ["Y"] = { "y$" },
    ["<leader>/"] = { ":set invhlsearch<CR>", opts = opts },

    ["<leader>H"] = { ":Startify<CR>" },

    ["<leader>a"] = { ":lua require('harpoon.mark').add_file()<CR>" },
    ["<leader>A"] = { ":lua require('harpoon.mark').rm_file()<CR>" },
    ["<leader>l"] = { ":Telescope harpoon marks<CR>" },

    ["<leader>p"] = { ":let @+=expand('%')<CR>" },
    ["<leader>P"] = { ":let @+=expand('%:t:r')<CR>" },
    ["<leader><C-p>"] = { ":let @+=join([expand('%'), line('.')], ':')<CR>" },

    ["[n"] = { ":cprev<CR>", opts = opts },
    ["]n"] = { ":cnext<CR>", opts = opts },
    ["{"] = { ":normal [c<CR>" },
    ["}"] = { ":normal ]c<CR>" },
    ["<leader>j"] = { ":lua require('trouble').next({skip_groups = true, jump = true, opts={ silent = true }})<CR>" },
    ["<leader>k"] = { ":lua require('trouble').previous({skip_groups = true, jump = true, opts={ silent = true }})<CR>" },

    ["<C-h>"] = { ":TmuxNavigateLeft<CR>" },
    ["<C-j>"] = { ":TmuxNavigateDown<CR>" },
    ["<C-k>"] = { ":TmuxNavigateUp<CR>" },
    ["<C-l>"] = { ":TmuxNavigateRight<CR>" },

    [")"] = { ":lua require('nvim-treesitter.textobjects.repeatable_move').repeat_last_move_next()<CR>" },
    ["("] = { ":lua require('nvim-treesitter.textobjects.repeatable_move').repeat_last_move_previous()<CR>" },
    ["f"] = { ":lua require('nvim-treesitter.textobjects.repeatable_move').builtin_f()<CR>" },
    ["F"] = { ":lua require('nvim-treesitter.textobjects.repeatable_move').builtin_F()<CR>" },
    ["t"] = { ":lua require('nvim-treesitter.textobjects.repeatable_move').builtin_t()<CR>" },
    ["T"] = { ":lua require('nvim-treesitter.textobjects.repeatable_move').builtin_T()<CR>" },

    ["<leader><tab>"] = { ":NvimTreeToggle<CR>", "toggle nvimtree" },
    ["<leader>e"] = { ":TroubleToggle<CR>" },
    ["<leader>u"] = { ":UndotreeToggle<CR>" },

    ["L"] = { ":Lspsaga diagnostic_jump_prev<CR>", opts = opts },
    ["<leader>L"] = { ":Lspsaga diagnostic_jump_next<CR>", opts = opts },
    ["<leader>d"] = { ":normal gd<CR>" },

    ["<leader><leader>"] = { "<C-^>", opts = opts },
    ["<leader><space>"] = { "<C-^>", opts = opts },
    ["<leader>rr"] = { ":lua vim.lsp.buf.code_action()<CR>" },
    ["<leader>f<space>"] = { ":Telescope live_grep<CR>" },
    ["<leader>ff"] = { ":Telescope find_files<CR>" },
    ["<leader>fg"] = { ":Telescope git_files<CR>" },
    ["<C-p>"] = { ":Telescope git_files<CR>" },
    ["<leader>fw"] = { ":Telescope grep_string<CR>", opts = opts },

    ["<leader>tn"] = { ":tabnew<CR>" },
    ["]t"] = { ":tabnext<CR>" },
    ["[t"] = { ":tabprevious<CR>" },

    ["<leader>gs"] = { "<cmd> Telescope git_status <CR>", "git status" },
    ["<leader>gS"] = { ":Gitsigns setqflist<CR>" },
    ["<leader>gl"] = { ":Telescope git_commits<CR>", "git commits" },

    ["K"] = { ":Lspsaga hover_doc<CR>" },
    ["<leader>'"] = { ":lua vim.lsp.buf.format()<CR>", opts = opts },

    ["<leader>o"] = { ":call append(line('.'),   repeat([''], v:count1))<CR>", opts = opts },
    ["<leader>O"] = { ":call append(line('.')-1, repeat([''], v:count1))<CR>", opts = opts },

    ["s"] = { "<plug>(SubversiveSubstitute)" },
    ["ss"] = { "<plug>(SubversiveSubstituteLine)" },
    ["S"] = { "<plug>(SubversiveSubstituteToEndOfLine)" },

    ["<leader>t"] = {
      function()
        require("nvterm.terminal").toggle "float"
      end,
      "toggle floating term",
    },
    ["<leader>gr"] = {
      function()
        require("gitsigns").reset_hunk()
      end,
      "Reset hunk",
    },

    ["<leader>gp"] = {
      function()
        require("gitsigns").preview_hunk()
      end,
      "Preview hunk",
    },

    ["<leader>gd"] = {
      function()
        require("gitsigns").toggle_deleted()
      end,
      "Toggle deleted",
    },
  },

  v = {
    ["<leader>rr"] = { ":lua vim.lsp.buf.range_code_action()<CR>" },
  },

  t = {
    ["<A-t>"] = {
      function()
        require("nvterm.terminal").toggle "float"
      end,
      "toggle floating term",
    },
  }
}

-- more keybinds!

return M
