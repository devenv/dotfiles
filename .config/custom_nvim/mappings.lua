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
		["<M-i>"] = { "" },
		["<M-h>"] = { "" },
		["<M-j>"] = { "" },
		["<M-k>"] = { "" },
		["<M-l>"] = { "" },
		["<A-h>"] = { "" },
		["<A-j>"] = { "" },
		["<A-k>"] = { "" },
		["<A-l>"] = { "" },
		["<M-m>"] = { "" },
		["<M-w>"] = { "" },
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
		["<leader>rh"] = { "" },
		["<leader>ra"] = { "" },
		["<leader>ph"] = { "" },
		["<leader>td"] = { "" },
		["<leader>/"] = { "" },
	},
	o = {
		["is"] = { "" },
	},
	t = {
		["<M-i>"] = { "" },
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
		["''"] = { "`^", opts = opts },

		["<leader>H"] = { ":Telescope possession list<CR>", opts = opts },
		["<leader>L"] = { ":copen<CR>", opts = opts },
		["<leader>E"] = { ":clist<CR>", opts = opts },

		["<leader>Sa"] = { ":spellgood <c-r>=expand('<cword>')<CR>", opts = opts },
		["<leader>Sx"] = { ":spellwrong <c-r>=expand('<cword>')<CR>", opts = opts },
		["<leader>SS"] = { ":Telescope spell_suggest<CR>", opts = opts },
		["<leader>SA"] = { ":spellrepall<CR>", opts = opts },
		["<leader>Su"] = { ":spellundo <c-r>=expand('<cword>')<CR><CR>", opts = opts },

		["<leader>pf"] = { ":let @+=expand('%')<CR>", opts = opts },
		["<leader>pF"] = { ":let @+=expand('%:p')<CR>", opts = opts },
		["<leader>p."] = { ":PythonCopyReferenceDotted<CR>", opts = opts },
		["<leader>pt"] = { ":PythonCopyReferencePytest<CR>", opts = opts },
		["<leader>pi"] = { ":PythonCopyReferenceImport<CR>", opts = opts },
		["<leader>pp"] = { ":echo @%<CR>", opts = opts },
		["<leader><C-p>"] = { ":let @+=join([expand('%'), line('.')], ':')<CR>", opts = opts },

		["{"] = { ":normal [c<CR>", opts = opts },
		["}"] = { ":normal ]c<CR>", opts = opts },
		["])"] = { ":cnext<CR>", opts = opts },
		["[("] = { ":cprev<CR>", opts = opts },

		["H"] = { ":bp<CR>", opts = opts },
		["L"] = { ":bn<CR>", opts = opts },
		["X"] = { ":bd<CR>", opts = opts },
		["gH"] = { ":lua require('nvchad_ui.tabufline').move_buf(-1)<CR>", opts = opts },
		["gL"] = { ":lua require('nvchad_ui.tabufline').move_buf(1)<CR>", opts = opts },
		["<leader>X"] = { ":bd!<CR>", opts = opts },
		["<leader>!!x"] = { ":%bd!<CR>", opts = opts },
		["<leader>s"] = { ":wa<CR>", opts = opts },
		["<leader>q"] = { ":wqa<CR>", opts = opts },
		["<leader>Q"] = { ":cq<CR>", opts = opts },
		["<C-s>"] = { "<PageUp>", opts = opts },
		["<C-f>"] = { "<PageDown>", opts = opts },
		["<C-q>"] = { ":lua vim.api.nvim_win_close(vim.api.nvim_get_current_win(), true)<CR>", opts = opts },
		["<C-j>"] = {
			function()
				vim.api.nvim_input("<C-w>j")
			end,
		},
		["<C-k>"] = {
			function()
				vim.api.nvim_input("<C-w>k")
			end,
		},
		["<C-l>"] = {
			function()
				vim.api.nvim_input("<C-w>l")
			end,
		},
		["<C-h>"] = {
			function()
				vim.api.nvim_input("<C-w>h")
			end,
		},
		[")"] = {
			":lua require('nvim-treesitter.textobjects.repeatable_move').repeat_last_move_next()<CR>",
			opts = opts,
		},
		["("] = {
			":lua require('nvim-treesitter.textobjects.repeatable_move').repeat_last_move_previous()<CR>",
			opts = opts,
		},
		["f"] = { ":lua require('nvim-treesitter.textobjects.repeatable_move').builtin_f()<CR>", opts = opts },
		["F"] = { ":lua require('nvim-treesitter.textobjects.repeatable_move').builtin_F()<CR>", opts = opts },
		["t"] = { ":lua require('nvim-treesitter.textobjects.repeatable_move').builtin_t()<CR>", opts = opts },
		["T"] = { ":lua require('nvim-treesitter.textobjects.repeatable_move').builtin_T()<CR>", opts = opts },
		["m"] = { "<Plug>CamelCaseMotion_w", opts = opts },
		["M"] = { "<Plug>CamelCaseMotion_b", opts = opts },

		["<leader>k"] = { ":lua vim.diagnostic.goto_prev()<CR>", opts = opts },
		["<leader>j"] = { ":lua vim.diagnostic.goto_next()<CR>", opts = opts },
		["<leader>e"] = { ":lua require('telescope.builtin').diagnostics({severity_limit=3})<CR>", opts = opts },
		["<leader>'"] = { ":lua vim.lsp.buf.format()<CR>", opts = opts },
		["K"] = { ":lua vim.lsp.buf.hover()<CR>", opts = opts },
		["gr"] = { ":Telescope lsp_references<CR>", opts = opts },
		["gi"] = { ":Telescope lsp_incoming_calls<CR>", opts = opts },
		["go"] = { ":Telescope lsp_outgoing_calls<CR>", opts = opts },
		["g<tab>"] = { ":Vista<CR>", opts = opts },
		["<leader>F"] = { ":Vista finder<CR>", opts = opts },

		["<leader>wr"] = { ":Telescope toggletasks spawn<CR>", opts = opts },
		["<leader>ws"] = { ":Telescope toggletasks select<CR>", opts = opts },
		["<leader>we"] = { ":Telescope toggletasks edit<CR>", opts = opts },

		["<leader>tr"] = { ":Dispatch<CR>", opts = opts },
		["<leader>tt"] = { ":lua require('neotest').run.run()<CR>", opts = opts },
		["<leader>tl"] = { ":lua require('neotest').run.run_last()<CR>", opts = opts },
		["<leader>tf"] = { ":lua require('neotest').run.run(vim.fn.expand('%'))<CR>", opts = opts },
		["<leader>tF"] = { ":lua require('neotest').run.run(vim.fn.expand('%'), {strategy = 'dap'})<CR>", opts = opts },

		["<leader>t<tab>"] = { ":lua require('neotest').summary.toggle()<CR>", opts = opts },
		["<leader>te"] = { ":lua require('neotest').output.open()<CR>", opts = opts },
		["<leader>to"] = { ":lua require('neotest').output_panel.toggle()<CR>", opts = opts },

		["<leader>dt"] = {
			":lua require('dap.ui.widgets')<CR>:lua require('neotest').run.run({strategy = 'dap'})<CR>",
			opts = opts,
		},
		["<leader>df"] = { ":lua require('dap.ui.widgets')<CR>:lua require('dap').run_to_cursor()<CR>", opts = opts },
		["<leader>dl"] = {
			":lua require('dap.ui.widgets')<CR>:lua require('dap').run_last({strategy = 'dap'})<CR>",
			opts = opts,
		},
		["<leader>dz"] = {
			":lua require('dap.ui.widgets')<CR>:lua require('dap').run_last({strategy = 'dap'})<CR>",
			opts = opts,
		},

		["<leader>dR"] = { ":lua require('dap').restart({strategy = 'dap'})<CR>", opts = opts },
		["<leader>da"] = { ":Telescope dap configurations<CR>", opts = opts },
		["<leader>dA"] = { ":Telescope dap commands<CR>", opts = opts },

		["<leader>de"] = { ":lua require('neotest').output.open()<CR>", opts = opts },
		["<leader>do"] = { ":lua require('neotest').output_panel.open({last_run = ture})<CR>", opts = opts },
		["<leader>d<tab>"] = { ":lua require('dapui').toggle(2)<CR>", opts = opts },

		["<leader>tb"] = { ":lua require('dap').toggle_breakpoint()<CR>", opts = opts },
		["<leader>db"] = { ":lua require('dap').toggle_breakpoint()<CR>", opts = opts },
		["<leader>dB"] = { ":Telescope dap list_breakpoints<CR>", opts = opts },
		["<leader>d<space>"] = { ":lua require('dap').focus_frame()<CR>", opts = opts },

		["<leader>dd"] = { ":lua require('dap').step_over()<CR>", opts = opts },
		["∆"] = { ":lua require('dap').step_over()<CR>", opts = opts },
		["<leader>ds"] = { ":lua require('dap').step_into()<CR>", opts = opts },
		["˚"] = { ":lua require('dap').step_into()<CR>", opts = opts },
		["<leader>dr"] = { ":lua require('dap').step_out()<CR>", opts = opts },
		["ø"] = { ":lua require('dap').step_out()<CR>", opts = opts },
		["<leader>dk"] = { ":lua require('dap').up()<CR>", opts = opts },
		["<leader>dj"] = { ":lua require('dap').down()<CR>", opts = opts },
		["<leader>dc"] = { ":lua require('dap').continue()<CR>", opts = opts },
		["<leader>dx"] = { ":lua require('dap').terminate()<CR>", opts = opts },

		["<leader>dW"] = {
			function()
				require("dapui").elements.watches.add(vim.fn.expand("<cword>"))
			end,
		},
		["<leader>d$"] = {
			function()
				vim.api.nvim_input('"vy$')
				require("dapui").elements.watches.add(vim.fn.getreg("v"))
				require("dapui").open(2)
			end,
		},
		["<leader>dw"] = {
			function()
				require("dap.ui.widgets").hover()
			end,
		},
		["<leader>dF"] = { ":Telescope dap frames<CR>", opts = opts },
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

		["<leader>r<tab>"] = { ":lua vim.lsp.buf.code_action()<CR>", opts = opts },
		["<leader>rn"] = { ":lua vim.lsp.buf.rename()<CR>", opts = opts },
		["<leader>rar"] = {
			":%y+<CR>:TermExec open=0 cmd='open \"raycast://ai-commands/refactor\" && exit'<CR>",
			opts = opts,
		},
		["<leader>rad"] = {
			":%y+<CR>:TermExec open=0 cmd='open \"raycast://ai-commands/find-differences\" && exit'<CR>",
			opts = opts,
		},
		["<leader>rae"] = {
			":exec ':TermExec cmd='.\"'\".'open \"raycast://ai-commands/extract?arguments='.input(\"Extract what? \").'\" && exit'.\"'\"<CR>",
			opts = opts,
		},
		["<leader>rr"] = { ":'<,'>d<CR>\"+p" },
		["<leader>rq"] = {
			":lua vim.lsp.buf.code_action({ apply = true, filter = filter, context = { diagnostics = {}, only = { 'quickfix' } } })<CR>",
			opts = opts,
		},
		["<leader>ro"] = {
			":w<CR>:lua vim.lsp.buf.code_action({ apply = true, filter = filter, context = { diagnostics = {}, only = { 'source' } } })<CR>",
			opts = opts,
		},
		["<leader>rl"] = { ":LspRestart<CR>", opts = opts },

		["<leader>f<space>"] = { ":Telescope live_grep<CR>", opts = opts },
		["<leader>fg"] = { ":Telescope git_files<CR>", opts = opts },
		["<leader>fq"] = { ":Telescope quickfix<CR>", opts = opts },
		["<leader>b"] = { ":Telescope buffers<CR>", opts = opts },
		["<leader>P"] = { ":Telescope registers<CR>", opts = opts },
		["<C-p>"] = { ":Telescope find_files<CR>", opts = opts },
		["<leader>fw"] = { ":Telescope grep_string<CR>", opts = opts },

		["<leader>cc"] = { ":Copilot panel<CR>", opts = opts },
		["<leader><tab>"] = { ":NvimTreeToggle<CR>", "toggle nvimtree", opts = opts },
		["<leader>u"] = { ":UndotreeToggle<CR>", opts = opts },

		["]t"] = { ":tabnext<CR>", opts = opts },
		["[t"] = { ":tabprevious<CR>", opts = opts },
		["]g"] = { ":Gitsigns next_hunk<CR>", opts = opts },
		["[g"] = { ":Gitsigns prev_hunk<CR>", opts = opts },

		["<leader>ghh"] = { ":Gitsigns toggle_linehl<CR>", opts = opts },
		["<leader>ghw"] = { ":Gitsigns toggle_word_diff<CR>", opts = opts },
		["<leader>ghn"] = { ":Gitsigns toggle_numhl<CR>", opts = opts },
		["<leader>ghd"] = { ":Gitsigns toggle_deleted<CR>", opts = opts },

		["<leader>gb"] = { ":Gitsigns toggle_current_line_blame<CR>", opts = opts },
		["<leader>gB"] = { ":Git blame<CR>", opts = opts },

		["<leader>gm"] = { ":Gitsigns change_base 'origin/main'<CR>", opts = opts },
		["<leader>gM"] = { ":Gitsigns reset_base<CR>", opts = opts },
		["<leader>gd"] = { ":Gitsigns diffthis<CR>", opts = opts },
		["<leader>gD"] = { ":Git difftool<CR>", opts = opts },
		["<leader>gc"] = { ":Git mergetool<CR>", opts = opts },
		["<leader>gC"] = { ":Git rebase --continue<CR>", opts = opts },
		["<leader>gq"] = { ":Gitsigns setqflist all<CR>", opts = opts },

		["<leader>gi"] = { ":Git commit<CR>", "git commit all", opts = opts },
		["<leader>gI"] = { "::Git commit -a<CR>", "git commit onlt staged", opts = opts },
		["<leader>ggi"] = { "::Git commit --amend<CR>", "git commit ammend all", opts = opts },
		["<leader>ggI"] = { "::Git commit -a --amend<CR>", "git commit ammend only sgated", opts = opts },
		["<leader>gp"] = { ":Git push<CR>", "git push", opts = opts },
		["<leader>ggp"] = { ":Git push -f<CR>", "git force push", opts = opts },
		["<leader>gf"] = { ":Git fetch --all<CR>", "git fetch all", opts = opts },

		["<leader>gl"] = { ":Telescope git_commits<CR>", "git commits", opts = opts },
		["<leader>go"] = { ":Twiggy <CR>", "git branches", opts = opts },
		["<leader>gs"] = { ":VGit project_diff_preview<CR>", "git status", opts = opts },
		["<leader>gS"] = { ":VGit project_hunks_preview<CR>", "git status", opts = opts },
		["<leader>gG"] = { ":Ggrep", "git grep", opts = opts },

		["<leader>gt"] = { ":Telescope git_stash<CR>", "git list stashes", opts = opts },
		["<leader>gT"] = { ":Git stash", "git stash", opts = opts },

		["<leader>B"] = { ":DBUIToggle<CR>", "DB UI", opts = opts },

		["<leader>aa"] = { ":A<CR>", "open config", opts = opts },
		["<leader>aC"] = { ":Econfig<CR>", "open config", opts = opts },
		["<leader>aS"] = { ":Eservice<CR>", "open service", opts = opts },
		["<leader>aR"] = { ":Erouter<CR>", "open router", opts = opts },
		["<leader>aM"] = { ":Emapper<CR>", "open mapper", opts = opts },
		["<leader>am"] = { ":Emodel<CR>", "open doman model", opts = opts },
		["<leader>ad"] = { ":Edbmodel<CR>", "open database model", opts = opts },
		["<leader>ar"] = { ":Erepo<CR>", "open database repo", opts = opts },
		["<leader>asr"] = { ":Erepotest<CR>", "open database repo test", opts = opts },
		["<leader>atS"] = { ":Eservicetest<CR>", "open service test", opts = opts },
		["<leader>atM"] = { ":Emappertest<CR>", "open mapper test", opts = opts },
		["<leader>atm"] = { ":Emodeltest<CR>", "open doman model test", opts = opts },
		["<leader>atd"] = { ":Edbmodeltest<CR>", "open database model test", opts = opts },
		["<leader>atr"] = { ":Erepotest<CR>", "open database repo test", opts = opts },

		["s"] = { "<Plug>(SubversiveSubstitute)", opts = opts },
		["ss"] = { "<Plug>(SubversiveSubstituteLine)", opts = opts },
		["S"] = { "<Plug>(SubversiveSubstituteToEndOfLine)", opts = opts },
	},
	v = {
		["\\"] = { '"+y', opts = opts },
		["<leader>r<tab>"] = { ":lua vim.lsp.buf.code_action()<CR>", opts = opts },
		["<leader>rn"] = { ":lua vim.lsp.buf.rename()<CR>", opts = opts },
		["<leader>rq"] = {
			":lua vim.lsp.buf.code_action({ apply = true, context = { diagnostics = {}, only = { 'quickfix' } } })<CR>",
			opts = opts,
		},
		["<leader>ro"] = {
			":lua vim.lsp.buf.code_action({ apply = true, context = { diagnostics = {}, only = { 'source' } } })<CR>",
			opts = opts,
		},
		["<leader>dW"] = {
			function()
				vim.api.nvim_input('"vy')
				local text = vim.fn.getreg("v")
				require("dapui").elements.watches.add(text)
				require("dapui").open(2)
			end,
		},
	},
	o = {
		["iw"] = { "<Plug>CamelCaseMotion_iw", opts = opts },
		["ie"] = { "<Plug>CamelCaseMotion_ie", opts = opts },
	},
	x = {
		["iw"] = { "<Plug>CamelCaseMotion_iw", opts = opts },
		["ie"] = { "<Plug>CamelCaseMotion_ie", opts = opts },
	},
}

local secrets = require("custom.secrets")
return vim.tbl_deep_extend("force", secrets, M)
