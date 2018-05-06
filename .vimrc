set rtp+=~/.vim/bundle/Vundle.vim
let g:vundle_default_git_proto = 'git'
set shell=/bin/bash

" Modeline {{{
" vim: set sw=2 ts=2 sts=2 et tw=78 foldmarker={{{,}}} foldlevel=0 foldmethod=marker:
" }}}

" Environment {{{
    set nocompatible            " Must be first line
    syntax on                   " Syntax highlighting
    "set mouse=a                 " Automatically enable mouse usage
    set mousehide               " Hide the mouse cursor while typing
    scriptencoding utf-8
    set encoding=utf8

    "if has('clipboard')
        "if has('unnamedplus')   " When possible use + register for copy-paste
            "set clipboard=unnamed,unnamedplus
        "else                    " On mac and Windows, use * register for copy-paste
            "set clipboard=unnamed
        "endif
    "endif
    "set autowrite                       " Automatically write a file when leaving a modified buffer
    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=""             " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    set hidden                          " Allow buffer switching without saving
    "set iskeyword-=.                    " '.' is an end of word designator
    set iskeyword-=#                    " '#' is an end of word designator
    set iskeyword-=-                    " '-' is an end of word designator
    "set iskeyword-=_
    set nospell
    set diffopt+=iwhite

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

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

    " Setup bundle support {{{
        " The next three lines ensure that the ~/.vim/bundle/ system works
        filetype off
        set rtp+=~/.vim/bundle/Vundle.vim
        call vundle#rc()
    " }}}

    " Add an UnBundle command {{{
        function! UnBundle(arg, ...)
            let bundle = vundle#config#init_bundle(a:arg, a:000)
            call filter(g:bundles, 'v:val["name_spec"] != "' . a:arg . '"')
        endfunction

        com! -nargs=+         UnBundle
        \ call UnBundle(<args>)
    " }}}

    " Deps {{{
        Bundle 'MarcWeber/vim-addon-mw-utils'
        Bundle 'tomtom/tlib_vim'
        if executable('ag')
            Bundle 'mileszs/ack.vim'
            let g:ackprg = 'ag --nogroup --nocolor --column --smart-case'
        elseif executable('ack-grep')
            let g:ackprg="ack-grep -H --nocolor --nogroup --column"
            Bundle 'mileszs/ack.vim'
        elseif executable('ack')
            Bundle 'mileszs/ack.vim'
        endif
    " }}}

    " VCS {{{
        Bundle 'tpope/vim-fugitive'
        Bundle 'tpope/vim-unimpaired'
        "Bundle 'airblade/vim-gitgutter'
    " }}}

    " General {{{
       Bundle 'VundleVim/Vundle.vim'
       "Bundle 'farseer90718/vim-taskwarrior'
       Bundle 'junegunn/vim-peekaboo'
       Bundle 'tpope/vim-surround'
       Bundle 'tpope/vim-repeat'
       Bundle 'kristijanhusak/vim-multiple-cursors'
       Bundle 'vim-scripts/sessionman.vim'
       Bundle 'bling/vim-airline'
       Bundle 'bling/vim-bufferline'
       Bundle 'flazz/vim-colorschemes'
       Bundle 'mbbill/undotree'
       Bundle 'nathanaelkane/vim-indent-guides'
       "Bundle 'vim-scripts/restore_view.vim'
       "Bundle 'mhinz/vim-signify'
       Bundle 'tpope/vim-abolish.git'
       Bundle 'osyo-manga/vim-over'
       "Bundle 'gcmt/wildfire.vim'
       Bundle 'christoomey/vim-tmux-navigator'
       Plugin 'tmux-plugins/vim-tmux'
       Plugin 'tmux-plugins/vim-tmux-focus-events'
       Plugin 'benmills/vimux'
       Plugin 'powerman/vim-plugin-AnsiEsc'
       Plugin 'Colorizer'
       Bundle 'kien/ctrlp.vim'
       Bundle 'bighostkim/nextfile.vim'
       Bundle "shougo/neocomplete.vim"
       Bundle "Konfekt/FastFold"
       Bundle "vim-scripts/YankRing.vim"
       Bundle "chrisbra/csv.vim"
       "Plugin 'wincent/command-t'
       "Bundle 'edkolev/promptline.vim'
       Bundle 'roman/golden-ratio'
       Bundle 'let-modeline.vim'
       Plugin 'embear/vim-localvimrc'
       Plugin 'xolox/vim-notes'
       Plugin 'jamessan/vim-gnupg'
       Bundle 'oblitum/rainbow'

       "Plugin 'simnalamburt/vim-mundo'
       "Plugin 'chrisbra/histwin.vim'
     " }}}

    " General Programming {{{
        "Bundle 'Shougo/vinarise.vim'
        Bundle 'ehamberg/vim-cute-python'
        Bundle 'calebsmith/vim-lambdify'
        Bundle 'scrooloose/syntastic'
        "Bundle 'mattn/webapi-vim'
        "Bundle 'mattn/gist-vim'
        Bundle 'scrooloose/nerdcommenter'
        Bundle 'godlygeek/tabular'
        Bundle 'majutsushi/tagbar'
        " Bundle 'xolox/vim-easytags'
        " Bundle 'lukaszkorecki/CoffeeTags'
    " }}}

    " Snippets & AutoComplete {{{
        "Bundle 'SirVer/ultisnips'
        Bundle 'honza/vim-snippets'
    " }}}

    " Python {{{
        Bundle 'klen/python-mode'
        Bundle 'yssource/python.vim'
        Bundle 'python_match.vim'
        Bundle 'davidhalter/jedi-vim'
        Bundle 'janko-m/vim-test'
    " }}}

    " Go {{{
        Bundle 'fatih/vim-go'
    " }}}

    " Javascript {{{
        Bundle 'digitaltoad/vim-jade'
        Bundle 'elzr/vim-json'
        Bundle 'groenewege/vim-less'
        Bundle 'pangloss/vim-javascript'
        Bundle 'kchmck/vim-coffee-script'
        Bundle 'jelera/vim-javascript-syntax'
        Bundle 'moll/vim-node'
        Bundle 'walm/jshint.vim'
        Bundle 'burnettk/vim-angular'
        Bundle 'othree/javascript-libraries-syntax.vim'
        Bundle 'matthewsimo/angular-vim-snippets'
    " }}}

    " HTML {{{
        Bundle 'alvan/vim-closetag'
        Bundle 'hail2u/vim-css3-syntax'
        "Bundle 'gorodinskiy/vim-coloresque'
    " }}}

    " Misc {{{
        Bundle 'tpope/vim-cucumber'
        Bundle 'quentindecock/vim-cucumber-align-pipes'
        Bundle 'saltstack/salt-vim'
        "Bundle 'wakatime/vim-wakatime'
        Bundle 'Chiel92/vim-autoformat'
        Bundle "jaxbot/semantic-highlight.vim"
        "Bundle "vim-scripts/Align"
        Bundle "vim-scripts/SQLUtilities"
        Bundle "garbas/vim-snipmate"
        "Bundle "vim-scripts/vim-chef"
        Bundle "mattn/vim-metarw-gdrive"
        Bundle "alkino/ods.vim"
    " }}}

    " Lua {{{
        Bundle "xolox/vim-misc"
    " }}}

    " Ruby {{{
        Bundle 'tpope/vim-rails'
        Bundle 'vim-ruby/vim-ruby'
        let g:rubycomplete_buffer_loading = 1
        "let g:rubycomplete_classes_in_global = 1
        let g:rubycomplete_rails = 1
    "}}}

