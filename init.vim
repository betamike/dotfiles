call plug#begin('~/.local/share/nvim/plugged')

" general dev tools
" Plug 'w0rp/ale'
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Plug 'junegunn/fzf.vim'
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'LnL7/vim-nix'
Plug 'hashivim/vim-terraform'

" go tools
" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" rust tools
" Plug 'rust-lang/rust.vim'

" git
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'

" beautify
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'liuchengxu/space-vim-theme'

" python tools
" Plug 'deoplete-plugins/deoplete-jedi'
" Plug 'davidhalter/jedi-vim'
" Plug 'hdima/python-syntax'
Plug 'vim-python/python-syntax'

" Javascript
" Plug 'yuezk/vim-js'
" Plug 'maxmellon/vim-jsx-pretty'

" Plug 'autozimu/LanguageClient-neovim', {
"     \ 'branch': 'next',
"     \ 'do': 'bash install.sh',
"     \ }

call plug#end()

set nocompatible
set encoding=utf-8
set shortmess+=c
set showcmd
set noshowmode

set completeopt-=preview
set completeopt+=noinsert
set completeopt+=noselect

if has("termguicolors")
    set termguicolors
endif

set background=dark
" colorscheme gruvbox
colorscheme space_vim_theme 

"always show status bar
set laststatus=2

set number
syntax enable
filetype plugin on
filetype plugin indent on

"indent and tab
set nowrap
set expandtab
set backspace=indent,eol,start
set tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType javascript setlocal shiftwidth=2 softtabstop=2

"turn paste mode on and off with F3
set pastetoggle=<F3>

"search
set hlsearch
set incsearch
set ignorecase
set smartcase

"wildmenu config
set wildmenu
set wildmode=longest:full,full

"Better split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

set splitbelow
set splitright

" choose the fastest available searcher
if executable('rg')
  let g:ctrlp_user_command = 'rg --files %s'
  set grepprg=rg\ --no-heading\ --vimgrep\ --smart-case
endif

" vim-signify
let g:signify_vcs_list = [ 'git', 'hg' ]
let g:signify_sign_change = "~"

" clojureee
au FileType clojure RainbowParentheses

"Go specific settings
au BufRead,BufNewFile *.go set list noexpandtab syntax=go listchars=tab:\|\ ,trail:-

" YAML
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

function! CleverTab()
  if pumvisible()
    return "\<C-N>"
  endif
  if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
    return "\<Tab>"
  elseif exists('&omnifunc') && &omnifunc != ''
    return "\<C-X>\<C-O>"
  else
    return "\<C-N>"
  endif
endfunction

inoremap <Tab> <C-R>=CleverTab()<CR>
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"

" inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"

let g:ale_fixers = {
    \ 'javascript': ['prettier', 'eslint'],
    \ 'python': ['black'],
    \ }

let g:LanguageClient_serverCommands = {
    \ 'rust': ['rust-analyzer'],
    \ 'python': ['/usr/local/bin/pyls'],
    \ 'reason': ['/home/mike/bin/reason-language-server'],
    \ 'javascript': ['/usr/bin/javascript-typescript-stdio'],
    \ }

let g:python_highlight_all = 1

let g:go_fmt_command = "goimports"
let g:go_doc_popup_window = 1

let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_methods = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
"let g:go_highlight_variable_declarations = 1
"let g:go_highlight_variable_assignments = 1

" vim-jedi settings
" disable vim-jedi autocomplete as we get it with deoplete-jedi
" but we want all the other functionality
let g:jedi#completions_enabled = 0
" let g:jedi#use_splits_not_buffers = 'winwidth'

" deoplete configuration
let g:deoplete#enable_at_startup = 1

if filereadable(expand("~/.vim/local.vim"))
    source ~/.vim/local.vim
endif
