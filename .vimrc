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
  set completeopt+=noselect  " Highlight the first completion automatically
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
  set winminheight=0
  set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
  set runtimepath^=~/.vim/bundle/ctrlp.vim
" }}}Environment

" Plugins {{{
  call plug#begin('~/.local/share/nvim/plugged')

  " Editing {{{
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
    Plug 'kristijanhusak/vim-multiple-cursors'
    Plug 'michaeljsmith/vim-indent-object'
    "Plug 'nathanaelkane/vim-indent-guides'
    Plug 'preservim/nerdcommenter'
    Plug 'svermeulen/vim-subversive'
    Plug 'tommcdo/vim-exchange'
    Plug 'tpope/vim-abolish'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-unimpaired'
    Plug 'vim-scripts/YankRing.vim'
  " }}}

  " Programming {{{
    " General {{{
      Plug 'glepnir/lspsaga.nvim'
      Plug 'janko/vim-test'
      Plug 'neovim/nvim-lspconfig'
      Plug 'nvim-lua/completion-nvim'
      Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
      Plug 'nvim-treesitter/playground'
      Plug 'ludovicchabant/vim-gutentags'
    " }}}

    " Python {{{
      Plug 'mgedmin/python-imports.vim'
      Plug 'vim-python/python-syntax'
      Plug 'Vimjas/vim-python-pep8-indent'
    " }}}

    " Other languages {{{
      Plug 'alvan/vim-closetag'
      Plug 'burnettk/vim-angular'
      Plug 'chrisbra/csv.vim'
      Plug 'elzr/vim-json'
      Plug 'hail2u/vim-css3-syntax'
      Plug 'jparise/vim-graphql'        " GraphQL syntax
      Plug 'lambdalisue/nose.vim'
      Plug 'leafgarland/typescript-vim' " TypeScript syntax
      Plug 'martinda/Jenkinsfile-vim-syntax'
      Plug 'maxmellon/vim-jsx-pretty'   " JS and JSX syntax
      Plug 'moll/vim-node'
      Plug 'pangloss/vim-javascript'    " JavaScript support
      Plug 'Rykka/riv.vim'
      Plug 'Rykka/InstantRst'
      Plug 'tasn/vim-tsx'
    " }}}
 
  " }}}

  " Git / Tree / Undo / Tmux / etc {{{
    Plug 'airblade/vim-gitgutter'
    Plug 'benmills/vimux'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'christoomey/vim-tmux-runner'
    Plug 'farmergreg/vim-lastplace'
    Plug 'itchyny/vim-gitbranch'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    Plug 'mbbill/undotree'
    Plug 'mhinz/vim-startify'
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'preservim/nerdtree'
    Plug 'simnalamburt/vim-mundo'
    Plug 'tmux-plugins/vim-tmux'
    Plug 'tpope/vim-fugitive'
  " }}}

  " Org / TODOs {{{
    Plug 'chrisbra/NrrwRgn'
    Plug 'inkarkat/vim-SyntaxRange'
    Plug 'jceb/vim-orgmode'
    Plug 'mattn/calendar-vim'
    Plug 'preservim/tagbar'
    Plug 'tpope/vim-speeddating'
    Plug 'vim-scripts/utl.vim'
    Plug 'vimoutliner/vimoutliner'
    Plug 'yegappan/taglist'
  " }}}

  " Support {{{
    Plug 'AndrewRadev/linediff.vim'
    Plug 'Konfekt/FastFold'
    Plug 'bling/vim-bufferline'
    Plug 'calebsmith/vim-lambdify'
    Plug 'camspiers/lens.vim'
    Plug 'embear/vim-localvimrc'
    Plug 'flazz/vim-colorschemes'
    Plug 'itchyny/lightline.vim'
    Plug 'junegunn/vim-emoji'
    Plug 'junegunn/vim-peekaboo'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-lua/popup.nvim'
    Plug 'luochen1990/rainbow'
    Plug 'romainl/vim-qf'
    Plug 'tmhedberg/SimpylFold'
    Plug 'tpope/vim-dispatch'
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

  " Diff ignore white space {{{
    function! DiffW()
      let opt = ""
      if &diffopt =~ "icase"
        let opt = opt . "-i "
      endif
      if &diffopt =~ "iwhite"
        let opt = opt . "-w " " swapped vim's -b with -w
      endif
      silent execute "!diff -a --binary " . opt .
            \ v:fname_in . " " . v:fname_new .  " > " . v:fname_out
    endfunction
    set diffexpr=DiffW()
  " }}}

  " FZF {{{
    function! s:build_quickfix_list(lines)
        call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
        copen
        cc
    endfunction

    "FZF Buffer Delete

    function! s:list_buffers()
      redir => list
      silent ls
      redir END
      return split(list, "\n")
    endfunction

    function! s:delete_buffers(lines)
      execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
    endfunction

    command! BD call fzf#run(fzf#wrap({
      \ 'source': s:list_buffers(),
      \ 'sink*': { lines -> s:delete_buffers(lines) },
      \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept'
    \ }))
  " }}}
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
  autocmd FileType netrw set nolist
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
  autocmd FileType org set nolist sw=2 ts=2 sts=2 nowrap tw=800 foldlevel=0

  " FZF {{{
      command! -bang -nargs=* Rg call fzf#vim#grep('rg --column --no-heading --line-number --color=always -- '.shellescape(<q-args>), 1, fzf#vim#with_preview('up:70%'), <bang>0)
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
        nnoremap <Leader>u :UndotreeToggle<CR>
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
  let g:yankring_clipboard_monitor = 0
  let maplocalleader="\<space>"
  let mapleader = ","
  let python_highlight_all=1
  let yankring_replace_n_pkey = ''

  let $FZF_DEFAULT_OPTS = "--bind ctrl-a:select-all --preview-window down"
  let $FZF_PREVIEW_COMMAND = 'coderay {}'
  let g:fzf_action = {'ctrl-q': function('s:build_quickfix_list'), 'ctrl-t': 'tab split', 'ctrl-x': 'split', 'ctrl-v': 'vsplit' }
  let g:fzf_buffers_jump = 1
  let g:fzf_history_dir = '~/.local/share/fzf-history'

  let g:completion_auto_change_source = 1
  let g:completion_enable_snippet = 'UltiSnips'
  let g:completion_matching_smart_case = 1

  let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
  let g:completion_trigger_on_delete = 1

  let g:ctrlp_clear_cache_on_exit = 0
  let g:ctrlp_root_markers = ['.idea']
  let g:ctrlp_working_path_mode = 'ra'
  let g:ctrlp_custom_ignore = {
        \ 'dir':  '\v[\/](node_modules|assets|migrations|lib)$',
        \ 'file': '\v\.(jar|orig|html|pyc)$',
        \ }

  let g:gitgutter_map_keys = 0
  let g:gitgutter_override_sign_column_highlight = 0

  let g:lens#disabled_filetypes = ['nerdtree', 'fzf']
  let g:lens#height_resize_min = 800
  let g:lens#height_resize_max = 800
  let g:lens#width_resize_min = 800
  let g:lens#width_resize_max = 800

  let g:localvimrc_ask=0
  let g:localvimrc_sandbox=0

  let g:netrw_altv = 1
  let g:netrw_banner = 0
  let g:netrw_browse_split = 1
  let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+,\(^\|\s\s\)ntuser\.\S\+'
  let g:netrw_liststyle = 3
  let g:netrw_winsize = 75

  let g:notes_directories = ['~/Documents/Notes']
  let g:notes_list_bullets = ['√', '•', '▸', '¿', '▹', '▪', '▫', 'x']
  let g:notes_suffix = '.txt'

  let g:startify_change_to_dir = 0
  let g:startify_change_to_vcs_root = 1
  let g:startify_custom_header = []

  let test#enabled_runners = ["python#nose"]
  let test#strategy = "vtr"

  let g:instant_rst_port = 8905
  let g:instant_rst_browser = 'google_chrome'

  let g:gutentags_ctags_tagfile = '~/.vimtags'
  let g:gutentags_exclude_filetypes = ['javascript', 'gitcommit', 'gitconfig', 'gitrebase', 'gitsendemail', 'git', 'sh', 'text', '']
  let g:gutentags_ctags_executable = '/opt/homebrew/bin/ctags'
  let g:gutentags_project_info = [{"type": "python"}]
  let g:gutentags_file_list_command = 'git ls-files'

  let g:org_export_emacs="/usr/local/bin/emacs"
  let g:org_todo_keywords = ['TODO', 'IN_PROGRESS', 'SCHEDULED', 'WAITING', '|', 'OBSOLETE', 'DELEGATED', 'DONE']
  let g:utl_cfg_hdl_scm_http_system="silent !open '%u'"
