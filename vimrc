" load pathogen from bundle dir
runtime bundle/vim-pathogen/autoload/pathogen.vim
"load pathogen plugins
call pathogen#infect()

set nocompatible
set encoding=utf-8
set showcmd

set background=dark
set termguicolors
colorscheme molokai "gruvbox zenburn
let g:molokai_original = 1

"always show status bar
set laststatus=2

set number
syntax enable
filetype plugin on
filetype plugin indent on

"Go specific settings
set rtp+=$GOROOT/misc/vim
au BufRead,BufNewFile *.go set list noexpandtab syntax=go listchars=tab:\|\ ,trail:-
set completeopt-=preview

function! InsertTabWrapper()
  if pumvisible()
    return "\<c-n>"
  endif
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-x>\<c-o>"
  endif
endfunction
inoremap <expr><tab> InsertTabWrapper()
inoremap <expr><s-tab> pumvisible()?"\<c-p>":"\<c-d>"

let g:deoplete#enable_at_startup = 1

let g:syntastic_go_checkers = ['go', 'goimports', 'govet', 'golint']
let g:deoplete#sources#go#gocode_binary = '~/bin/gocode'
let g:deoplete#sources#go#use_cache = 1
let g:deoplete#sources#go#json_directory = '~/.cache/deoplete/go/$GOOS_$GOARCH'

let g:go_fmt_command = "goimports"
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_structs = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

if filereadable(expand("~/.vim/local.vim"))
    source ~/.vim/local.vim
endif

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
let g:tagbar_width = 60
let g:tagbar_sort = 0

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
