" Modeline {{{
" vim: sw=2 ts=2 sts=2 tw=78 foldmarker={{{,}}} foldlevel=0 foldmethod=marker
" }}}

" Header {{{
  set shell=/bin/bash
  filetype plugin indent on
" }}}

" Settings {{{
  syntax on
  scriptencoding utf-8

  set autoindent
  set backspace=indent,eol,start
  set backup                  " Backups are nice ...
  set completeopt+=menu
  set completeopt+=menuone   " Show the completions UI even with only 1 item
  set completeopt+=noinsert  " Insert text automatically
  set completeopt-=preview   " Documentation preview window
  set completeopt-=longest   " Insert the longest common text
  set completeopt-=noselect  " Highlight the first completion automatically
  set cursorline
  set encoding=utf-8
  set encoding=utf8
  set expandtab
  set ffs=unix
  set fileencoding=utf-8
  set foldexpr=nvim_treesitter#foldexpr()
  set foldlevelstart=20
  set foldmethod=syntax
  set hidden
  set history=1000
  set hlsearch
  set ignorecase
  set incsearch
  set iskeyword-=#
  set iskeyword-=-
  set iskeyword-=.
  set keywordprg=:help
  set lazyredraw
  set linespace=0
  set list
  set list
  set mousehide
  set mouse=
  set mps+=<:>
  set nocompatible
  set nojoinspaces
  set nospell
  set noswapfile
  set nowrap
  set nu
  set pastetoggle=<F12>
  set regexpengine=1
  set rnu
  set sbr= lcs=tab:!-,trail:~  " List mode and non-text characters
  set scrolljump=1
  set scrolloff=10
  set signcolumn=yes
  set shiftwidth=2
  set shortmess+=c
  set shortmess+=filmnrxoOtT
  set showmatch
  set smartcase
  set softtabstop=2
  set spelllang=en_us
  set spf=~/.vimspell.en.add
  set splitbelow
  set splitright
  set tabstop=2
  set tags=~/.vimtags
  set ttimeout
  set ttimeoutlen=0
  set viewoptions=folds,options,cursor,unix,slash
  set virtualedit=
  set whichwrap=b,s,[,]
  set wildmenu
  set wildmode=list:longest,full
  set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
  set runtimepath^=~/.vim/bundle/ctrlp.vim
" }}}Environment

" Plugins {{{
  call plug#begin('~/.local/share/nvim/plugged')

  " Editing {{{
    Plug 'SirVer/ultisnips'
    Plug 'camspiers/lens.vim'
    Plug 'cohama/lexima.vim'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'quangnguyen30192/cmp-nvim-ultisnips'
    Plug 'svermeulen/vim-easyclip'
    Plug 'svermeulen/vim-subversive'
    Plug 'tpope/vim-abolish'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-unimpaired'
  " }}}

  " Programming {{{
    Plug 'christoomey/vim-sort-motion'
    Plug 'folke/trouble.nvim'
    Plug 'glepnir/lspsaga.nvim'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'itchyny/vim-gitbranch'
    Plug 'janko/vim-test'
    Plug 'leafgarland/typescript-vim'
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'michaeljsmith/vim-indent-object'
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'
    Plug 'wellle/targets.vim'
  " }}}

  " Git / FZF / Undo /  etc {{{
    Plug 'ThePrimeagen/harpoon'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'embear/vim-localvimrc'
    Plug 'farmergreg/vim-lastplace'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    Plug 'lewis6991/gitsigns.nvim'
    Plug 'mbbill/undotree'
    Plug 'mhinz/vim-startify'
    Plug 'nvim-neo-tree/neo-tree.nvim', { 'branch': 'v2.x' }
    Plug 'nvim-telescope/telescope-symbols.nvim'
    Plug 'nvim-telescope/telescope-ui-select.nvim'
    Plug 'nvim-telescope/telescope.nvim'
  " }}}

  " Support {{{
    Plug 'MunifTanjim/nui.nvim'
    Plug 'bling/vim-bufferline'
    Plug 'calebsmith/vim-lambdify'
    Plug 'flazz/vim-colorschemes'
    Plug 'itchyny/lightline.vim'
    Plug 'junegunn/vim-emoji'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-tree/nvim-web-devicons'
  " }}}

  call plug#end()
" }}}

