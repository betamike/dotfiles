
call plug#begin('~/.local/share/nvim/plugged')

" general dev tools
Plug 'LnL7/vim-nix'
Plug 'hashivim/vim-terraform'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'kyazdani42/nvim-web-devicons'

" Search
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'ggandor/leap.nvim'

" LSP Configs
Plug 'williamboman/mason.nvim'
Plug 'WhoIsSethDaniel/mason-tool-installer.nvim'

Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason-lspconfig.nvim'

Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'jayp0521/mason-null-ls.nvim'

Plug 'folke/trouble.nvim'
Plug 'folke/lsp-colors.nvim'

Plug 'glepnir/lspsaga.nvim', { 'branch': 'main' }
Plug 'rmagatti/goto-preview'
Plug 'ray-x/lsp_signature.nvim'
Plug 'simrat39/symbols-outline.nvim'

" Autocomplete
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}

" Autoformat
Plug 'mhartington/formatter.nvim'

" git
Plug 'akinsho/git-conflict.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-fugitive'
Plug 'ruifm/gitlinker.nvim'

" themes
Plug 'morhetz/gruvbox'
Plug 'liuchengxu/space-vim-theme'

" beautify
Plug 'feline-nvim/feline.nvim'

" Typescript
Plug 'jose-elias-alvarez/typescript.nvim'

" python tools
Plug 'vim-python/python-syntax'
call plug#end()

set nocompatible
set encoding=utf-8
set shortmess+=c
set showcmd
set noshowmode
set mouse=

set completeopt-=preview
set completeopt+=noinsert
set completeopt+=noselect

if has("termguicolors")
    set termguicolors
endif

set background=dark
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

"Go specific settings
au BufRead,BufNewFile *.go set list noexpandtab syntax=go listchars=tab:\|\ ,trail:-

" YAML
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
" typescript
autocmd FileType typescript,typescriptreact,typrscript.tsx setlocal ts=2 sts=2 sw=2 expandtab
" javascript
autocmd FileType javascript,javascriptreact,javascript.jsx setlocal ts=2 sts=2 sw=2 expandtab

let g:python_highlight_all = 1

let g:coq_settings = { 'auto_start': v:true }
lua require("lsp_config")
lua require("misc")

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>gf <cmd>Telescope git_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

if filereadable(expand("~/.vim/local.vim"))
    source ~/.vim/local.vim
endif
