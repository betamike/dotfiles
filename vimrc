" load pathogen from bundle dir
runtime bundle/vim-pathogen/autoload/pathogen.vim
"load pathogen plugins
call pathogen#infect()

set nocompatible
set encoding=utf-8
set showcmd

set background=dark
colorscheme molokai
let g:molokai_original = 1

"always show status bar
set laststatus=2

"Go specific settings
set rtp+=$GOROOT/misc/vim
au BufRead,BufNewFile *.go set list noexpandtab syntax=go listchars=tab:\|\ ,trail:- 
set completeopt-=preview

set number
syntax enable
filetype plugin on
filetype plugin indent on

"work
autocmd BufRead,BufNewFile *sr?/server/*.py set colorcolumn=100
autocmd BufRead,BufNewFile *src/client/*.py set colorcolumn=120

"enable mouse
"set mouse=a

"indent and tab
set nowrap
set expandtab
set tabstop=4 shiftwidth=4 softtabstop=4
set backspace=indent,eol,start

"search
set hlsearch
set incsearch
set ignorecase
set smartcase

"wildmenu config
set wildmenu
set wildmode=longest:full,full

"configure code folding bindings
nnoremap <space> za
vnoremap <space> zf

"turn paste mode on and off with F3
set pastetoggle=<F3>

"configure tagbar
nmap <F8> :TagbarToggle<CR>

let g:tagbar_type_scala = {
    \ 'ctagstype' : 'Scala',
    \ 'kinds'     : [
        \ 'p:packages:1',
        \ 'V:values',
        \ 'v:variables',
        \ 'T:types',
        \ 't:traits',
        \ 'o:objects',
        \ 'a:aclasses',
        \ 'c:classes',
        \ 'r:cclasses',
        \ 'm:methods'
    \ ]
\ }

let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }
