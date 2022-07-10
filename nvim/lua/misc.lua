require('gitsigns').setup()
require("trouble").setup {}
require("octo").setup()
require('leap').set_default_keymaps()

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
      "javascript",
      "json",
      "python",
      "toml",
      "typescript",
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

require("neotest").setup({
  adapters = {
    require("neotest-python"),
    require("neotest-go"),
  },
})

local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<leader>rr', '<cmd>lua require("neotest").run.run()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>rf', '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>rs', '<cmd>lua require("neotest").run.stop()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>ra', '<cmd>lua require("neotest").run.attach()<CR>', opts)
