local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- general dev tools
    'LnL7/vim-nix',
    'hashivim/vim-terraform',
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            require'nvim-treesitter.configs'.setup { -- A list of parser names, or "all"
              ensure_installed = {
                  "bash",
                  "comment",
                  "dockerfile",
                  "go",
                  "gomod",
                  "gosum",
                  "lua",
                  "javascript",
                  "json",
                  "jsonc",
                  "proto",
                  "python",
                  "markdown",
                  "markdown_inline",
                  "nix",
                  "terraform",
                  "toml",
                  "typescript",
                  "vim",
                  "yaml",
                  "zig",
              },

              -- Install parsers synchronously (only applied to `ensure_installed`)
              sync_install = false,
              highlight = {
                -- `false` will disable the whole extension
                enable = true,

                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = false,
              },
            }
        end
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        event = "InsertEnter",
        dependencies = { 
            'nvim-treesitter/nvim-treesitter',
        },
    },
    'nvim-tree/nvim-web-devicons',
    -- Search
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = { 
            'nvim-lua/plenary.nvim',
            { 
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
            },
        },
    },

    -- LSP Configs + Autocomplete
    'williamboman/mason.nvim',
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
          'williamboman/mason.nvim',
        },
        -- config = function()
        init = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                automatic_installation = true,
            })
        end,
    },
    {
      'neovim/nvim-lspconfig',
      lazy = false,
      dependencies = {
        { 'ms-jpq/coq_nvim', branch = 'coq' },
        { 'ms-jpq/coq.artifacts', branch = 'artifacts' },
        { 'ms-jpq/coq.thirdparty', branch = '3p' },
        'williamboman/mason-lspconfig.nvim',
      },
      init = function()
        vim.g.coq_settings = {
            auto_start = true,
        }
      end,
      config = function()
        local lsp = require "lspconfig"
        local coq = require "coq"

        local servers = { 'dockerls', 'gopls', 'jedi_language_server', 'yamlls', 'zls' }
        for _, server in pairs(servers) do
          lsp[server].setup(coq.lsp_ensure_capabilities {})
        end
        require("coq_3p") {
          { src = "copilot", short_name = "COP", accept_key = "<c-f>" },
        }
      end,
    },
    {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        dependencies = {
            'williamboman/mason.nvim',
        },
    },

    {
        'nvimtools/none-ls.nvim',
        dependencies = {
          "nvimtools/none-ls-extras.nvim",
          "gbprod/none-ls-shellcheck.nvim",
        },
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    -- go
                    null_ls.builtins.diagnostics.golangci_lint,
                    null_ls.builtins.diagnostics.staticcheck,

                    -- typescript/javascript
                    require("none-ls.diagnostics.eslint"),
                    require("none-ls.code_actions.eslint"),
                    null_ls.builtins.formatting.prettier,

                    -- python
                    null_ls.builtins.diagnostics.mypy,
                    null_ls.builtins.formatting.black,
                    require("none-ls.diagnostics.flake8"),

                    -- shell
                    require("none-ls-shellcheck.diagnostics"),
                    require("none-ls-shellcheck.code_actions"),
                },
                on_attach = on_attach
            })
        end,
    },
    {
        'jay-babu/mason-null-ls.nvim',
        dependencies = {
          'williamboman/mason.nvim',
          'WhoIsSethDaniel/mason-tool-installer.nvim',
          'nvimtools/none-ls.nvim',
        },
        config = function()
            require("mason-null-ls").setup({
                automatic_installation = { exclude = { "mypy" } },
            })
        end,
    },
    {
      "folke/trouble.nvim",
      opts = {},
      cmd = "Trouble",
      keys = {
        {
          "<leader>xx",
          "<cmd>Trouble diagnostics toggle<cr>",
          desc = "Diagnostics (Trouble)",
        },
        {
          "<leader>xX",
          "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
          desc = "Buffer Diagnostics (Trouble)",
        },
        {
          "<leader>cs",
          "<cmd>Trouble symbols toggle focus=false<cr>",
          desc = "Symbols (Trouble)",
        },
        {
          "<leader>cl",
          "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
          desc = "LSP Definitions / references / ... (Trouble)",
        },
        {
          "<leader>xL",
          "<cmd>Trouble loclist toggle<cr>",
          desc = "Location List (Trouble)",
        },
        {
          "<leader>xQ",
          "<cmd>Trouble qflist toggle<cr>",
          desc = "Quickfix List (Trouble)",
        },
      },
    },
    {
        'nvimdev/lspsaga.nvim',
        config = function()
            require('lspsaga').setup({
              outline = {
                win_width = 50,
              },
              lightbulb = {
                enabled = false,
                virtual_text = false,
                sign = false,
              },
            })
            local keymap = vim.keymap.set
            -- LSP finder - Find the symbol's definition
            -- If there is no definition, it will instead be hidden
            -- When you use an action in finder like "open vsplit",
            -- you can use <C-t> to jump back
            keymap("n", "gh", "<cmd>Lspsaga finder<CR>")
            -- Code action
            keymap({"n","v"}, "<leader>ca", "<cmd>Lspsaga code_action<CR>")
            -- Rename all occurrences of the hovered word for the entire file
            keymap("n", "gr", "<cmd>Lspsaga rename<CR>")
            -- Rename all occurrences of the hovered word for the selected files
            keymap("n", "gr", "<cmd>Lspsaga rename ++project<CR>")
            -- Peek definition
            -- You can edit the file containing the definition in the floating window
            -- It also supports open/vsplit/etc operations, do refer to "definition_action_keys"
            -- It also supports tagstack
            -- Use <C-t> to jump back
            keymap("n", "gD", "<cmd>Lspsaga peek_definition<CR>")
            -- Go to definition
            keymap("n","gd", "<cmd>Lspsaga goto_definition<CR>")
            -- Peek type definition
            -- You can edit the file containing the type definition in the floating window
            -- It also supports open/vsplit/etc operations, do refer to "definition_action_keys"
            -- It also supports tagstack
            -- Use <C-t> to jump back
            keymap("n", "gt", "<cmd>Lspsaga peek_type_definition<CR>")
            -- Go to type definition
            keymap("n","gt", "<cmd>Lspsaga goto_type_definition<CR>")
            -- Show line diagnostics
            -- You can pass argument ++unfocus to
            -- unfocus the show_line_diagnostics floating window
            keymap("n", "<leader>sl", "<cmd>Lspsaga show_line_diagnostics<CR>")
            -- Show cursor diagnostics
            -- Like show_line_diagnostics, it supports passing the ++unfocus argument
            keymap("n", "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<CR>")
            -- Show buffer diagnostics
            keymap("n", "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>")
            -- Diagnostic jump
            -- You can use <C-o> to jump back to your previous location
            keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
            keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>")
            -- Diagnostic jump with filters such as only jumping to an error
            keymap("n", "[E", function()
              require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
            end)
            keymap("n", "]E", function()
              require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
            end)
            -- Toggle outline
            keymap("n","<leader>o", "<cmd>Lspsaga outline<CR>")
            -- Hover Doc
            -- If there is no hover doc,
            -- there will be a notification stating that
            -- there is no information available.
            -- To disable it just use ":Lspsaga hover_doc ++quiet"
            -- Pressing the key twice will enter the hover window
            keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>")
            -- If you want to keep the hover window in the top right hand corner,
            -- you can pass the ++keep argument
            -- Note that if you use hover with ++keep, pressing this key again will
            -- close the hover window. If you want to jump to the hover window
            -- you should use the wincmd command "<C-w>w"
            -- keymap("n", "K", "<cmd>Lspsaga hover_doc ++keep<CR>")
            -- Call hierarchy
            keymap("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
            keymap("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>")
            -- Floating terminal
            keymap({"n", "t"}, "<A-d>", "<cmd>Lspsaga term_toggle<CR>")
        end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-tree/nvim-web-devicons',
    	},
    },
    {
      "ray-x/lsp_signature.nvim",
      event = "VeryLazy",
      opts = {},
      config = function(_, opts) require'lsp_signature'.setup(opts) end
    },

    'j-hui/fidget.nvim',
    {
        'RRethy/vim-illuminate',
        init = function()
            -- modify vim-illuminate highlights
            -- TODO(mike): I reverted to underline because it was hard to find a highlight color
            -- that did not conflict with visual highlights
            vim.cmd([[
                highlight! link  IlluminatedWordText CustomIlluminate
                highlight! link  IlluminatedWordRead CustomIlluminate
                highlight! link  IlluminatedWordWrite CustomIlluminate
                highlight! CustomIlluminate gui=underline cterm=underline
            ]])
        end,
    },
    'github/copilot.vim',

    -- Autoformat
    {
        'mhartington/formatter.nvim',
        config = function()
            require('formatter').setup({
              filetype = {
                python = {
                  function()
                    return {
                      exe = "black",
                      args = { '-' },
                      stdin = true,
                    }
                  end
                },
                go = {
                  function()
                    return {
                      exe = "goimports",
                      stdin = true
                    }
                  end
                },
              }
            })
            --  autoformat on write
            vim.api.nvim_exec([[
            augroup FormatAutogroup
              autocmd!
              autocmd BufWritePost *.go,*.py FormatWrite
            augroup END
            ]], true)
        end,
    },

    -- git
    'lewis6991/gitsigns.nvim',
    'tpope/vim-fugitive',
    'ruifm/gitlinker.nvim',

    -- themes
    'morhetz/gruvbox',
    'liuchengxu/space-vim-theme',
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

    -- beautify
    {
        'freddiehaddad/feline.nvim',
        opts = {}
    },
    {
        'echasnovski/mini.map',
        config = function()
            local map = require('mini.map')
            map.setup({
                integrations = {
                    map.gen_integration.builtin_search(),
                    map.gen_integration.diagnostic(),
                    map.gen_integration.gitsigns(),
                },
                symbols = {
                    encode = map.gen_encode_symbols.dot('4x2'),
                },
                window = {
                    show_integration_count = false,
                },
            })
            vim.keymap.set('n', '<Leader>mo', MiniMap.open)
            vim.keymap.set('n', '<Leader>mc', MiniMap.close)
            vim.keymap.set('n', '<Leader>mf', MiniMap.toggle_focus)
            vim.keymap.set('n', '<Leader>mr', MiniMap.refresh)
            vim.keymap.set('n', '<Leader>ms', MiniMap.toggle_side)
            vim.keymap.set('n', '<Leader>mt', MiniMap.toggle)
        end,
    },

    -- Typescript
    {
        'jose-elias-alvarez/typescript.nvim',
        dependencies = {
            'neovim/nvim-lspconfig',
            'ms-jpq/coq_nvim',
        },
        config = function()
            require('typescript').setup({
                server = require('coq').lsp_ensure_capabilities {}
            })
        end,
    },

    -- python tools
    'vim-python/python-syntax',
})