" Functions {{{
  " Undo {{{
    function! InitializeDirectories()
        let parent = $HOME
        let prefix = 'vim'
        let dir_list = {
                    \ 'backup': 'backupdir',
                    \ 'swap': 'directory' }

        if has('persistent_undo')
            let dir_list['undo'] = 'undodir'
        endif

        " To specify a different directory in which to place the vimbackup,
        " vimviews, vimundo, and vimswap files/directories, add the following to
        " your .vimrc.before.local file:
        let common_dir = parent . '/.' . prefix

        for [dirname, settingname] in items(dir_list)
            let directory = common_dir . dirname . '/'
            if exists("*mkdir")
                if !isdirectory(directory)
                    call mkdir(directory)
                endif
            endif
            if !isdirectory(directory)
                echo "Warning: Unable to create backup directory: " . directory
                echo "Try: mkdir -p " . directory
            else
                let directory = substitute(directory, " ", "\\\\ ", "g")
                exec "set " . settingname . "=" . directory
            endif
        endfor
    endfunction
    call InitializeDirectories()
  " }}}

  " No space J {{{
    fun! s:join_spaceless()
      execute 'normal! gJ'
      if matchstr(getline('.'), '\%' . col('.') . 'c.') =~ '\s'
        execute 'normal! dw'
      endif
    endfun
  " }}}
 " }}}

" FZF {{{
  function! s:build_quickfix_list(lines)
      call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
      copen
      cc
  endfunction

" }}}

" Style {{{
  set statusline+=%#warningmsg#
  set statusline+=%*

  let g:jellybeans_use_term_italics = 1
  colorscheme jellybeans

  autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red

  highlight Normal ctermbg=233
  highlight CursorLine term=bold cterm=bold
  highlight CursorLineNr term=bold cterm=bold
  highlight ExtraWhitespace ctermbg=red guibg=red
  highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
  highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
  highlight NormalFloat ctermbg=Black guibg=Grey40

  match ExtraWhitespace /\s\+$\|\s\+$\| \+\ze\t\|\s\+\%#\@<!$\|[^ ]*\s+,/

  let g:lightline = {
        \ 'colorscheme': 'jellybeans',
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'currentfunction', 'readonly', 'filename', 'modified' ] ],
        \   'right': [ [ 'lineinfo' ],
        \              [ 'percent' ],
        \              [ 'branchname', 'charvaluehex', 'filetype', 'cocstatus' ] ]
        \ },
        \ 'component_function': {
        \   'cocstatus': 'StatusDiagnostic',
        \   'branchname': 'gitbranch#name',
        \   'currentfunction': 'CocCurrentFunction'
        \ },
        \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
        \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },
        \ 'enable': { 'tabline': 0 },
        \ }
" }}}

" Init {{{
  "autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
  autocmd FileType org set nolist sw=2 ts=2 sts=2 nowrap tw=800 foldlevel=0
  let project_root = system('git rev-parse --show-toplevel 2> /dev/null')[:-2]

  " FZF {{{
      command! -bang -nargs=* Rg call fzf#vim#grep('rg --column --no-heading --line-number --color=always -- '.shellescape(<q-args>), 1, fzf#vim#with_preview({'dir': g:project_root}, 'up:70%'), <bang>0)
      command! -bang -nargs=* GFiles call fzf#vim#gitfiles('', fzf#vim#with_preview('up:70%'), <bang>0)
      command! -bang -nargs=* Marks call fzf#vim#marks({'options': ['--preview', 'coderay {4..-1}']}, <bang>0)

      command! -bang -nargs=* GGrep
            \ call fzf#vim#grep(
            \   'git grep --line-number '.shellescape(<q-args>), 0,
            \   <bang>0 ? fzf#vim#with_preview({'options': '--no-hscroll'},'up:60%')
            \           : fzf#vim#with_preview({'options': '--no-hscroll'},'down:50%'),
            \   <bang>0)
  " }}}

  " Undo {{{
    if isdirectory(expand("~/.vim/bundle/undotree/"))
        nnoremap <leader>u :UndotreeToggle<CR>
        " If undotree is opened, it is likely one wants to interact with it.
        let g:undotree_SetFocusWhenToggle=1
    endif

    if has('persistent_undo')
        set undofile                " So is persistent undo ...
        set undolevels=10000         " Maximum number of changes that can be undone
        set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
    endif
