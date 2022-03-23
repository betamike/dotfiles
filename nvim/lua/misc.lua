require("trouble").setup {}
require("octo").setup()

require('formatter').setup({
  filetype = {
    python = {
      -- Configuration for psf/black
      function()
        return {
          exe = "black", -- this should be available on your $PATH
          args = { '-' },
          stdin = true,
        }
      end
    },
    go = {
      function()
        return {
          exe = "gofmt",
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
