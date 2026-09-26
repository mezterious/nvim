vim.pack.add({
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/neovim/nvim-lspconfig',
})

require('mason').setup()
local servers = {
  { name = 'lua_ls', mason = 'lua-language-server' },
}

-- Install everything listed above if not already installed
do
  local registry = require('mason-registry')
  registry.refresh(function()
    for _, server in ipairs(servers) do
      if server.mason then
        local ok, pkg = pcall(registry.get_package, server.mason)
        if ok and not pkg:is_installed() then
          pkg:install()
        end
      end
    end
  end)
end

-- Enable everything listed above. Per-server overrides go in after/lsp/<name>.lua.
for _, server in ipairs(servers) do
  vim.lsp.enable(server.name)
end