-- Set options
vim.opt.compatible = false
vim.opt.encoding = 'utf-8'
vim.opt.shortmess:append 'c'
vim.opt.showcmd = true
vim.opt.showmode = false
vim.opt.mouse = ''

vim.opt.completeopt:remove 'preview'
vim.opt.completeopt:append { 'noinsert', 'noselect' }

if vim.fn.has('termguicolors') == 1 then
    vim.opt.termguicolors = true
end

vim.opt.background = 'dark'
vim.cmd 'colorscheme catppuccin-mocha'

-- Always show status bar
vim.opt.laststatus = 2

vim.opt.number = true
vim.cmd 'syntax enable'
vim.cmd 'filetype plugin on'
vim.cmd 'filetype plugin indent on'

-- Indent and tab settings
vim.opt.wrap = false
vim.opt.expandtab = true
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'javascript',
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
    end,
})

-- Search settings
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Wildmenu config
vim.opt.wildmenu = true
vim.opt.wildmode = { 'longest:full', 'full' }

-- Better split navigation
vim.api.nvim_set_keymap('n', '<C-J>', '<C-W><C-J>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-K>', '<C-W><C-K>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-L>', '<C-W><C-L>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-H>', '<C-W><C-H>', { noremap = true })

vim.opt.splitbelow = true
vim.opt.splitright = true

-- Choose the fastest available searcher
if vim.fn.executable('rg') == 1 then
    vim.g.ctrlp_user_command = 'rg --files %s'
    vim.opt.grepprg = 'rg --no-heading --vimgrep --smart-case'
end

-- Go specific settings
vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
    pattern = '*.go',
    command = "set list noexpandtab syntax=go listchars=tab:\\|\\ ,trail:-",
})

-- YAML settings
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'yaml',
    command = 'setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab',
})

-- Typescript settings
vim.api.nvim_create_autocmd('FileType', {
    pattern = {'typescript', 'typescriptreact', 'typescript.tsx'},
    command = "setlocal ts=2 sts=2 sw=2 expandtab",
})

-- Javascript settings
vim.api.nvim_create_autocmd('FileType', {
    pattern = {'javascript', 'javascriptreact', 'javascript.jsx'},
    command = "setlocal ts=2 sts=2 sw=2 expandtab",
})

vim.g.python_highlight_all = 1

-- Telescope key mappings
vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gf', '<cmd>Telescope git_files<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { noremap = true })

if vim.fn.filereadable(vim.fn.expand('~/.vim/local.vim')) == 1 then
    vim.cmd 'source ~/.vim/local.vim'
end