" }}}

" Configuration {{{

    " Vim UI {{{

        if filereadable(expand("~/.vim/bundle/vim-colors-solarized/colors/solarized.vim"))
            let g:solarized_termcolors=256
            let g:solarized_termtrans=1
            let g:solarized_contrast="normal"
            let g:solarized_visibility="normal"
            color solarized             " Load a colorscheme
        endif

        set tabpagemax=15               " Only show 15 tabs
        set showmode                    " Display the current mode

        set background=dark         " Dark background
        set guifont=Terminess\ Powerline\ 12
        "colorscheme Revolution
        "colo vividchalk
        colo darkblack


        "set cursorline                  " Highlight current line

        "highlight clear SignColumn      " SignColumn should match background
        "highlight clear LineNr          " Current line number row will have same background color in relative mode
        "highlight

        if has('cmdline_info')
            set ruler                   " Show the ruler
            set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
            set showcmd                 " Show partial commands in status line and
                                        " Selected characters/lines in visual mode
        endif

        if has('statusline')
            set laststatus=2

            " Broken down into easily includeable segments
            set statusline=%<%f\                     " Filename
            set statusline+=%w%h%m%r                 " Options
            set statusline+=%{fugitive#statusline()} " Git Hotness
            set statusline+=\ [%{&ff}/%Y]            " Filetype
            set statusline+=\ [%{getcwd()}]          " Current dir
            set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
        endif

        set backspace=indent,eol,start
        set linespace=0                 " No extra spaces between rows
        set nu                          " Line numbers on
        set rnu                         " Set relative numbering
        set showmatch                   " Show matching brackets/parenthesis
        set incsearch                   " Find as you type search
        set hlsearch                    " Highlight search terms
        set winminheight=0              " Windows can be 1 line high
        set ignorecase                  " Case insensitive search
        set smartcase                   " Case sensitive when uc present
        set wildmenu                    " Show list instead of just completing
        set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
        set whichwrap=b,s,[,]   " Backspace and cursor keys wrap too
        set scrolljump=1                " Lines to scroll when cursor leaves screen
        set scrolloff=10                 " Minimum lines to keep above and below cursor
        set foldmethod=syntax
        set foldlevelstart=20
        "set foldenable                  " Auto fold code

    " }}}

    " Formatting {{{
        set ffs=unix
        set encoding=utf-8
        set fileencoding=utf-8
        set listchars=eol:¶
        set list
        set nowrap                      " Do not wrap long lines
        set list
        set autoindent                  " Indent at the same level of the previous line
        set shiftwidth=2                " Use indents of 2 spaces
        set expandtab                   " Tabs are spaces, not tabs
        set tabstop=2                   " An indentation every four columns
        set softtabstop=2               " Let backspace delete indent
        set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
        set splitright                  " Puts new vsplit windows to the right of the current
        set splitbelow                  " Puts new split windows to the bottom of the current
        "set matchpairs+=<:>             " Match, to be used with %
        set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
        "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
        " Remove trailing whitespaces and ^M chars
        " To disable the stripping of whitespace, add the following to your
        " .vimrc.before.local file:
        "   let g:spf13_keep_trailing_whitespace = 1
        autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,lua autocmd BufWritePre <buffer> call StripTrailingWhitespace()

        "autocmd FileType go autocmd BufWritePre <buffer> Fmt
        autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
        autocmd FileType haskell,puppet,ruby,yml,go setlocal expandtab shiftwidth=2 softtabstop=2
        " preceding line best in a plugin but here for now.

        autocmd BufNewFile,BufRead *.coffee set filetype=coffee

        " Workaround vim-commentary for Haskell
        autocmd FileType haskell setlocal commentstring=--\ %s
        " Workaround broken colour highlighting in Haskell
        autocmd FileType haskell,rust setlocal nospell

    " }}}

" }}}

" Keymappings {{{
    " General {{{
        "Unremap space from "Right"
        nnoremap <Space> <Nop>
        let mapleader = ","
        let localleader = '|'
        " Set toggle line wraps
        nmap <Leader>lb :set wrap!<CR> \| :set linebreak!<CR>
    " }}}

    " This is here to prevent remaping of ctrl_j by c.vim {{{
        let g:C_Ctrl_j   = 'off'
    " }}}

    " Easy splits navigation {{{
        nnoremap <C-J> <C-W>j
        nnoremap <C-K> <C-W>k
        nnoremap <C-L> <C-W>l
        nnoremap <C-H> <C-W>h
    " }}}

    " Wrapped lines j/k goes down to wrap instead of new line {{{
        noremap j gj
        noremap k gk
    " }}}

    " semantic highlight toggle {{{
        nnoremap <Leader>s :SemanticHighlightToggle<CR>
    " }}}

    " buffer switching keybinds {{{
        map <Leader>] gt
        map <Leader>[ gT
    " }}}

    " Tagbar remap {{{
        "nnoremap <silent> <Leader>tt :TagbarOpenAutoClose<CR>
    " }}}

    " Man map {{{
        map <leader>k <Plug>(Man)
    " }}}

    " Add modeline to file {{{
        nnoremap <silent> <Leader>ml :call AppendModeline()<CR>
    " }}}

    "  Map g* to relative motion {{{
        function! WrapRelativeMotion(key, ...)
            let vis_sel=""
            if a:0
                let vis_sel="gv"
            endif
            if &wrap
                execute "normal!" vis_sel . "g" . a:key
            else
                execute "normal!" vis_sel . a:key
            endif
        endfunction

        " Map g* keys in Normal, Operator-pending, and Visual+select
        noremap $ :call WrapRelativeMotion("$")<CR>
        noremap <End> :call WrapRelativeMotion("$")<CR>
        noremap 0 :call WrapRelativeMotion("0")<CR>
        noremap <Home> :call WrapRelativeMotion("0")<CR>
        noremap ^ :call WrapRelativeMotion("^")<CR>
        " Overwrite the operator pending $/<End> mappings from above
        " to force inclusive motion with :execute normal!
        onoremap $ v:call WrapRelativeMotion("$")<CR>
        onoremap <End> v:call WrapRelativeMotion("$")<CR>
        " Overwrite the Visual+select mode mappings from above
        " to ensure the correct vis_sel flag is passed to function
        vnoremap $ :<C-U>call WrapRelativeMotion("$", 1)<CR>
        vnoremap <End> :<C-U>call WrapRelativeMotion("$", 1)<CR>
        vnoremap 0 :<C-U>call WrapRelativeMotion("0", 1)<CR>
        vnoremap <Home> :<C-U>call WrapRelativeMotion("0", 1)<CR>
        vnoremap ^ :<C-U>call WrapRelativeMotion("^", 1)<CR>
    " }}}

    " Fast tab switching {{{
        map <S-H> :bp<CR>
        map <S-L> :bn<CR>
    " }}}

    " Stupid shift key fixes {{{
        if has("user_commands")
            command! -bang -nargs=* -complete=file E e<bang> <args>
            command! -bang -nargs=* -complete=file W w<bang> <args>
            command! -bang -nargs=* -complete=file Wq wq<bang> <args>
            command! -bang -nargs=* -complete=file WQ wq<bang> <args>
            command! -bang Wa wa<bang>
            command! -bang WA wa<bang>
            command! -bang Q q<bang>
            command! -bang QA qa<bang>
            command! -bang Qa qa<bang>
        endif
        cmap Tabe tabe
    " }}}

    " Yank from the cursor to the end of the line, to be consistent with C and D. {{{
        nnoremap Y y$
    " }}}

    " Code folding options {{{
        nmap <leader>f0 :set foldlevel=0<CR>
        nmap <leader>f1 :set foldlevel=1<CR>
        nmap <leader>f2 :set foldlevel=2<CR>
        nmap <leader>f3 :set foldlevel=3<CR>
        nmap <leader>f4 :set foldlevel=4<CR>
        nmap <leader>f5 :set foldlevel=5<CR>
        nmap <leader>f6 :set foldlevel=6<CR>
        nmap <leader>f7 :set foldlevel=7<CR>
        nmap <leader>f8 :set foldlevel=8<CR>
        nmap <leader>f9 :set foldlevel=9<CR>
    " }}}

    " Most prefer to toggle search highlighting rather than clear the current {{{
    " search results. To clear search highlighting rather than toggle it on
    " and off, add the following to your .vimrc.before.local file:
        nmap <silent> <leader>/ :set invhlsearch<CR>
    " }}}

    " Find merge conflict markers {{{
        map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>
    " }}}

    " Shortcuts Change Working Directory to that of the current file {{{
        cmap cd. lcd %:p:h
    " }}}

    " Visual shifting (does not exit Visual mode)  {{{
        vnoremap < <gv
        vnoremap > >gv
    " }}}

    " Allow using the repeat operator with a visual selection (!) {{{
    " http://stackoverflow.com/a/8064607/127816
        vnoremap . :normal .<CR>
    " }}}

    " For when you forget to sudo.. Really Write the file. {{{
        cmap w!! w !sudo tee % >/dev/null
    " }}}

    " Some helpers to edit mode {{{
    " http://vimcasts.org/e/14
        cnoremap %% <C-R>=expand('%:h').'/'<cr>
        map <leader>ew :e %%
        map <leader>es :sp %%
        map <leader>ev :vsp %%
        map <leader>et :tabe %%
    " }}}

    " Adjust viewports to the same size {{{
        map <Leader>= <C-w>=
    " }}}

    " Map <Leader>ff to display all lines with keyword under cursor {{{
    " and ask which one to jump to
        nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
    " }}}

    " Easier horizontal scrolling {{{
        map zl zL
        map zh zH
    " }}}

    " Easier formatting  {{{
        nnoremap <silent> <leader>q :Autoformat<CR>
    " }}}

" }}}

" Plugins {{{
    " Javascript Libraries Syntax {{{
        let g:used_javascript_libs = 'underscore,backbone,angularjs,jquery'
    " }}}

    " Angular ultisnips {{{
        let g:UltiSnipsSnippetDirectories=["UltiSnips"]
    "}}}

" CSApprox {{{
    let g:CSApprox_hook_post = [
                \ 'highlight Normal            ctermbg=NONE ctermfg=NONE',
                \ 'highlight NonText           ctermbg=NONE ctermfg=NONE'
                \]

" }}}

" Misc {{{
    if isdirectory(expand("~/.vim/bundle/nerdtree"))
        let g:NERDShutUp=1
    endif
    if isdirectory(expand("~/.vim/bundle/matchit.zip"))
        let b:match_ignorecase = 1
    endif
" }}}

" OmniComplete {{{
    if has("autocmd") && exists("+omnifunc")
        autocmd Filetype *
            \if &omnifunc == "" |
            \setlocal omnifunc=syntaxcomplete#Complete |
            \endif
    endif

    hi Pmenu  guifg=#000000 guibg=#F8F8F8 ctermfg=black ctermbg=Lightgray
    hi PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
    hi PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE

    " Some convenient mappings
    inoremap <expr> <C-n> pumvisible() ? '<C-n>' : '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
    inoremap <expr> <M-,> pumvisible() ? '<C-n>' : '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

    " Automatically open and close the popup menu / preview window
    au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
    set completeopt=menu,longest
" }}}

" C stuff {{{
    let g:formatprg_args_expr_c = '"--mode=c --style=linux -pcH".(&expandtab ? "s".&shiftwidth : "t")'
    let g:formatprg_args_expr_cpp = '"--mode=c --style=linux -pcH".(&expandtab ? "s".&shiftwidth : "t")'
    let g:alternateNoDefaultAlternate = 1

"}}}

" SmartPairs {{{
    let g:smartpairs_uber_mode = 0
"}}}

" Ctags {{{
    set tags=./tags;/,~/.vimtags

    " Make tags placed in .git/tags file available in all levels of a repository
    let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
    if gitroot != ''
        let &tags = &tags . ',' . gitroot . '/.git/tags'
    endif
" }}}

" AutoCloseTag {{{
    " Make it so AutoCloseTag works for xml and xhtml files as well
    au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
    nmap <Leader>ac <Plug>ToggleAutoCloseMappings
" }}}

" Tabularize {{{
    if isdirectory(expand("~/.vim/bundle/tabular"))
        nmap <Leader>a& :Tabularize /&<CR>
        vmap <Leader>a& :Tabularize /&<CR>
        nmap <Leader>a= :Tabularize /=<CR>
        vmap <Leader>a= :Tabularize /=<CR>
        nmap <Leader>a=> :Tabularize /=><CR>
        vmap <Leader>a=> :Tabularize /=><CR>
        nmap <Leader>a: :Tabularize /:<CR>
        vmap <Leader>a: :Tabularize /:<CR>
        nmap <Leader>a:: :Tabularize /:\zs<CR>
        vmap <Leader>a:: :Tabularize /:\zs<CR>
        nmap <Leader>a, :Tabularize /,<CR>
        vmap <Leader>a, :Tabularize /,<CR>
        nmap <Leader>a,, :Tabularize /,\zs<CR>
        vmap <Leader>a,, :Tabularize /,\zs<CR>
        nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
        vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
    endif
" }}}

" Session List {{{
    set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
    if isdirectory(expand("~/.vim/bundle/sessionman.vim/"))
        nmap <leader>sl :SessionList<CR>
        nmap <leader>ss :SessionSave<CR>
        nmap <leader>sc :SessionClose<CR>
    endif
" }}}

" JSON {{{
    nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
    let g:vim_json_syntax_conceal = 0
" }}}

" PyMode {{{
    " Disable if python support not present
    if !has('python')
        let g:pymode = 0
    endif

    if isdirectory(expand("~/.vim/bundle/python-mode"))
        let g:pymode_lint_checkers       = ['flake8']
        let g:pymode_trim_whitespaces    = 1
        let g:pymode_options             = 0
        let g:pymode_rope                = 1
        let g:pymod_run                  = 1
        let g:pymode_folding             = 1
        let g:pymode_syntax              = 1
        let g:pymode_syntax_all          = 1
        let g:pymode_syntax_slow_sync    = 1
        let g:pymode_trim_whitespaces    = 1
        let g:pymode_lint                = 1
        let g:pymode_options_colorcolumn = 0
        let g:pymode_lint_cwindow        = 1
        let g:pymode_rope_autoimport     = 1
        let g:pymode_rope_autoimport_import_after_complete = 1
        let g:pymode_run_bind = '<leader>pr'
    endif
" }}}

" TagBar {{{
    if isdirectory(expand("~/.vim/bundle/tagbar/"))

        " If using go please install the gotags program using the following
        " go install github.com/jstemmer/gotags
        " And make sure gotags is in your path
        let g:tagbar_type_go = {
            \ 'ctagstype' : 'go',
            \ 'kinds'     : [  'p:package', 'i:imports:1', 'c:constants', 'v:variables',
                \ 't:types',  'n:interfaces', 'w:fields', 'e:embedded', 'm:methods',
                \ 'r:constructor', 'f:functions' ],
            \ 'sro' : '.',
            \ 'kind2scope' : { 't' : 'ctype', 'n' : 'ntype' },
            \ 'scope2kind' : { 'ctype' : 't', 'ntype' : 'n' },
            \ 'ctagsbin'  : 'gotags',
            \ 'ctagsargs' : '-sort -silent'
            \ }
    endif
"}}}

" Fugitive {{{
    if isdirectory(expand("~/.vim/bundle/vim-fugitive/"))
        nnoremap <silent> <leader>gs :Gstatus<CR>
        nnoremap <silent> <leader>gd :Gdiff<CR>
        nnoremap <silent> <leader>gc :Gcommit<CR>
        nnoremap <silent> <leader>gb :Gblame<CR>
        nnoremap <silent> <leader>gl :Glog<CR>
        nnoremap <silent> <leader>gp :Git push<CR>
        nnoremap <silent> <leader>gr :Gread<CR>
        nnoremap <silent> <leader>gw :Gwrite<CR>
        nnoremap <silent> <leader>ge :Gedit<CR>
        " Mnemonic _i_nteractive
        nnoremap <silent> <leader>gi :Git add -p %<CR>
        nnoremap <silent> <leader>gg :SignifyToggle<CR>
    endif
"}}}

" Normal Vim omni-completion {{{
    " Enable omni-completion.
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
    autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

" }}}

" UndoTree {{{
    if isdirectory(expand("~/.vim/bundle/undotree/"))
        nnoremap <Leader>u :UndotreeToggle<CR>
        " If undotree is opened, it is likely one wants to interact with it.
        let g:undotree_SetFocusWhenToggle=1
    endif
" }}}

" indent_guides {{{
    "if isdirectory(expand("~/.vim/bundle/vim-indent-guides/"))
        "let g:indent_guides_start_level = 2
        "let g:indent_guides_guide_size = 1
        "let g:indent_guides_enable_on_vim_startup = 1
    "endif
" }}}

" Wildfire {{{
    let g:wildfire_objects = {
        \ "*" : ["i'", 'i"', "i)", "i]", "i}", "ip"],
        \ "html,xml" : ["at"],
        \ }
" }}}

" vim-airline {{{
    " Set configuration options for the statusline plugin vim-airline.
    " Use the powerline theme and optionally enable powerline symbols.
    " To use the symbols î‚°, î‚±, î‚², î‚³, î‚ , î‚¢, and î‚¡.in the statusline
    " segments add the following to your .vimrc.before.local file:
    "   let g:airline_powerline_fonts=1
    " If the previous symbols do not render for you then install a
    " powerline enabled font.

    " See `:echo g:airline_theme_map` for some more choices
    " Default in terminal vim is 'dark'
    if isdirectory(expand("~/.vim/bundle/vim-airline/"))
        let g:airline_powerline_fonts = 1
        ""let g:airline_theme = 'solarized'
        let g:airline#extensions#tabline#enabled = 1
        let g:airline#extensions#bufferline#enabled = 1
        " bufferline fixes
        " Set buffers to fixed location
        let g:bufferline_rotate = 1
        let g:bufferline_active_buffer_left = "["
        let g:bufferline_active_buffer_right = "]"
        let g:bufferline_show_bufnr = 0
        let g:bufferline_fixed_index = 1
        let g:airline_section_c = '%<%{bufferline#refresh_status()}%#airline_c#%#bufferline_selected# %{g:bufferline_status_info.current} %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'
        let g:airline#extensions#tagbar#flags = 'f'
        if !exists('g:airline_symbols')
          let g:airline_symbols = {}
        endif
        let g:airline_symbols.space = "\ua0"
    endif
" }}}

    " JsBeautify {{{
        " for js
        autocmd FileType javascript noremap <buffer>  <leader>q :call JsBeautify()<cr>
        " for html
        autocmd FileType html noremap <buffer> <leader>q :call HtmlBeautify()<cr>
        " for css or scss
        autocmd FileType css noremap <buffer> <leader>q :call CSSBeautify()<cr>
    "}}}

" }}}

" GUI {{{
    set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
    highlight Normal ctermbg=NONE
    "highlight NonText ctermbg=NONE ctermfg=NONE
" }}}

" Functions {{{
    " Initialize directories {{{
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

    " Initialize NERDTree as needed {{{
    function! NERDTreeInitAsNeeded()
        redir => bufoutput
        buffers!
        redir END
        let idx = stridx(bufoutput, "NERD_tree")
        if idx > -1
            NERDTreeMirror
            NERDTreeFind
            wincmd l
        endif
    endfunction
    " }}}

    " Strip whitespace {{{
    function! StripTrailingWhitespace()
        " Preparation: save last search, and cursor position.
        let _s=@/
        let l = line(".")
        let c = col(".")
        " do the business:
        %s/\s\+$//e
        " clean up: restore previous search history, and cursor position
        let @/=_s
        call cursor(l, c)
    endfunction
    " }}}

    " Shell command {{{
    function! s:RunShellCommand(cmdline)
        botright new

        setlocal buftype=nofile
        setlocal bufhidden=delete
        setlocal nobuflisted
        setlocal noswapfile
        setlocal nowrap
        setlocal filetype=shell
        setlocal syntax=shell

        call setline(1, a:cmdline)
        call setline(2, substitute(a:cmdline, '.', '=', 'g'))
        execute 'silent $read !' . escape(a:cmdline, '%#')
        setlocal nomodifiable
        1
    endfunction

    command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
    " e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
    " }}}

    " Add modeline {{{
        function! AppendModeline()
            let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
                  \ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
            let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
            call append(line("$"), l:modeline)
        endfunction
    " }}}
" }}}

" Custom {{{
  set spf=~/.vimspell.en.add
  set list
  "let g:promptline_preset = {
        "\'a'    : [ '$USER' ],
        "\'b'    : [ promptline#slices#cwd() ],
        "\'c'    : [ promptline#slices#vcs_branch() ],
        "\'x'    : [ promptline#slices#git_status() ],
        "\'y'    : [ '%*' ],
        "\'warn' : [ promptline#slices#last_exit_code() ],
        "\'z'    : [ promptline#slices#host() ],
        "\'options': {
          "\'left_sections' : [ 'a', 'b' ],
          "\'right_sections' : [ 'warn', 'x', 'c', 'y', 'z' ],
          "\'left_only_sections' : [ 'a', 'c', 'b' ]}}
  set sbr= lcs=tab:!-,trail:~ wrap  " List mode and non-text characters
  nmap _s :%s/\s\+$//<CR>
  map gn :tabnew<cr>
  highlight HighLight ctermbg=27
  highlight HighLight1 ctermbg=28
  highlight HighLight2 ctermbg=29
  command -nargs=+ Hl :match HighLight /<args>/
  command -nargs=+ Hl1 :2match HighLight1 /<args>/
  command -nargs=+ Hl2 :3match HighLight2 /<args>/
  nmap <leader>hh :Hl <C-r><C-w><CR>
  nmap <leader>hj :Hl1 <C-r><C-w><CR>
  nmap <leader>hk :Hl2 <C-r><C-w><CR>
  highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg
  highlight DiffDelete cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg
  highlight DiffChange cterm=bold ctermfg=10 ctermbg=17 gui=none guifg=bg
  highlight DiffText   cterm=bold ctermfg=10 ctermbg=88 gui=none guifg=bg
  highligh CursorLine term=bold cterm=bold guibg=Grey40

  highligh Search term=bold cterm=bold ctermbg=21 guibg=Grey40

  map <F10> :set rnu!<CR>:set nu!<CR>

  "noremap   <Up>     :echo "NO!"<CR>
  "oremap   <Down>   :echo "NO!"<CR>
  "oremap   <Left>   :echo "NO!"<CR>
  "oremap   <Right>  :echo "NO!"<CR>
  execute pathogen#infect()

  set statusline+=%#warningmsg#
  set statusline+=%{SyntasticStatuslineFlag()}
  set statusline+=%*

  let g:syntastic_always_populate_loc_list = 1
  let g:syntastic_auto_loc_list = 1
  let g:syntastic_check_on_open = 1
  let g:syntastic_check_on_wq = 0

  filetype plugin indent on   " Automatically detect file types.
  let g:UltiSnipsExpandTrigger="<c-e>"

  set runtimepath^=~/.vim/bundle/ctrlp.vim
  let g:ctrlp_working_path_mode = 'ra'
  let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/](node_modules|assets|migrations|lib)$',
    \ 'file': '\v\.(jar|orig|html)$',
    \ }
  let g:ctrlp_root_markers = ['.idea']


  let g:tagbr_type_coffee = {
    \ 'ctagstype' : 'coffee',
    \ 'kinds'     : [
        \ 'c:classes',
        \ 'm:methods',
        \ 'f:functions',
        \ 'v:variables',
        \ 'f:fields',
    \ ]
  \ }

  let g:relatedFiles = {
    \ "Node JS" : {
      \ "Controller" : { "expression" : "server/controllers/(.*).coffee$", "transform" : "pluralize" },
      \ "View" : { "expression" : "server/views/(.*)/", "transform" : "pluralize" },
      \ "Model" : { "expression" : "server/models/(.*).coffee$", "transform" : "singularize" },
      \ "Functional" : { "expression" : "test/functional/features/(.*)/$", "transform" : "pluralize" }
    \ }
  \ }

  "let g:CommandTFileScanner = 'watchman'
  "let g:CommandTWildIgnore=&wildignore . ",*/node_modules,*/lib,*/assets,*/migrations,*.html,*/materialadmin_assets,*/coverage_functional,*/coverage_integrational,*.orig,*/creatives,*.sql"
  "let g:CommandTSCMDirectories = '.git,.hg,.svn,.bzr,_darcs,.idea'
  "let g:CommandTMaxCachedDirectories = 4

  let g:acp_enableAtStartup = 0
  let g:neocomplete#enable_at_startup = 1
  let g:neocomplete#enable_smart_case = 1
  let g:neocomplete#disable_auto_complete = 1


  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  autocmd BufNewFile,BufReadPost *.coffee setl foldmethod=indent
  autocmd FileType jade setlocal fdm=indent

  inoremap <expr><C-l> neocomplete#complete_common_string()

  "if !exists('g:neocomplete#sources#omni#input_patterns')
    "let g:neocomplete#sources#omni#input_patterns = {}
  "endif

  nmap <leader>r :call NextFile()<CR>
  nmap <F3> :YRShow<CR>
  set iskeyword-=.

  :highlight ExtraWhitespace ctermbg=red guibg=red
  " The following alternative may be less obtrusive.
  :highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
  " Try the following if your GUI uses a dark background.
  :highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
  :autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
  " Show trailing whitespace:
  :match ExtraWhitespace /\s\+$\|\s\+$\| \+\ze\t\|\s\+\%#\@<!$\|[^ ]*\s+,/


  :let b:csv_arrange_leftalign = 1

  nnoremap <leader>a, <Plug>AM_a,
  nnoremap <leader>a= <Plug>AM_a=
  "nnoremap <leader>tt <Plug>AM_tt

  let g:sqlutil_align_where = 0
  "let g:sqlutil_align_comma = 1

  set lazyredraw

  let g:golden_ratio_wrap_ignored = 1
  let g:golden_ratio_exclude_nonmodifiable = 1
  let g:go_fmt_autosave=0
  set expandtab

  map <leader>C :%s/\r//ge<CR>:retab!<CR>_s:diffupdate<CR>:wincmd w<CR>:%s/\r//ge<CR>:retab!<CR>_s:diffupdate<CR>:wincmd w<CR>

  set diffopt+=iwhite
  set diffexpr=DiffW()
  function DiffW()
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

  let g:syntastic_java_checkers=['']
  let g:localvimrc_sandbox=0
  let g:localvimrc_ask=0
  let g:go_version_warning = 0
  autocmd FileType ruby,eruby set filetype=ruby.eruby.chef
  imap <C-e> <C-R>=snipMate#TriggerSnippet(1)<CR>

  let g:notes_directories = ['~/Documents/Notes']
  let g:notes_suffix = '.txt'
  let g:notes_list_bullets = ['√', '•', '▸', '¿', '▹', '▪', '▫', 'x']
  map <leader>v ^r√w
  map <leader>o ^r•w
  map <leader>p ^r▸w
  map <leader>? ^r¿w
  map <leader>x ^rxw
  nnoremap <C-m> :make<CR><CR>
  nnoremap <leader>u :cs find s <cword><CR>
  set mps+=<:>

  nmap <silent> <leader>tt <CR>:TestNearest<CR>
  nmap <silent> <leader>tf <CR>:TestFile<CR>
  nmap <silent> <leader>ta <CR>:TestSuite<CR>
  nmap <silent> <leader>. <CR>:TestLast<CR>
  nmap <silent> <leader>tv <CR>:TestVisit<CR>
  let test#strategy = "vimterminal"
  let g:rainbow_active = 1

" }}}
