call plug#begin('~/.local/share/nvim/plugged')

Plug 'w0rp/ale'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'morhetz/gruvbox'

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

Plug 'hdima/python-syntax'

Plug 'rust-lang/rust.vim'

Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'

Plug 'vim-airline/vim-airline'

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
"colorscheme molokai "gruvbox zenburn
" colorscheme material-monokai
"let g:molokai_original = 1
colorscheme gruvbox

"always show status bar
set laststatus=2

set number
syntax enable
filetype plugin on
filetype plugin indent on

"indent and tab
set nowrap
set expandtab
set tabstop=4 shiftwidth=4 softtabstop=4
set backspace=indent,eol,start

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

"configure code folding bindings
nnoremap <space> za
vnoremap <space> zf

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
elseif executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  set grepprg=ag\ --nogroup\ --nocolor
endif

" vim-signify
let g:signify_vcs_list = [ 'git', 'hg' ]
let g:signify_sign_change = "~"


"Go specific settings
set rtp+=$GOROOT/misc/vim
au BufRead,BufNewFile *.go set list noexpandtab syntax=go listchars=tab:\|\ ,trail:-
autocmd FileType go map <buffer> <c-d> :GoDoc<CR>

" FZF
set rtp+=$HOME/.fzf
command! -bang -nargs=* RgFzf 
  \ call fzf#run(fzf#wrap('rgfzf', {'source': "rg --files"}, <bang>0))
" nmap <c-p> :Files<CR>
nmap <c-p> :RgFzf<CR>
nnoremap <C-g>b :Buffers<CR>
nnoremap <C-g>g :Rg<CR>
nnoremap <C-g>l :BLines<CR>
nnoremap <C-g>c :Commands<CR>

" use ripgrep instead of ag/grep
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

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

let g:go_fmt_command = "goimports"
let g:syntastic_go_checkers = ['go', 'goimports', 'govet', 'golint']

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
let g:jedi#use_splits_not_buffers = 'winwidth'

" deoplete configuration
let g:deoplete#enable_at_startup = 1

" deoplete Go
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
let g:deoplete#sources#go#gocode_binary = '/home/cugini/go/bin/gocode'
let g:deoplete#sources#go#use_cache = 1
let g:deoplete#sources#go#json_directory = '~/.cache/deoplete/go/$GOOS_$GOARCH'

" deoplete Rust
let g:deoplete#sources#rust#racer_binary = '/home/cugini/.cargo/bin/racer'
let g:deoplete#sources#rust#rust_source_path = '/home/cugini/Projects/rust/src'

"configure tagbar
nmap <F8> :TagbarToggle<CR>
let g:tagbar_width = 60
let g:tagbar_sort = 0

if filereadable(expand("~/.vim/local.vim"))
    source ~/.vim/local.vim
endif
