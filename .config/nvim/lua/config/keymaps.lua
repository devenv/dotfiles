local opts = { noremap = true, silent = true }

function OpenNeotestOutputAndJumpToBottom()
  require("neotest").output.open({ enter = true, last_run = true })

  -- Use a timer to delay the jump command
  vim.defer_fn(function()
    vim.cmd("normal! G")
  end, 100) -- Adjust the delay as needed (100ms in this example)
end

-- harpoon
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers")
    .new({}, {
      prompt_title = "Harpoon",
      finder = require("telescope.finders").new_table({
        results = file_paths,
      }),
      previewer = conf.file_previewer({}),
      sorter = conf.generic_sorter({}),
    })
    :find()
end

local mappings = {
  n = {
    ["m"] = { "<Nop>", { noremap = true } },
    ["_s"] = { ":%s/\\s\\+$//<CR>" },
    ["\\"] = { '"+' },
    ["u"] = { ":silent undo<CR>", opts = opts },
    ["<C-r>"] = { ":silent redo<CR>", opts = opts },
    ["Y"] = { "y$" },
    ["<leader>h/"] = { ":set invhlsearch<CR>", opts = opts },

    ["g<leader>"] = { "<C-^>", opts = opts },
    ["<leader>,"] = { ":A<CR>", opts = opts },
    ["<leader>f"] = { ":Telescope projectionist<CR>", opts = opts },
    ["''"] = { "`^", opts = opts },

    ["<leader>H"] = { ":Telescope possession list<CR>", opts = opts },
    ["<leader>hh"] = { ":exe ':Telescope possession list default_text='.$TICKET.''<CR>", opts = opts },
    ["<leader>L"] = { ":copen<CR>", opts = opts },
    ["<leader>E"] = { ":clist<CR>", opts = opts },

    ["<leader>a"] = { ":lua require('harpoon'):list():add()<CR>", opts = opts },
    ["<C-e>"] = {
      function()
        toggle_telescope(require("harpoon"):list())
      end,
      opts = opts,
    },
    ["gh"] = { ":lua require('harpoon'):list():next()<CR>", opts = opts },
    ["gl"] = { ":lua require('harpoon'):list():prev()<CR>", opts = opts },

    ["<leader>Sa"] = { ":spellgood <c-r>=expand('<cword>')<CR>", opts = opts },
    ["<leader>Sx"] = { ":spellwrong <c-r>=expand('<cword>')<CR>", opts = opts },
    ["<leader>SS"] = { ":Telescope spell_suggest<CR>", opts = opts },
    ["<leader>SA"] = { ":spellrepall<CR>", opts = opts },
    ["<leader>Su"] = { ":spellundo <c-r>=expand('<cword>')<CR><CR>", opts = opts },

    ["<leader>pp"] = { ":let @+=expand('%:.')<CR>", opts = opts },
    ["<leader>pF"] = { ":let @+=expand('%:p')<CR>", opts = opts },
    ["<leader>p."] = { ":PythonCopyReferenceDotted<CR>", opts = opts },
    ["<leader>pt"] = { ":PythonCopyReferencePytest<CR>", opts = opts },
    ["<leader>pi"] = { ":PythonCopyReferenceImport<CR>", opts = opts },
    ["<leader>pg"] = { ":OpenGithubFile<CR>", opts = opts },
    ["<leader>pG"] = { ":OpenGithubPullReq<CR>", opts = opts },
    ["<leader><C-p>"] = { ":let @+=join([expand('%'), line('.')], ':')<CR>", opts = opts },

    ["<leader>so"] = { ":Telescope oldfiles<CR>", opts = opts },

    ["{"] = { ":normal [c<CR>", opts = opts },
    ["}"] = { ":normal ]c<CR>", opts = opts },
    ["])"] = { ":cnext<CR>", opts = opts },
    ["[("] = { ":cprev<CR>", opts = opts },
    ["]h"] = { ":cnext<CR>", opts = opts },
    ["[g"] = { ":cprev<CR>", opts = opts },

    ["H"] = { ":BufferLineCyclePrev<CR>", opts = opts },
    ["L"] = { ":BufferLineCycleNext<CR>", opts = opts },
    ["X"] = { ":silent! bd<CR>", opts = opts },
    ["gH"] = { ":BufferLineMovePrev<CR>", opts = opts },
    ["gL"] = { ":BufferLineMoveNext<CR>", opts = opts },
    ["gP"] = { ":BufferLineTogglePin<CR>", opts = opts },

    ["gl"] = { ":Gitsigns toggle_current_line_blame<CR>", opts = opts },
    ["gb"] = { ":BlameToggle virtual<CR>", opts = opts },
    ["gB"] = { ":BlameToggle window<CR>", opts = opts },
    ["gt"] = {
      function()
        require("agitator").git_time_machine()
      end,
      opts = opts,
    },
    ["g/"] = {
      function()
        require("agitator").search_git_branch()
      end,
    },
    ["gm"] = { ":Gitsigns change_base 'origin/main'<CR>", opts = opts },
    ["gM"] = { ":Gitsigns reset_base<CR>", opts = opts },
    ["gD"] = { ":Gitsigns diffthis<CR>", opts = opts },
    ["gq"] = { ":Gitsigns setqflist all<CR>", opts = opts },

    ["gs"] = { ":Neogit<CR>", "git status", opts = opts },
    ["gr"] = {
      ":exe ':lua require(\"telescope\").git_branches({prompt=\"!origin '.$TICKET.'\"})'<CR>",
      opts = opts,
    },

    ["s"] = { "<Plug>(SubversiveSubstitute)", opts = opts },
    ["ss"] = { "<Plug>(SubversiveSubstituteLine)", opts = opts },
    ["S"] = { "<Plug>(SubversiveSubstituteToEndOfLine)", opts = opts },
    ["<S-Left>"] = { "<Plug>CamelCaseMotion_b", opts = opts },
    ["<S-Right>"] = { "<Plug>CamelCaseMotion_w", opts = opts },

    ["ghh"] = { ":Gitsigns toggle_linehl<CR>", opts = opts },
    ["ghw"] = { ":Gitsigns toggle_word_diff<CR>", opts = opts },
    ["ghn"] = { ":Gitsigns toggle_numhl<CR>", opts = opts },
    ["ghd"] = { ":Gitsigns toggle_deleted<CR>", opts = opts },

    ["<leader>ww"] = { ":silent! wa<CR>", opts = opts },
    ["<leader>wq"] = { ":silent! wqa<CR>", opts = opts },
    ["<leader>cq"] = { ":silent! cq<CR>", opts = opts },
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
    ["<C-w>+"] = { ":resize +10<CR>", opts = opts },
    ["<C-w>-"] = { ":resize -10<CR>", opts = opts },
    ["<C-w>>"] = { ":vertical resize +20<CR>", opts = opts },
    ["<C-w><"] = { ":vertical resize -20<CR>", opts = opts },

    ["<leader>k"] = {
      ":lua vim.diagnostic.goto_prev({severity = {min = vim.diagnostic.severity.WARN}})<CR>",
      opts = opts,
    },
    ["<leader>j"] = {
      ":lua vim.diagnostic.goto_next({severity = {min = vim.diagnostic.severity.WARN}})<CR>",
      opts = opts,
    },
    ["<leader>'"] = { ":lua require('conform').format()<CR>", opts = opts },

    ["K"] = { ":lua vim.lsp.buf.hover()<CR>", opts = opts },
    ["gd"] = { ":lua vim.lsp.buf.definition()<CR>", opts = opts },

    ["gi"] = { ":Telescope lsp_incoming_calls<CR>", opts = opts },
    ["gI"] = { ":Telescope lsp_outgoing_calls<CR>", opts = opts },
    ["g<tab>"] = { ":Trouble symbols<CR>", opts = opts },

    ["<leader>rr"] = { ":Telescope toggletasks spawn<CR>", opts = opts },
    ["<leader>rs"] = { ":Telescope toggletasks select<CR>", opts = opts },
    ["<leader>re"] = { ":Telescope toggletasks edit<CR>", opts = opts },

    ["<leader>tr"] = { ":silent! wa<CR>:Dispatch<CR>", opts = opts },
    ["<leader>tt"] = { ":silent! wa<CR>:lua require('neotest').run.run()<CR>", opts = opts },
    ["<leader>tw"] = { ":silent! wa<CR>:lua require('neotest').watch.toggle()<CR>", opts = opts },
    ["<leader>tl"] = { ":silent! wa<CR>:lua require('neotest').run.run_last()<CR>", opts = opts },
    ["<leader>tf"] = { ":lua require('neotest').run.run(vim.fn.expand('%'))<CR>", opts = opts },
    ["<leader>tF"] = { ":lua require('neotest').run.run(vim.fn.expand('%'), {strategy = 'dap'})<CR>", opts = opts },
    ["<leader>de"] = { ":lua require('dapui').eval()<CR>:lua require('dapui').eval()<CR>", opts = opts },

    ["<leader>t<tab>"] = { ":lua require('neotest').summary.toggle()<CR>", opts = opts },
    ["<leader>e"] = { ":lua OpenNeotestOutputAndJumpToBottom()<CR>", opts = opts },
    ["<leader>o"] = {
      ":lua require('neotest').output_panel.open({ maximized = true, enter = true, last_run = true })<CR>",
      opts = opts,
    },

    ["<leader>dt"] = {
      ":silent! wa<CR>:lua require('dap.ui.widgets')<CR>:lua require('neotest').run.run({strategy = 'dap'})<CR>",
      opts = opts,
    },
    ["<leader>df"] = { ":lua require('dap.ui.widgets')<CR>:lua require('dap').run_to_cursor()<CR>", opts = opts },
    ["<leader>dl"] = {
      ":silent! wa<CR>:lua require('dap.ui.widgets')<CR>:lua require('dap').run_last({strategy = 'dap'})<CR>",
      opts = opts,
    },
    ["<leader>dz"] = {
      ":lua require('dap.ui.widgets')<CR>:lua require('dap').run_last({strategy = 'dap'})<CR>",
      opts = opts,
    },

    ["<leader>dR"] = { ":lua require('dap').restart({strategy = 'dap'})<CR>", opts = opts },
    ["<leader>da"] = {
      function()
        local dap = require("dap")
        dap.run(dap.configurations.python[1])
      end,
      opts = opts,
    },
    ["<leader>dA"] = { ":Telescope dap_commands<CR>", opts = opts },

    ["<leader>do"] = {
      ":lua require('neotest').output_panel.open({ enter = true, last_run = true })<CR>",
      opts = opts,
    },
    ["<leader>dW"] = { ":lua require('dapui').toggle(2)<CR>", opts = opts },
    ["<leader>d<tab>"] = { ":lua require('dapui').toggle(1)<CR>", opts = opts },

    ["<leader>tb"] = { ":lua require('dap').toggle_breakpoint()<CR>", opts = opts },
    ["<leader>db"] = { ":lua require('dap').toggle_breakpoint()<CR>", opts = opts },
    ["<leader>dB"] = { ":Telescope dap_breakpoints<CR>", opts = opts },
    ["<leader>d<space>"] = { ":lua require('dap').focus_frame()<CR>", opts = opts },

    ["<leader>dp"] = {
      function()
        vim.keymap.set("n", "<Leader>lp", function()
          require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
        end)
      end,
      opts = opts,
    },
    ["<leader>dd"] = { ":lua require('dap').step_over()<CR>", opts = opts },
    ["<C-u>"] = { ":lua require('dap').step_over()<CR>", opts = opts },
    ["<leader>ds"] = { ":lua require('dap').step_into()<CR>", opts = opts },
    ["<C-y>"] = { ":lua require('dap').step_into()<CR>", opts = opts },
    ["<leader>dr"] = { ":lua require('dap').step_out()<CR>", opts = opts },
    ["<C-t>"] = { ":lua require('dap').step_out()<CR>", opts = opts },
    ["<leader>dk"] = { ":lua require('dap').up()<CR>", opts = opts },
    ["<leader>dj"] = { ":lua require('dap').down()<CR>", opts = opts },
    ["<leader>dc"] = { ":lua require('dap').continue()<CR>", opts = opts },
    ["<leader>dx"] = { ":lua require('dap').terminate()<CR>", opts = opts },

    ["<leader>dw"] = {
      function()
        require("dapui").elements.watches.add(vim.fn.expand("<cword>"))
        require("dapui").open(2)
      end,
    },
    ["<leader>d$"] = {
      function()
        vim.api.nvim_input('"vy$')
        require("dapui").elements.watches.add(vim.fn.getreg("v"))
        require("dapui").open(2)
      end,
    },
    ["K"] = {
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
    ["<leader>rq"] = {
      ":lua vim.lsp.buf.code_action({ apply = true, filter = filter, context = { diagnostics = {}, only = { 'quickfix' } } })<CR>",
      opts = opts,
    },
    ["<leader>ro"] = {
      ":silent! w<CR>:lua vim.lsp.buf.code_action({ apply = true, filter = filter, context = { diagnostics = {}, only = { 'source' } } })<CR>",
      opts = opts,
    },
    ["<leader>rl"] = { ":LspRestart<CR>", opts = opts },

    ["<C-p>"] = { ":Telescope find_files<CR>", opts = opts },
    ["<leader>ss"] = { ":silent! wa<CR>:Telescope live_grep<CR>", opts = opts },
    ["<leader>sw"] = { ":silent! wa<CR>:Telescope grep_string<CR>", opts = opts },
    ["<leader>sb"] = { ":Telescope buffers<CR>", opts = opts },
    ["<leader>sC"] = { ":Telescope commands<CR>", opts = opts },
    ["<leader>sc"] = { ":Telescope command_history<CR>", opts = opts },
    ["<leader>sd"] = { ":silent! wa<CR>:Trouble diagnostics<CR>", opts = opts },
    ["<leader>sr"] = { ":silent! wa<CR>:GrugFar<CR>", opts = opts },
    ["<leader>sR"] = { ":Telescope resume<CR>", opts = opts },
    ["<leader>sH"] = { ":Telescope highlights<CR>", opts = opts },
    ["<leader>sh"] = { ":Telescope help_tags<CR>", opts = opts },
    ["<leader>sk"] = { ":Telescope keymaps<CR>", opts = opts },
    ["<leader>sm"] = { ":Telescope marks<CR>", opts = opts },
    ["<leader>sS"] = { ":Telescope symbols<CR>", opts = opts },
    ["<leader>b"] = { ":Telescope buffers<CR>", opts = opts },
    ["<leader>y"] = { ":Telescope registers<CR>", opts = opts },
    ["<leader>n"] = { ":Noice<CR>", opts = opts },
    ["<leader>N"] = { ":Noice dismiss<CR>", opts = opts },

    ["<leader><tab>"] = { ":NvimTreeToggle<CR>", "toggle nvimtree", opts = opts },
    ["<S-tab>"] = { ":NvimTreeToggle<CR>", "toggle nvimtree", opts = opts },
    ["<leader>U"] = { ":UndotreeToggle<CR>", opts = opts },
    ["<leader>D"] = { ":DBUIToggle<CR>", "DB UI", opts = opts },
    ["gS"] = { "<Plug>SortMotion", opts = opts },
  },
  v = {
    ["\\"] = { '"+', opts = opts },
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
    ["<leader>dw"] = {
      function()
        vim.api.nvim_input('"vy')
        vim.api.nvim_input(':lua require("dapui").elements.watches.add(vim.fn.getreg("v"))<CR>')
        require("dapui").open(2)
      end,
    },
    ["gd"] = { ":DiffviewFileHistory<CR>", opts = opts },
    ["gS"] = { "<Plug>SortMotionVisual", opts = opts },
    ["<leader>pg"] = { ":OpenGithubFile<CR>", opts = opts },
  },
  o = {
    ["iw"] = { "<Plug>CamelCaseMotion_iw", opts = opts },
    ["ie"] = { "<Plug>CamelCaseMotion_ie", opts = opts },
    ["gS"] = { "<Plug>SortMotionVisual", opts = opts },
  },
  x = {
    ["iw"] = { "<Plug>CamelCaseMotion_iw", opts = opts },
    ["ie"] = { "<Plug>CamelCaseMotion_ie", opts = opts },
    ["gS"] = { "<Plug>SortMotionVisual", opts = opts },
  },
}

local defaults_to_clear = {
  n = {
    "m",
    "ma",
    "mc",
    "md",
    "ms",
    "n",
    "N",
    "<leader>d",
    "<leader>f",
    "<leader>fb",
    "<leader>fc",
    "<leader>fe",
    "<leader>fE",
    "<leader>ff",
    "<leader>fF",
    "<leader>fg",
    "<leader>fn",
    "<leader>fr",
    "<leader>fR",
    "<leader>ft",
    "<leader>fT",
    "<leader>kK",
    "<leader>p",
    "<leader>w",
    "<leader>ww",
    "<leader>wq",
    "<leader>w-",
    "<leader>w|",
    "<leader>wd",
    "<leader><leader>",
    "<C-p>",
    "<C-s>",
    "<A-j>",
    "<A-k>",
    "<A-h>",
    "<A-l>",
  },
  i = { "<C-f>", "<C-s>" },
}

for mode, keys in pairs(defaults_to_clear) do
  for _, key in pairs(keys) do
    pcall(function()
      vim.keymap.del(mode, key, opts)
    end)
  end
end

for mode, keys in pairs(mappings) do
  for key, mapping in pairs(keys) do
    vim.keymap.set(mode, key, mapping[1], opts)
  end
end
