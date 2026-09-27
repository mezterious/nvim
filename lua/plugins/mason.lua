-- Installs tools (language servers, formatters) via Mason, from the one table below.
--
-- To add a language server, add its nvim-lspconfig name to `tools.servers`: it is
-- then installed and enabled. Per-server overrides go in after/lsp/<name>.lua.
-- Servers not from Mason (e.g. rust_analyzer, from rustup) need an explicit
-- vim.lsp.enable() instead.
--
-- plugins/lsp.lua loads first: nvim-lspconfig must be on the runtimepath before
-- mason-lspconfig's setup().
vim.pack.add({
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
})

local tools = {
  servers = { 'lua_ls', 'vtsls', 'vue_ls', 'marksman' },
  formatters = { 'prettierd', 'prettier' }, -- used by plugins/formatting.lua
}

require('mason').setup()

-- Only servers are enabled. The default enables everything Mason has installed,
-- including tools that double as servers (stylua).
require('mason-lspconfig').setup({
  automatic_enable = tools.servers,
})

-- Every section of `tools` gets installed.
local ensure_installed = {}
for _, names in pairs(tools) do
  vim.list_extend(ensure_installed, names)
end
require('mason-tool-installer').setup({
  ensure_installed = ensure_installed,
})
