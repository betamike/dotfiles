local lsp = require "lspconfig"
local coq = require "coq"

local servers = { 'pylsp' }
for _, server in pairs(servers) do
  lsp[server].setup(
    coq.lsp_ensure_capabilities {
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    }
  })
end
