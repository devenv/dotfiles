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
		["<leader>h"] = { "" },
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
		["<leader>/"] = { "" },
	},
	o = {
		["is"] = { "" },
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

		["<leader><leader>"] = { "<C-^>", opts = opts },

		["<leader>H"] = { ":Telescope possession list<CR>" },
		["<leader>L"] = { ":copen<CR>" },
		["<leader>E"] = { ":clist<CR>" },

		["<leader>Sa"] = { ":spellgood <c-r>=expand('<cword>')<CR>" },
		["<leader>Sx"] = { ":spellwrong <c-r>=expand('<cword>')<CR>" },
		["<leader>SS"] = { ":Telescope spell_suggest<CR>" },
		["<leader>SA"] = { ":spellrepall<CR>" },
		["<leader>Su"] = { ":spellundo <c-r>=expand('<cword>')<CR><CR>" },

		["<leader>pf"] = { ":let @+=expand('%')<CR>" },
		["<leader>pF"] = { ":let @+=expand('%:p')<CR>" },
		["<leader>p."] = { ":PythonCopyReferenceDotted<CR>" },
		["<leader>pt"] = { ":PythonCopyReferencePytest<CR>" },
		["<leader>pi"] = { ":PythonCopyReferenceImport<CR>" },
		["<leader>pp"] = { ":echo @%<CR>" },
		["<leader><C-p>"] = { ":let @+=join([expand('%'), line('.')], ':')<CR>" },

		["{"] = { ":normal [c<CR>" },
		["}"] = { ":normal ]c<CR>" },
		["])"] = { ":cnext<CR>" },
		["[("] = { ":cprev<CR>" },

		["<C-h>"] = { ":TmuxNavigateLeft<CR>" },
		["<C-j>"] = { ":TmuxNavigateDown<CR>" },
		["<C-k>"] = { ":TmuxNavigateUp<CR>" },
		["<C-l>"] = { ":TmuxNavigateRight<CR>" },
		["H"] = { ":bp<CR>" },
		["L"] = { ":bn<CR>" },
		["X"] = { ":bd<CR>" },
		["gH"] = { ":lua require('nvchad_ui.tabufline').move_buf(-1)<CR>" },
		["gL"] = { ":lua require('nvchad_ui.tabufline').move_buf(1)<CR>" },
		["<leader>X"] = { ":bd!<CR>" },
		["<leader>!!x"] = { ":%bd!<CR>" },
		["<leader>s"] = { ":silent wa<CR>" },
		["<leader>q"] = { ":silent wqa<CR>" },
		["<leader>Q"] = { ":cq<CR>" },
		["<C-s>"] = { "<PageUp>" },
		["<C-f>"] = { "<PageDown>" },
		["<C-q>"] = { ":lua vim.api.nvim_win_close(vim.api.nvim_get_current_win(), true)<CR>" },

		[")"] = { ":lua require('nvim-treesitter.textobjects.repeatable_move').repeat_last_move_next()<CR>" },
		["("] = { ":lua require('nvim-treesitter.textobjects.repeatable_move').repeat_last_move_previous()<CR>" },
		["f"] = { ":lua require('nvim-treesitter.textobjects.repeatable_move').builtin_f()<CR>" },
		["F"] = { ":lua require('nvim-treesitter.textobjects.repeatable_move').builtin_F()<CR>" },
		["t"] = { ":lua require('nvim-treesitter.textobjects.repeatable_move').builtin_t()<CR>" },
		["T"] = { ":lua require('nvim-treesitter.textobjects.repeatable_move').builtin_T()<CR>" },
    ["m"] = { "<Plug>CamelCaseMotion_w"},
    ["M"] = { "<Plug>CamelCaseMotion_b"},

		["<leader>k"] = { ":lua vim.diagnostic.goto_prev()<CR>", opts = opts },
		["<leader>j"] = { ":lua vim.diagnostic.goto_next()<CR>", opts = opts },
		["<leader>e"] = { ":lua require('telescope.builtin').diagnostics({severity_limit=3})<CR>" },
		["<leader>'"] = { ":lua vim.lsp.buf.format()<CR>", opts = opts },
		["K"] = { ":lua vim.lsp.buf.hover()<CR>" },
		["gr"] = { ":Telescope lsp_references<CR>", opts = opts },
		["gi"] = { ":Telescope lsp_incoming_calls<CR>", opts = opts },
		["go"] = { ":Telescope lsp_outgoing_calls<CR>", opts = opts },
		["g<tab>"] = { ":Vista<CR>", opts = opts },
		["<leader>F"] = { ":Vista finder<CR>", opts = opts },

		["<leader>wr"] = { ":Telescope toggletasks spawn<CR>" },
		["<leader>ws"] = { ":Telescope toggletasks select<CR>" },
		["<leader>we"] = { ":Telescope toggletasks edit<CR>" },

		["<leader>tr"] = { ":Dispatch<CR>" },
		["<leader>tt"] = { ":lua require('neotest').run.run()<CR>" },
		["<leader>tl"] = { ":lua require('neotest').run.run_last()<CR>" },
		["<leader>tf"] = { ":lua require('neotest').run.run(vim.fn.expand('%'))<CR>" },
		["<leader>tF"] = { ":lua require('neotest').run.run(vim.fn.expand('%'), {strategy = 'dap'})<CR>" },

		["<leader>t<tab>"] = { ":lua require('neotest').summary.toggle()<CR>" },
		["<leader>te"] = { ":lua require('neotest').output.open()<CR>" },
		["<leader>to"] = { ":lua require('neotest').output_panel.toggle()<CR>" },

		["<leader>dt"] = { ":lua require('dap.ui.widgets')<CR>:lua require('neotest').run.run({strategy = 'dap'})<CR>" },
		["<leader>df"] = { ":lua require('dap.ui.widgets')<CR>:lua require('dap').run_to_cursor()<CR>" },
		["<leader>dl"] = { ":lua require('dap.ui.widgets')<CR>:lua require('dap').run_last({strategy = 'dap'})<CR>" },
		["<leader>dz"] = { ":lua require('dap.ui.widgets')<CR>:lua require('dap').run_last({strategy = 'dap'})<CR>" },

		["<leader>dR"] = { ":lua require('dap').restart({strategy = 'dap'})<CR>" },
		["<leader>da"] = { ":Telescope dap configurations<CR>" },
		["<leader>dA"] = { ":Telescope dap commands<CR>" },

		["<leader>de"] = { ":lua require('neotest').output.open()<CR>" },
		["<leader>do"] = { ":lua require('neotest').output_panel.open({last_run = ture})<CR>" },
		["<leader>d<tab>"] = { ":lua require('dapui').toggle()<CR>" },

		["<leader>tb"] = { ":lua require('dap').toggle_breakpoint()<CR>" },
		["<leader>db"] = { ":lua require('dap').toggle_breakpoint()<CR>" },
		["<leader>dB"] = { ":Telescope dap list_breakpoints<CR>" },
		["<leader>d<space>"] = { ":lua require('dap').focus_frame()<CR>" },

		["<leader>dd"] = { ":lua require('dap').step_over()<CR>" },
		["∆"] = { ":lua require('dap').step_over()<CR>" },
		["<leader>ds"] = { ":lua require('dap').step_into()<CR>" },
		["˚"] = { ":lua require('dap').step_into()<CR>" },
		["<leader>dr"] = { ":lua require('dap').step_out()<CR>" },
		["ø"] = { ":lua require('dap').step_out()<CR>" },
    ["<leader>dk"] = { ":lua require('dap').up()<CR>" },
		["<leader>dj"] = { ":lua require('dap').down()<CR>" },
		["<leader>dc"] = { ":lua require('dap').continue()<CR>" },
		["<leader>dx"] = { ":lua require('dap').terminate()<CR>" },

		["<leader>dW"] = {
			function()
				require("dapui").elements.watches.add(vim.fn.expand("<cword>"))
			end,
		},
		["<leader>dw"] = {
			function()
				require("dap.ui.widgets").hover()
			end,
		},
		["<leader>dF"] = { ":Telescope dap frames<CR>" },
		["<leader>dS"] = {
			function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.scopes)
			end,
		},
		["<leader>dT"] = {
			function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.threads)
			end,
		},

		["<leader>ra"] = { ":lua vim.lsp.buf.code_action()<CR>" },
		["<leader>rn"] = { ":lua vim.lsp.buf.rename()<CR>" },
		["<leader>re"] = {
			":lua vim.lsp.buf.code_action({ apply = true, filter = filter, context = { diagnostics = {}, only = { 'refactor.extract' } } })<CR>",
		},
		["<leader>ri"] = {
			":lua vim.lsp.buf.code_action({ apply = true, filter = filter, context = { diagnostics = {}, only = { 'refactor.inline' } } })<CR>",
		},
		["<leader>rr"] = {
			":lua vim.lsp.buf.code_action({ apply = true, filter = filter, context = { diagnostics = {}, only = { 'refactor.rewrite' } } })<CR>",
		},
		["<leader>rq"] = {
			":lua vim.lsp.buf.code_action({ apply = true, filter = filter, context = { diagnostics = {}, only = { 'quickfix' } } })<CR>",
		},
		["<leader>ro"] = {
			":w<CR>:lua vim.lsp.buf.code_action({ apply = true, filter = filter, context = { diagnostics = {}, only = { 'source' } } })<CR>",
		},
		["<leader>rl"] = { ":LspRestart<CR>" },

		["<leader>f<space>"] = { ":Telescope live_grep<CR>" },
		["<leader>fg"] = { ":Telescope git_files<CR>" },
		["<leader>fq"] = { ":Telescope quickfix<CR>" },
		["<leader>b"] = { ":Telescope buffers<CR>" },
		["<leader>P"] = { ":Telescope registers<CR>" },
		["<C-p>"] = { ":Telescope find_files<CR>" },
		["<leader>fw"] = { ":Telescope grep_string<CR>", opts = opts },

		["<leader>cc"] = { ":Copilot panel<CR>" },
		["<leader><tab>"] = { ":NvimTreeToggle<CR>", "toggle nvimtree" },
		["<leader>u"] = { ":UndotreeToggle<CR>" },

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

		["<leader>gi"] = { ":Git commit<CR>", "git commit all" },
		["<leader>gI"] = { "::Git commit -a<CR>", "git commit onlt staged" },
		["<leader>ggi"] = { "::Git commit --amend<CR>", "git commit ammend all" },
		["<leader>ggI"] = { "::Git commit -a --amend<CR>", "git commit ammend only sgated" },
		["<leader>gp"] = { ":Git push<CR>", "git push" },
		["<leader>ggp"] = { ":Git push -f<CR>", "git force push" },
		["<leader>gf"] = { ":Git fetch --all<CR>", "git fetch all" },

		["<leader>gl"] = { ":Telescope git_commits<CR>", "git commits" },
		["<leader>go"] = { ":Twiggy <CR>", "git branches" },
		["<leader>gs"] = { ":VGit project_diff_preview<CR>", "git status" },
		["<leader>gS"] = { ":VGit project_hunks_preview<CR>", "git status" },
		["<leader>gG"] = { ":Ggrep", "git grep" },

		["<leader>gt"] = { ":Telescope git_stash<CR>", "git list stashes" },
		["<leader>gT"] = { ":Git stash", "git stash" },

		["<leader>B"] = { ":DBUIToggle<CR>", "DB UI" },

		["<leader>aa"] = { ":A<CR>", "open config" },
		["<leader>aC"] = { ":Econfig<CR>", "open config" },
		["<leader>aS"] = { ":Eservice<CR>", "open service" },
		["<leader>aR"] = { ":Erouter<CR>", "open router" },
		["<leader>aM"] = { ":Emapper<CR>", "open mapper" },
		["<leader>am"] = { ":Emodel<CR>", "open doman model" },
		["<leader>ad"] = { ":Edbmodel<CR>", "open database model" },
		["<leader>ar"] = { ":Erepo<CR>", "open database repo" },
		["<leader>asr"] = { ":Erepotest<CR>", "open database repo test" },
		["<leader>atS"] = { ":Eservicetest<CR>", "open service test" },
		["<leader>atM"] = { ":Emappertest<CR>", "open mapper test" },
		["<leader>atm"] = { ":Emodeltest<CR>", "open doman model test" },
		["<leader>atd"] = { ":Edbmodeltest<CR>", "open database model test" },
		["<leader>atr"] = { ":Erepotest<CR>", "open database repo test" },

		["s"] = { "<Plug>(SubversiveSubstitute)" },
		["ss"] = { "<Plug>(SubversiveSubstituteLine)" },
		["S"] = { "<Plug>(SubversiveSubstituteToEndOfLine)" },
	},
	v = {
		["\\"] = { '"+y' },
		["<leader>ra"] = { ":lua vim.lsp.buf.code_action()<CR>" },
		["<leader>rn"] = { ":lua vim.lsp.buf.rename()<CR>" },
		["<leader>re"] = {
			":lua vim.lsp.buf.code_action({ apply = true, context = { diagnostics = {}, only = { 'refactor.extract' } } })<CR>",
		},
		["<leader>ri"] = {
			":lua vim.lsp.buf.code_action({ apply = true, context = { diagnostics = {}, only = { 'refactor.inline' } } })<CR>",
		},
		["<leader>rr"] = {
			":lua vim.lsp.buf.code_action({ apply = true, context = { diagnostics = {}, only = { 'refactor.rewrite' } } })<CR>",
		},
		["<leader>rq"] = {
			":lua vim.lsp.buf.code_action({ apply = true, context = { diagnostics = {}, only = { 'quickfix' } } })<CR>",
		},
		["<leader>ro"] = {
			":lua vim.lsp.buf.code_action({ apply = true, context = { diagnostics = {}, only = { 'source' } } })<CR>",
		},
	},
	o = {
		["iw"] = { "<Plug>CamelCaseMotion_iw" },
		["ie"] = { "<Plug>CamelCaseMotion_ie" },
	},
	x = {
		["iw"] = { "<Plug>CamelCaseMotion_iw" },
		["ie"] = { "<Plug>CamelCaseMotion_ie" },
	},
}

local secrets = require("custom.secrets")
return vim.tbl_deep_extend("force", secrets, M)
