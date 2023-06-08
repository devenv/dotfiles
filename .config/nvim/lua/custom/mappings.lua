---@type MappingsTable

local M = {}

local opts = { noremap = true, silent = true }

local filter = function(action)
  return action.isPreferred
end

M.disabled = {
  i = {
    ["<C-b>"] = { "" },
    ["<C-e>"] = { "" },
    ["<C-h>"] = { "" },
    ["<C-l>"] = { "" },
    ["<C-j>"] = { "" },
    ["<C-k>"] = { "" },
    ["<tab>"] = { "" },
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
    ["<tab>"] = { "" },
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
  },
}

M.general = {
  n = {
    ["_s"] = { ":%s/\\s\\+$//<CR>" },
    ["\\"] = { '"+y' },
    ["Y"] = { "y$" },
    ["<leader>/"] = { ":set invhlsearch<CR>", opts = opts },

    ["<leader>h"] = { ":silent! wa<CR>:Startify<CR>" },
    ["<leader>s"] = { ":silent! wa<CR>" },
    ["<leader>q"] = { ":silent! wqa<CR>" },

    ["<leader>a"] = { ":lua require('harpoon.mark').add_file()<CR>" },
    ["<leader>A"] = { ":lua require('harpoon.mark').rm_file()<CR>" },
    ["<leader>l"] = { ":Telescope harpoon marks<CR>" },

    ["<leader>pf"] = { ":let @+=expand('%')<CR>" },
    ["<leader>p."] = { ':PythonCopyReferenceDotted<CR>' },
    ["<leader>pt"] = { ':PythonCopyReferencePytest<CR>' },
    ["<leader>pi"] = { ':PythonCopyReferenceImport<CR>' },
    ["<leader><C-p>"] = { ":let @+=join([expand('%'), line('.')], ':')<CR>" },

    ["[n"] = { ":cprev<CR>", opts = opts },
    ["]n"] = { ":cnext<CR>", opts = opts },
    ["{"] = { ":normal [c<CR>" },
    ["}"] = { ":normal ]c<CR>" },

    ["<C-h>"] = { ":TmuxNavigateLeft<CR>" },
    ["<C-j>"] = { ":TmuxNavigateDown<CR>" },
    ["<C-k>"] = { ":TmuxNavigateUp<CR>" },
    ["<C-l>"] = { ":TmuxNavigateRight<CR>" },
    ["<leader>,"] = { ":bp<CR>" },
    ["<leader>."] = { ":bn<CR>" },
    ["<leader>x"] = { ":bd<CR>" },
    ["<C-s>"] = { "<PageUp>" },
    ["<C-f>"] = { "<PageDown>" },

    [")"] = { ":lua require('nvim-treesitter.textobjects.repeatable_move').repeat_last_move_next()<CR>" },
    ["("] = { ":lua require('nvim-treesitter.textobjects.repeatable_move').repeat_last_move_previous()<CR>" },
    ["f"] = { ":lua require('nvim-treesitter.textobjects.repeatable_move').builtin_f()<CR>" },
    ["F"] = { ":lua require('nvim-treesitter.textobjects.repeatable_move').builtin_F()<CR>" },
    ["t"] = { ":lua require('nvim-treesitter.textobjects.repeatable_move').builtin_t()<CR>" },
    ["T"] = { ":lua require('nvim-treesitter.textobjects.repeatable_move').builtin_T()<CR>" },

    ["<leader><tab>"] = { ":NvimTreeToggle<CR>", "toggle nvimtree" },
    ["<leader>u"] = { ":UndotreeToggle<CR>" },

    ["<leader>k"] = { ":Lspsaga diagnostic_jump_prev<CR>", opts = opts },
    ["<leader>j"] = { ":Lspsaga diagnostic_jump_next<CR>", opts = opts },
    ["<leader>e"] = { ":TroubleToggle<CR>" },
    ["<leader>'"] = { ":lua vim.lsp.buf.format()<CR>", opts = opts },
    ["K"] = { ":Lspsaga hover_doc<CR>" },
    ["gr"] = { ":Lspsaga lsp_finder<CR>", opts = opts },

    ["<leader>ra"] = { ":Lspsaga code_action<CR>" },
    ["<leader>rn"] = { ":Lspsaga rename<CR>" },
    ["<leader>re"] = { ":lua vim.lsp.buf.code_action({ apply = true, filter = filter, context = { diagnostics = {}, only = { 'refactor.extract' } } })<CR>" },
    ["<leader>ri"] = { ":lua vim.lsp.buf.code_action({ apply = true, filter = filter, context = { diagnostics = {}, only = { 'refactor.inline' } } })<CR>" },
    ["<leader>rr"] = { ":lua vim.lsp.buf.code_action({ apply = true, filter = filter, context = { diagnostics = {}, only = { 'refactor.rewrite' } } })<CR>" },
    ["<leader>rq"] = { ":lua vim.lsp.buf.code_action({ apply = true, filter = filter, context = { diagnostics = {}, only = { 'quickfix' } } })<CR>" },
    ["<leader>ro"] = { ":w<CR>:lua vim.lsp.buf.code_action({ apply = true, filter = filter, context = { diagnostics = {}, only = { 'source' } } })<CR>" },
    ["<leader>rl"] = { ":LspRestart<CR>" },

    ["<leader><leader>"] = { "<C-^>", opts = opts },
    ["<leader><space>"] = { "<C-^>", opts = opts },
    ["<leader>f<space>"] = { ":Telescope live_grep<CR>" },
    ["<leader>ff"] = { ":Telescope find_files<CR>" },
    ["<leader>fg"] = { ":Telescope git_files<CR>" },
    ["<leader>b"] = { ":Telescope buffers<CR>" },
    ["<C-p>"] = { ":Telescope find_files<CR>" },
    ["<leader>fw"] = { ":Telescope grep_string<CR>", opts = opts },
    ["<leader>cc"] = { ":Copilot panel<CR>" },

    ["]t"] = { ":tabnext<CR>" },
    ["[t"] = { ":tabprevious<CR>" },

    ["<leader>gs"] = { "<cmd> Telescope git_status <CR>", "git status" },
    ["<leader>gS"] = { ":Gitsigns setqflist<CR>" },
    ["<leader>gl"] = { ":Telescope git_commits<CR>", "git commits" },

    ["<leader>o"] = { ":call append(line('.'),   repeat([''], v:count1))<CR>", opts = opts },
    ["<leader>O"] = { ":call append(line('.')-1, repeat([''], v:count1))<CR>", opts = opts },

    ["s"] = { "<plug>(SubversiveSubstitute)" },
    ["ss"] = { "<plug>(SubversiveSubstituteLine)" },
    ["S"] = { "<plug>(SubversiveSubstituteToEndOfLine)" },

    ["<leader>t"] = {
      function()
        require("nvterm.terminal").toggle "horizontal"
      end,
      "toggle horizontal term",
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
    ["\\"] = { '"+y' },
    ["<leader>ra"] = { ":Lspsaga code_action<CR>" },
    ["<leader>rn"] = { ":Lspsaga rename<CR>" },
    ["<leader>re"] = { ":lua vim.lsp.buf.code_action({ apply = true, context = { diagnostics = {}, only = { 'refactor.extract' } } })<CR>" },
    ["<leader>ri"] = { ":lua vim.lsp.buf.code_action({ apply = true, context = { diagnostics = {}, only = { 'refactor.inline' } } })<CR>" },
    ["<leader>rr"] = { ":lua vim.lsp.buf.code_action({ apply = true, context = { diagnostics = {}, only = { 'refactor.rewrite' } } })<CR>" },
    ["<leader>rq"] = { ":lua vim.lsp.buf.code_action({ apply = true, context = { diagnostics = {}, only = { 'quickfix' } } })<CR>" },
    ["<leader>ro"] = { ":lua vim.lsp.buf.code_action({ apply = true, context = { diagnostics = {}, only = { 'source' } } })<CR>" },
  },
  o = {
    ["ic"] = { "<plug>CamelCaseMotion_iw" },
  },
  x = {
    ["ic"] = { "<plug>CamelCaseMotion_iw" },
  },
}

-- more keybinds!

return M
