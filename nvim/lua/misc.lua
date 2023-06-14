require('gitsigns').setup()
require('feline').setup()
require("trouble").setup()
require('leap').set_default_keymaps()
require("gitlinker").setup()

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

require('neogit').setup({
  integrations = {
    diffview = true,
  }
})

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

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = {
      "bash",
      "comment",
      "dockerfile",
      "go",
      "lua",
      "javascript",
      "json",
      "proto",
      "python",
      "markdown",
      "markdown_inline",
      "terraform",
      "toml",
      "typescript",
      "vim",
      "yaml",
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

-- modify vim-illuminate highlights
-- TODO(mike): I reverted to underline because it was hard to find a highlight color
-- that did not conflict with visual highlights
vim.cmd([[
    highlight! link  IlluminatedWordText CustomIlluminate
    highlight! link  IlluminatedWordRead CustomIlluminate
    highlight! link  IlluminatedWordWrite CustomIlluminate
    highlight! CustomIlluminate gui=underline cterm=underline
]])
