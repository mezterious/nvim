-- Installs tools (language servers so far) via Mason, from one list.
--
-- To add a language server, add its nvim-lspconfig name to BOTH `automatic_enable`
-- and `ensure_installed`. Forget one and it silently won't start / won't install.
-- Per-server overrides go in after/lsp/<name>.lua. Servers not from Mason (e.g.
-- rust_analyzer, from rustup) need an explicit vim.lsp.enable() instead.
--
-- plugins/lsp.lua loads first: nvim-lspconfig must be on the runtimepath before
-- mason-lspconfig's setup().
vim.pack.add({
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
})

require('mason').setup()

-- Enables only the servers listed. The default enables everything Mason has
-- installed, including tools that double as servers (stylua).
require('mason-lspconfig').setup({
  automatic_enable = { 'lua_ls' },
})

require('mason-tool-installer').setup({
  ensure_installed = {
    'lua_ls', -- nvim-lspconfig names for servers; also add to automatic_enable
  },
})