" }}}
" }}}

" Lets {{{
  let $PAGER=''
  let b:csv_arrange_leftalign = 1
  let g:C_Ctrl_j   = 'off'
  let g:UltiSnipsExpandTrigger = "<Tab>"
  let g:UltiSnipsJumpForwardTrigger = "<Tab>"
  let g:UltiSnipsJumpBackwardTrigger = "<S-Tab>"

  let g:go_fmt_autosave=0
  let g:rainbow_active = 1
  let g:vim_json_syntax_conceal = 0
  let maplocalleader="\<space>"
  let mapleader = ","

  let $FZF_DEFAULT_OPTS = "--bind ctrl-a:select-all --preview-window down"
  let $FZF_PREVIEW_COMMAND = 'coderay {}'
  let g:fzf_action = {'ctrl-q': function('s:build_quickfix_list'), 'ctrl-t': 'tab split', 'ctrl-x': 'split', 'ctrl-v': 'vsplit' }
  let g:fzf_buffers_jump = 1
  let g:fzf_history_dir = '~/.local/share/fzf-history'

  let g:ctrlp_clear_cache_on_exit = 0
  let g:ctrlp_root_markers = ['.idea']
  let g:ctrlp_working_path_mode = 'ra'
  let g:ctrlp_custom_ignore = {
        \ 'dir':  '\v[\/](node_modules|assets|migrations|lib)$',
        \ 'file': '\v\.(jar|orig|html|pyc)$',
        \ }

  let g:gitgutter_map_keys = 0
  let g:gitgutter_override_sign_column_highlight = 0

  let g:lens#disabled_filetypes = ['fzf']
  let g:lens#height_resize_min = 5
  let g:lens#height_resize_max = 30
  let g:lens#width_resize_min = 20
  let g:lens#width_resize_max = 200

  let g:localvimrc_ask=0
  let g:localvimrc_sandbox=0

  let g:notes_directories = ['~/Documents/Notes']
  let g:notes_list_bullets = ['√', '•', '▸', '¿', '▹', '▪', '▫', 'x']
  let g:notes_suffix = '.txt'

  let g:startify_bookmarks = 0
  let g:startify_change_to_dir = 0
  let g:startify_change_to_vcs_root = 1
  let g:startify_custom_header = []
  let g:startify_enable_special = 0
  let g:startify_enable_unsafe = 1
  let g:startify_session_autoload = 1
  let g:startify_session_persistence = 1
  let g:startify_lists = [
        \ { 'type': 'sessions',  'header': ['   Sessions']       },
        \ { 'type': 'files',     'header': ['   MRU']            },
        \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
        \ { 'type': 'commands',  'header': ['   Commands']       },
        \ ]

  let test#enabled_runners = ["python#nose"]
  let test#strategy = "vtr"

  let g:lexima_enable_basic_rules = 0

  let g:instant_rst_port = 8905
  let g:instant_rst_browser = 'google_chrome'

  let g:gutentags_ctags_tagfile = $HOME."/.vimtags"
  let g:gutentags_exclude_filetypes = ['javascript', 'gitcommit', 'gitconfig', 'gitrebase', 'gitsendemail', 'git', 'sh', 'text', '']
  "let g:gutentags_project_info = [{"type": "python"}]
  let g:gutentags_file_list_command = 'git ls-files'

  let g:org_export_emacs="/usr/local/bin/emacs"
  let g:org_todo_keywords = ['TODO', 'IN_PROGRESS', 'SCHEDULED', 'WAITING', '|', 'OBSOLETE', 'DELEGATED', 'DONE']
  let g:utl_cfg_hdl_scm_http_system="silent !open '%u'"

  let g:EasyClipEnableBlackHoleRedirect = 0
  let g:EasyClipShareYanks = 1
  let g:EasyClipUseCutDefaults = 0
  let g:EasyClipUsePasteToggleDefaults = 0
  let g:EasyClipUseSubstituteDefaults = 0
" }}}

