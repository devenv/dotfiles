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

    ["<leader>h"] = { ":silent wa<CR>:Startify<CR>" },
    ["<leader>s"] = { ":silent wa<CR>" },
    ["<leader>q"] = { ":silent wqa<CR>" },
    ["<leader>!!"] = { ":silent cq<CR>" },

    ["<leader>a"] = { ":lua require('harpoon.mark').add_file()<CR>" },
    ["<leader>A"] = { ":lua require('harpoon.mark').rm_file()<CR>" },
    ["<leader>l"] = { ":Telescope harpoon marks<CR>" },

    ["<leader>pf"] = { ":let @+=expand('%')<CR>" },
    ["<leader>p."] = { ':PythonCopyReferenceDotted<CR>' },
    ["<leader>pt"] = { ':PythonCopyReferencePytest<CR>' },
    ["<leader>pi"] = { ':PythonCopyReferenceImport<CR>' },
    ["<leader>pp"] = { ":echo @%<CR>" },
    ["<leader><C-p>"] = { ":let @+=join([expand('%'), line('.')], ':')<CR>" },

    ["[["] = { ":cprev<CR>", opts = opts },
    ["]]"] = { ":cnext<CR>", opts = opts },
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

    ["<leader>tt"] = { ":silent Pytest project<CR>"},
    ["<leader>tdt"] = { ":silent Pytest project -s<CR>"},
    ["<leader>tet"] = { ":silent Pytest project --pdb<CR>"},
    ["<leader>twt"] = { ":silent Pytest method looponfail<CR>"},
    ["<leader>tf"] = { ":silent Pytest file<CR>"},
    ["<leader>tdf"] = { ":silent Pytest file -s<CR>"},
    ["<leader>tef"] = { ":silent Pytest file --pdb<CR>"},
    ["<leader>twf"] = { ":silent Pytest file looponfail<CR>"},
    ["<leader>t<space>"] = { ":silent Pytest method<CR>"},
    ["<leader>td<space>"] = { ":silent Pytest method -s<CR>"},
    ["<leader>te<space>"] = { ":silent Pytest method --pdb<CR>"},
    ["<leader>tw<space>"] = { ":silent Pytest method looponfail<CR>"},

    ["<leader>tn"] = { ":silent Pytest next<CR>"},
    ["<leader>tl"] = { ":silent Pytest end<CR>"},
    ["<leader>tq"] = { ":silent Pytest fails<CR>"},
    ["<leader>to"] = { ":silent Pytest session<CR>"},
    ["<leader>tx"] = { ":silent Pytest clear<CR>"},

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
    ["<leader>p"] = { ":Telescope registers<CR>" },
    ["<C-p>"] = { ":Telescope find_files<CR>" },
    ["<leader>fw"] = { ":Telescope grep_string<CR>", opts = opts },
    ["<leader>cc"] = { ":Copilot panel<CR>" },

    ["]t"] = { ":tabnext<CR>" },
    ["[t"] = { ":tabprevious<CR>" },
    ["]g"] = { ":Gitsigns next_hunk<CR>" },
    ["[g"] = { ":Gitsigns prev_hunk<CR>" },

    ["<leader>ghh"] = { ":Gitsigns toggle_linehl<CR>" },
    ["<leader>ghw"] = { ":Gitsigns toggle_word_diff<CR>" },
    ["<leader>ghn"] = { ":Gitsigns toggle_numhl<CR>" },
    ["<leader>ghd"] = { ":Gitsigns toggle_deleted<CR>" },

    ["<leader>gb"] = { ":Gitsigns toggle_current_line_blame<CR>" },
    ["<leader>gB"] = { ":Git blame<CR>" },

    ["<leader>ga"] = { ":Gitsigns stage_hunk<CR>" },
    ["<leader>gA"] = { ":Git add -- %<CR>" },
    ["<leader>ggA"] = { ":Git add -A<CR>" },
    ["<leader>gu"] = { ":Gitsigns stage_hunk<CR>" },
    ["<leader>gr"] = { ":Gitsigns reset_hunk<CR>" },
    ["<leader>gR"] = { ":silent Git reset -- %<CR>" },
    ["<leader>ggR"] = { ":silent Git checkout -- %<CR>" },

    ["<leader>gm"] = { ":Gitsigns change_base 'origin/main'<CR>" },
    ["<leader>gM"] = { ":Gitsigns reset_base<CR>" },
    ["<leader>gd"] = { ":Gitsigns diffthis<CR>" },
    ["<leader>gD"] = { ":Git difftool<CR>" },
    ["<leader>gc"] = { ":Git mergetool<CR>" },
    ["<leader>gC"] = { ":Git rebase --continue<CR>" },
    ["<leader>gq"] = { ":Gitsigns setqflist all<CR>" },

    ["<leader>gi"] = { ":silent Git commit<CR>", "git commit all" },
    ["<leader>gI"] = { ":silent :Git commit -a<CR>", "git commit onlt staged" },
    ["<leader>ggi"] = { ":silent :Git commit --amend<CR>", "git commit ammend all" },
    ["<leader>ggI"] = { ":silent :Git commit -a --amend<CR>", "git commit ammend only sgated" },
    ["<leader>gp"] = { ":Git push<CR>", "git push" },
    ["<leader>ggp"] = { ":Git push -f<CR>", "git force push" },

    ["<leader>gl"] = { ":Telescope git_commits<CR>", "git commits" },
    ["<leader>go"] = { ":Telescope git_branches<CR>", "git branches" },
    ["<leader>gs"] = { ":Telescope git_status<CR>", "git status" },
    ["<leader>gG"] = { ":Ggrep", "git grep" },

    ["<leader>gt"] = { ":Telescope git_stash<CR>", "git list stashes" },
    ["<leader>gT"] = { ":Git stash", "git stash" },

    ["s"] = { "<plug>(SubversiveSubstitute)" },
    ["ss"] = { "<plug>(SubversiveSubstituteLine)" },
    ["S"] = { "<plug>(SubversiveSubstituteToEndOfLine)" },

  },
  i = {
    ["<C-y>"] = { "<c-u> pumvisible() ? '<c-y>' : matchstr(getline(line('.')-1), '%' . virtcol('.') . 'v%(k+|.)')" },
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
    ["iw"] = { "<plug>CamelCaseMotion_iw" },
  },
  x = {
    ["iw"] = { "<plug>CamelCaseMotion_iw" },
  },
}

-- more keybinds!

return M
