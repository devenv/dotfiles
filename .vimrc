call plug#begin('~/.local/share/nvim/plugged')

set shell=/bin/bash
filetype plugin indent on

" Modeline {{{
" vim: set sw=2 ts=2 sts=2 et tw=78 foldmarker={{{,}}} foldlevel=0 foldmethod=marker:
" }}}

" Environment {{{
    set nocompatible
    syntax on
    set mousehide
    scriptencoding utf-8
    set encoding=utf8
    set shortmess+=filmnrxoOtT
    set viewoptions=folds,options,cursor,unix,slash
    set virtualedit=
    set history=1000
    set hidden
    set iskeyword-=#
    set iskeyword-=-
    set iskeyword-=.
    set spelllang=en_us
    set nospell
    "set diffopt+=iwhite
    set backspace=indent,eol,start
    set linespace=0
    set nu
    set rnu
    set list
    set sbr= lcs=tab:!-,trail:~ wrap  " List mode and non-text characters
    set showmatch
    set incsearch
    "set inccommand=nosplit
    set hlsearch
    set winminheight=0
    set lazyredraw
    set ignorecase
    set smartcase
    set wildmenu
    set wildmode=list:longest,full
    set whichwrap=b,s,[,]
    set scrolljump=1
    set scrolloff=10
    set foldmethod=syntax
    set foldlevelstart=20
    set ffs=unix
    set encoding=utf-8
    set fileencoding=utf-8
    set list
    set nowrap
    set autoindent
    set shiftwidth=2
    set expandtab
    set tabstop=2
    set softtabstop=2
    set nojoinspaces
    set splitright
    set splitbelow
    set pastetoggle=<F12>
    set spf=~/.vimspell.en.add
    set keywordprg=:help
    set mps+=<:>
    set noswapfile
    set cursorline
    set ttimeout
    set ttimeoutlen=0

    " Restore cursor to position of last editing session
    function! ResCur()
        if line("'\"") <= line("$")
            normal! g`"
            return 1
        endif
    endfunction

    augroup resCur
        autocmd!
        autocmd BufWinEnter * call ResCur()
    augroup END

    " Make sure we are not in pager mode
    let $PAGER=''

    " Setting up the directories {{{
        set backup                  " Backups are nice ...
        if has('persistent_undo')
            set undofile                " So is persistent undo ...
            set undolevels=10000         " Maximum number of changes that can be undone
            set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
        endif

    " }}}
" }}}

" Bundles {{{
    " VCS {{{
        Plug 'tpope/vim-fugitive'
    " }}}

    " General {{{
       "Plug 'sheerun/vim-polyglot'
       Plug 'junegunn/vim-peekaboo'
       Plug 'tpope/vim-repeat'
       Plug 'svermeulen/vim-subversive'
       Plug 'tpope/vim-surround'
       Plug 'kristijanhusak/vim-multiple-cursors'
       Plug 'itchyny/lightline.vim'
       Plug 'bling/vim-bufferline'
       Plug 'flazz/vim-colorschemes'
       Plug 'mbbill/undotree'
       Plug 'nathanaelkane/vim-indent-guides'
       Plug 'git://github.com/tpope/vim-abolish.git'
       Plug 'christoomey/vim-tmux-navigator'
       Plug 'tmux-plugins/vim-tmux'
       Plug 'tmux-plugins/vim-tmux-focus-events'
       Plug 'benmills/vimux'
       Plug 'itchyny/vim-gitbranch'
       "Plug 'kien/ctrlp.vim'
       Plug 'Konfekt/FastFold'
       Plug 'vim-scripts/YankRing.vim'
       Plug 'chrisbra/csv.vim'
       "Plug 'roman/golden-ratio'
       "Plug 'justincampbell/vim-eighties'
       "Plug 'vim-scripts/let-modeline.vim'
       Plug 'embear/vim-localvimrc'
       "Plug 'xolox/vim-notes'
       Plug 'AndrewRadev/linediff.vim'
       Plug 'oblitum/rainbow'
       Plug 'christoomey/vim-tmux-runner'
       Plug 'neomake/neomake'
       Plug 'tpope/vim-dispatch'
       Plug 'yegappan/mru'
       Plug 'kshenoy/vim-signature'
       Plug 'tpope/vim-unimpaired'
       Plug 'romainl/vim-qf'
       Plug 'michaeljsmith/vim-indent-object'
       Plug 'preservim/nerdtree'
       "Plug 'rhysd/committia.vim'
       "Plug 'haya14busa/vim-poweryank'
       Plug 'simnalamburt/vim-mundo'
       Plug 'vim-scripts/loremipsum'
       Plug 'freitass/todo.txt-vim'
       Plug 'mhinz/vim-startify'
       Plug 'junegunn/vim-emoji'
       Plug 'flebel/vim-mypy', { 'for': 'python', 'branch': 'bugfix/fast_parser_is_default_and_only_parser' }
       Plug 'tommcdo/vim-exchange'
       "Plug 'haya14busa/incsearch.vim'
       "Plug 'easymotion/vim-easymotion'
       "Plug 'haya14busa/incsearch-fuzzy.vim'
       "Plug 'haya14busa/incsearch-easymotion.vim'
     " }}}

    " General Programming {{{
        Plug 'calebsmith/vim-lambdify'
        "Plug 'scrooloose/syntastic'
        Plug 'janko/vim-test'
        "Plug 'c0r73x/neotags.nvim'
        "Plug 'ludovicchabant/vim-gutentags'
        Plug 'mattboehm/vim-unstack'
        "Plug 'mgedmin/pytag.vim'
        "Plug 'xolox/vim-easytags'
        Plug 'preservim/nerdcommenter'
        Plug 'martinda/Jenkinsfile-vim-syntax'
        Plug 'tasn/vim-tsx'
    " }}}

    " Snippets & AutoComplete {{{
        Plug 'honza/vim-snippets'
        Plug 'SirVer/ultisnips'
        "Plug 'ncm2/ncm2'
        "Plug 'ncm2/ncm2-bufword'
        "Plug 'ncm2/ncm2-ultisnips'
        "Plug 'ncm2/ncm2-path'
        "Plug 'neoclide/coc.nvim'
        "Plug 'maralla/completor.vim'
        "Plug 'Valloric/YouCompleteMe'
        "Plug 'neoclide/coc.nvim', {'branch': 'release'}
        Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
        Plug 'junegunn/fzf.vim'
        Plug 'neovim/nvim-lspconfig'
        Plug 'glepnir/lspsaga.nvim'
        Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
        Plug 'nvim-treesitter/playground'
        Plug 'nvim-lua/completion-nvim'
        Plug 'nvim-lua/popup.nvim'
        Plug 'nvim-lua/plenary.nvim'
        Plug 'nvim-telescope/telescope.nvim'

        "let g:ycm_autoclose_preview_window_after_completion=1
    " }}}

    " Python {{{
        Plug 'lambdalisue/nose.vim'
        Plug 'roxma/nvim-yarp'
        Plug 'roxma/vim-hug-neovim-rpc'

        "Plug 'deoplete-plugins/deoplete-tag'
        "Plug 'python-mode/python-mode'
        "Plug 'tweekmonster/impsort.vim'
        Plug 'wsdjeg/FlyGrep.vim'
        Plug 'airblade/vim-gitgutter'
        Plug 'tmhedberg/SimpylFold'
        Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh \| UpdateRemotePlugins' }
        Plug 'vim-python/python-syntax'
        Plug 'Vimjas/vim-python-pep8-indent'
        "Plug 'fisadev/vim-isort'
        "Plug 'mgedmin/python-imports.vim'

        "autocmd BufEnter * call ncm2#enable_for_buffer()
        "au TextChangedI * call ncm2#auto_trigger()
        "let ncm2#popup_delay = 5
        "let ncm2#complete_length = [[1, 1]]
        "let g:ncm2#matcher = 'substrfuzzy'
        let g:PythonAutoAddImports = 1

        set completeopt-=menu
        set completeopt+=menuone   " Show the completions UI even with only 1 item
        set completeopt-=longest   " Don't insert the longest common text
        set completeopt-=preview   " Hide the documentation preview window
        set completeopt+=noinsert  " Don't insert text automatically
        set completeopt-=noselect  " Highlight the first completion automatically
        set shortmess+=c
    " }}}


    " Web {{{
        Plug 'elzr/vim-json'
        "Plug 'jelera/vim-javascript-syntax'
        Plug 'moll/vim-node'
        Plug 'burnettk/vim-angular'
        Plug 'alvan/vim-closetag'
        Plug 'hail2u/vim-css3-syntax'
        Plug 'pangloss/vim-javascript'    " JavaScript support
        Plug 'leafgarland/typescript-vim' " TypeScript syntax
        Plug 'maxmellon/vim-jsx-pretty'   " JS and JSX syntax
        Plug 'jparise/vim-graphql'        " GraphQL syntax

    " }}}

    " Misc {{{
        Plug 'xolox/vim-misc'
    " }}}
" }}}

call plug#end()

" Autocmds {{{
    "autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,lua autocmd BufWritePre <buffer> call StripTrailingWhitespace()
    "autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    "autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    "autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    "autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    "autocmd FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0]) " Instead of reverting the cursor to the last position in the buffer, we set it to the first line when editing a git commit message
" }}}

" Keymappings {{{
    " General {{{
        nnoremap <Space> <Nop>
        let mapleader = ","
        let localleader = '|'
    " }}}

    " Personal tweaks
        let g:C_Ctrl_j   = 'off'
        nnoremap <C-J> <C-W>j
        nnoremap <C-K> <C-W>k
        nnoremap <C-L> <C-W>l
        nnoremap <C-H> <C-W>h

        noremap j gj
        noremap k gk

        nnoremap Y y$

        nmap <silent> <leader>/ :set invhlsearch<CR>

        vnoremap < <gv
        vnoremap > >gv
        vnoremap . :normal .<CR>

        cmap w!! w !sudo tee % >/dev/null
    " }}}
" }}}

" Bundles config {{{
    set tags=~/.vimtags
    set regexpengine=1

    au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
    set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
    nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
    let g:vim_json_syntax_conceal = 0

    set runtimepath^=~/.vim/bundle/ctrlp.vim
    let g:ctrlp_working_path_mode = 'ra'
    let g:ctrlp_custom_ignore = {
          \ 'dir':  '\v[\/](node_modules|assets|migrations|lib)$',
          \ 'file': '\v\.(jar|orig|html|pyc)$',
          \ }
    let g:ctrlp_root_markers = ['.idea']
    let g:ctrlp_clear_cache_on_exit = 0

    if isdirectory(expand("~/.vim/bundle/undotree/"))
        nnoremap <Leader>u :UndotreeToggle<CR>
        " If undotree is opened, it is likely one wants to interact with it.
        let g:undotree_SetFocusWhenToggle=1
    endif
" }}}


" Functions {{{
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

    function! s:build_quickfix_list(lines)
        call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
        copen
        cc
    endfunction

" }}}

" Custom {{{


  set statusline+=%#warningmsg#
  set statusline+=%*

  let g:acp_enableAtStartup = 0
  let python_highlight_all=1
  let b:csv_arrange_leftalign = 1
  let g:localvimrc_sandbox=0
  let g:localvimrc_ask=0
  let test#strategy = "vtr"
  let g:rainbow_active = 1
  let g:golden_ratio_wrap_ignored = 1
  let g:golden_ratio_exclude_nonmodifiable = 1
  let g:golden_ratio_filetypes_blacklist = ["nerdtree", "unite"]
  let g:go_fmt_autosave=0
  let yankring_replace_n_pkey = ''
  let g:yankring_clipboard_monitor = 0
  let g:notes_directories = ['~/Documents/Notes']
  let g:notes_suffix = '.txt'
  let g:notes_list_bullets = ['√', '•', '▸', '¿', '▹', '▪', '▫', 'x']
  let test#enabled_runners = ["python#nose"]
  let g:UltiSnipsJumpForwardTrigger = "<tab>"
  let g:gitgutter_override_sign_column_highlight = 0
  let g:gitgutter_map_keys = 0

  let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+,\(^\|\s\s\)ntuser\.\S\+'
  let g:netrw_banner = 0
  let g:netrw_browse_split = 1
  let g:netrw_altv = 1
  let g:netrw_winsize = 75
  let g:netrw_liststyle = 3
  autocmd FileType netrw set nolist
  let g:NERDTreeWinSize = 25

  let g:startify_change_to_dir = 0
  let g:startify_change_to_vcs_root = 1
  let g:startify_custom_header = []

  map <Leader>y <Plug>(operator-poweryank-osc52)

  nmap <silent> <leader>. :w<CR>:sleep 200m<CR>:TestNearest<CR>
  nmap <silent> <leader>tt :w<CR>:sleep 200m<CR>:TestFile<CR>
  nmap <silent> <leader>ta :w<CR>:sleep 200m<CR>:TestSuite<CR>
  nmap <silent> <leader><space> :w<CR>:sleep 200m<CR>:TestLast<CR>

  nmap <silent> ]n :cnext<CR>
  nmap <silent> [n :cprev<CR>

  nnoremap <Leader><tab> :NERDTreeToggle<Enter>
  nnoremap <Leader><CR> :NERDTreeToggle<Enter>

  "nmap <leader>i :ImportName<CR>:Isort<CR>
  nmap } :lnext<CR>
  nmap { :lprev<CR>

  nmap s <plug>(SubversiveSubstitute)
  nmap ss <plug>(SubversiveSubstituteLine)
  nmap S <plug>(SubversiveSubstituteToEndOfLine)

  nmap <silent> <leader>tv :w<CR>:TestVisit<CR>
  nmap <silent> <leader><leader> <C-^>
  nmap <silent> <leader>ld :Linediff<CR>
  nmap <silent> <leader>u :MundoToggle<CR>
  vmap zc :fold<CR>

  nmap <leader>p :let @+=expand("%:~")<CR>

  "noremap   <Up>     :echo "NO!"<CR>
  "noremap   <Down>   :echo "NO!"<CR>
  "noremap   <Left>   :echo "NO!"<CR>
  "noremap   <Right>  :echo "NO!"<CR>
  noremap   <F1>  :echo "Pressing F1 much?"<CR>

  nmap _s :%s/\s\+$//<CR>

  "autocmd CursorHold * silent call CocActionAsync('highlight')

  " Applying codeAction to the selected region.
  " Example: `<leader>aap` for current paragraph
  "xmap <leader>a  <Plug>(coc-codeaction-selected)
  "nmap <leader>a  <Plug>(coc-codeaction-selected)

  " Remap for do codeAction of selected region
  "function! s:cocActionsOpenFromSelected(type) abort
      "execute 'CocCommand actions.open ' . a:type
  "endfunction
  "xmap <silent> <leader>a :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
  "nmap <silent> <leader>a :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@


  " Show all diagnostics.
  "nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
  " Show commands.
  "nnoremap <silent> <space>c  :<C-u>CocList commands<cr>

  if has("patch-8.1.1564")
      " Recently vim can merge signcolumn and number column into one
      set signcolumn=number
  else
      set signcolumn=yes
  endif

  "inoremap <silent><expr> <c-space> coc#refresh()
  if exists('*complete_info')
      inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
  else
      inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
  endif

  "nmap <space>e :CocCommand explorer<CR>

  "nmap <silent> [l <Plug>(coc-diagnostic-prev)
  "nmap <silent> ]l <Plug>(coc-diagnostic-next)

  map \ "+y

  "function! CocCurrentFunction()
    "return get(b:, 'coc_current_function', '')
  "endfunction

  "function! StatusDiagnostic() abort
    "let info = get(b:, 'coc_diagnostic_info', {})
    "if empty(info) | return '' | endif
    "let msgs = []
    "if get(info, 'warning', 0)
      "call add(msgs, info['warning'] . emoji#for('space_invader'))
    "endif
    "if get(info, 'error', 0)
      "call add(msgs, info['error'] . emoji#for('anger'))
    "endif
    "return join(msgs, ' '). ' ' . get(g:, 'coc_status', '')
  "endfunction

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

  let g:jellybeans_use_term_italics = 1
  colorscheme jellybeans
  highlight Normal ctermbg=233

  "highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg
  "highlight DiffDelete cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg
  "highlight DiffChange cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg
  "highlight DiffText   cterm=bold ctermfg=10 ctermbg=88 gui=none guifg=bg
  highlight CursorLine term=bold cterm=bold
  highlight CursorLineNr term=bold cterm=bold

  "highligh Search term=bold cterm=bold ctermbg=21 guibg=Grey40

  autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
  highlight ExtraWhitespace ctermbg=red guibg=red
  highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
  highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
  match ExtraWhitespace /\s\+$\|\s\+$\| \+\ze\t\|\s\+\%#\@<!$\|[^ ]*\s+,/

  highlight NormalFloat ctermbg=Black guibg=Grey40

  "map /  <Plug>(incsearch-forward)
  "map ?  <Plug>(incsearch-backward)
  "map z/ <Plug>(incsearch-fuzzy-/)
  "map z? <Plug>(incsearch-fuzzy-?)
  "map <space>/ <Plug>(incsearch-easymotion-/)
  "map <space>? <Plug>(incsearch-easymotion-?)
  "nmap <space> <Plug>(easymotion-prefix)
  "
if has('macunix')
  function! OpenURLUnderCursor()
    let s:uri = expand('<cWORD>')
    let s:uri = substitute(s:uri, '?', '\\?', '')
    let s:uri = shellescape(s:uri, 1)
    if s:uri != ''
      silent exec "!open '".s:uri."'"
      :redraw!
    endif
  endfunction
  nnoremap gx :call OpenURLUnderCursor()<CR>
endif


nnoremap <silent> <leader>rn <cmd>lua require('lspsaga.rename').rename()<CR>

let g:completion_enable_snippet = 'UltiSnips'
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy', 'all']
let g:completion_matching_smart_case = 1
let g:completion_trigger_on_delete = 1

let g:fzf_history_dir = '~/.local/share/fzf-history'
let g:fzf_buffers_jump = 1
let g:fzf_action = {'ctrl-q': function('s:build_quickfix_list'), 'ctrl-t': 'tab split', 'ctrl-x': 'split', 'ctrl-v': 'vsplit' }
let $FZF_DEFAULT_OPTS = "--bind ctrl-a:select-all --preview-window down"
let $FZF_PREVIEW_COMMAND = 'coderay {}'
command! -bang -nargs=* Rg call fzf#vim#grep('rg --column --no-heading --line-number --color=always -- '.shellescape(<q-args>), 1, fzf#vim#with_preview('up:70%'), <bang>0)
command! -bang -nargs=* GFiles call fzf#vim#gitfiles('', fzf#vim#with_preview('up:70%'), <bang>0)
command! -bang -nargs=* Marks call fzf#vim#marks({'options': ['--preview', 'coderay {4..-1}']}, <bang>0)

command! -bang -nargs=* GGrep
      \ call fzf#vim#grep(
      \   'git grep --line-number '.shellescape(<q-args>), 0,
      \   <bang>0 ? fzf#vim#with_preview({'options': '--no-hscroll'},'up:60%')
      \           : fzf#vim#with_preview({'options': '--no-hscroll'},'down:50%'),
      \   <bang>0)

nmap <C-P> :GFiles!<CR>
imap <C-S> <C-O>:Snippets!<CR>
nmap <Leader>; :Buffers!<CR>
nmap <Leader>b :Buffers!<CR>
nmap <Leader>h :History<CR>
nmap <Leader>m :Marks!<CR>
nmap <leader>f :Rg!<CR>
nmap <Leader>l :BLines<CR>
nmap <Leader>L :Lines<CR>
nmap <Leader>t :Telescope treesitter<CR>
nmap <Leader>g :Lspsaga lsp_finder<CR>
nmap <Leader>y  :YRShow<cr>
nnoremap <Leader><tab> :NERDTreeToggle<Enter>
nnoremap <Leader><CR> :NERDTreeToggle<Enter>
nmap <silent> <Leader><S-F> :Rg! <C-R><C-W><CR>
set foldexpr=nvim_treesitter#foldexpr()