" Mappings {{{
  cmap w!! w !sudo tee % >/dev/null
  nnoremap _s :%s/\s\+$//<CR>

  noremap \ "+y
  nnoremap Y y$
  nnoremap <leader>y :Telescope registers<cr>

  nnoremap <C-P> :Telescope git_files<CR>
  nnoremap <leader>; :Neotree buffers<CR>
  nnoremap <leader>b :Telescope buffers<CR>
  nnoremap <leader>h :Telescope oldfiles<CR>
  nnoremap <leader><tab> :Neotree reveal_file=%:p<CR>
  nnoremap <leader>gs :Neotree git_status<CR>
  nnoremap <leader>a :lua require("harpoon.mark").add_file()<CR>
  nnoremap <leader>A :lua require("harpoon.mark").rm_file()<CR>
  nnoremap <leader>l :Telescope harpoon marks<CR>

  nnoremap <leader>f :Telescope live_grep<CR>
  nnoremap <leader>F :Telescope grep_string<CR>

  nnoremap <leader>H :Startify<CR>

  nnoremap <leader>i :silent! ImportName<CR>
  nnoremap <leader>I :silent! w<CR>:silent! !isort %<CR>
  nnoremap <leader>p :let @+=expand("%")<CR>
  nnoremap <leader>P :let @+=expand("%:t:r")<CR>
  nnoremap <leader><C-p> :let @+=join([expand("%"), line('.')], ':')<CR>

  nnoremap <silent> <leader>/ :set invhlsearch<CR>
  nnoremap <silent> <leader><leader> <C-^>
  nnoremap <silent> <leader>. :bn<CR>
  nnoremap <silent> <leader>m :bp<CR>
  nnoremap <silent> <leader>> :bl<CR>
  nnoremap <silent> <leader>M :bf<CR>
  nnoremap <silent> <leader>x :bd<CR>

  nnoremap <silent> [n :cprev<CR>
  nnoremap <silent> ]n :cnext<CR>
  nnoremap <silent> [g :GitGutterPrevHunk<CR>
  nnoremap <silent> ]g :GitGutterNextHunk<CR>
  nnoremap <silent> <leader>gu :GitGutterUndoHunk<CR>
  nnoremap <silent> <leader>gl :GitGutterLineHighlightsToggle<CR>
  nnoremap <silent> <leader>gn :GitGutterLineNrHighlightsToggle<CR>
  nnoremap <silent> <leader>gd :GitGutterDiffOrig<CR>
  nnoremap <silent> { :lprev<CR>
  nnoremap <silent> } :lnext<CR>

  nnoremap <silent> <leader>u :MundoToggle<CR>
  nnoremap <silent> <leader>rn :Lspsaga rename<CR>
  nnoremap <silent> <leader>L :Lspsaga diagnostic_jump_next<CR>
  nnoremap <silent> L :Lspsaga diagnostic_jump_prev<CR>
  nnoremap <silent> <leader>d = <cmd>Lspsaga goto_definition<CR>
  nnoremap <silent> <leader>D = <cmd>Lspsaga peek_definition<CR>
  nnoremap <silent> <leader>o :Lspsaga outline<CR>
  nnoremap <silent> <leader>t :Lspsaga term_toggle<CR>
  nnoremap <silent> <leader>' <cmd>lua vim.lsp.buf.format()<CR>
  nnoremap <silent> <leader>j <cmd>lua require("trouble").next({skip_groups = true, jump = true})<CR>
  nnoremap <silent> <leader>k <cmd>lua require("trouble").previous({skip_groups = true, jump = true})<CR>
  nnoremap K :Lspsaga hover_doc<CR>
  nnoremap <leader>e :TroubleToggle<CR>
  nnoremap <leader>rr <cmd>lua vim.lsp.buf.code_action()<CR>
  vnoremap <leader>rr <cmd>lua vim.lsp.buf.range_code_action()<CR>

  nnoremap <leader>J :call <SID>join_spaceless()<CR>

  nnoremap <Space> <Nop>
  nnoremap <C-H> <C-W>h
  nnoremap <C-J> <C-W>j
  nnoremap <C-K> <C-W>k
  nnoremap <C-L> <C-W>l

  nnoremap j gj
  nnoremap k gk

  nmap S <plug>(SubversiveSubstituteToEndOfLine)
  nmap s <plug>(SubversiveSubstitute)
  nmap ss <plug>(SubversiveSubstituteLine)

  vnoremap zc :fold<CR>
  vnoremap . :normal .<CR>
  vnoremap < <gv
  vnoremap > >gv

" }}}