" }}}

" Mappings {{{
  cmap w!! w !sudo tee % >/dev/null
  nnoremap _s :%s/\s\+$//<CR>

  noremap \ "+y
  nnoremap <Leader>y :YRShow<CR>
  nnoremap Y y$

  nnoremap <C-P> :GFiles!<CR>
  nnoremap <Leader><C-P> :Telescope git_files<CR>
  nnoremap <Leader>; :Buffers!<CR>
  nnoremap <Leader>.; :Telescope buffers<CR>
  nnoremap <Leader>h :History<CR>
  nnoremap <Leader>.h :Telescope oldfiles<CR>

  nnoremap <Leader>L :Lines<CR>
  nnoremap <Leader>l :BLines<CR>
  imap <C-S> <C-O>:Snippets!<CR>

  nnoremap <leader>f :Rg!<CR>
  nnoremap <silent> <Leader><S-F> :Rg! <C-R><C-W><CR>

  nnoremap <Leader>g :Lspsaga lsp_finder<CR>
  nnoremap <Leader>m :Lspsaga show_line_diagnostics<CR>
  nnoremap <Leader>t :Telescope treesitter<CR>

  "nnoremap <Leader>i :PyrightOrganizeImports<CR>
  nnoremap <leader>i :silent! ImportName<CR>
  nnoremap <leader><S-I> :silent! w<CR>:silent! !isort %<CR>
  nnoremap <leader>p :let @+=expand("%")<CR>
  nnoremap <leader><S-P> :let @+=expand("%:t:r")<CR>
  nnoremap <leader><C-p> :let @+=join([expand("%"), line('.')], ':')<CR>

  nnoremap <silent> <leader>/ :set invhlsearch<CR>
  nnoremap <silent> <leader><leader> <C-^>

  nnoremap <silent> [n :cprev<CR>
  nnoremap <silent> ]n :cnext<CR>
  nnoremap <silent> { :lprev<CR>
  nnoremap <silent> } :lnext<CR>

  nnoremap <Leader>.<tab> :Telescope file_browser<Enter>
  nnoremap <Leader><CR> :NERDTreeToggle<Enter>
  nnoremap <Leader><tab> :NERDTreeToggle<Enter>
  nnoremap <silent> <leader>u :MundoToggle<CR>
  nnoremap <silent> <leader>rn <cmd>lua require('lspsaga.rename').rename()<CR>

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
