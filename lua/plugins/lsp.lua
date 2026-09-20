-- Language server support: diagnostics, go-to-definition, hover, rename,
-- code actions, completion source data, etc.
--
-- Almost all of this is native Neovim (0.11+) now:
--   - vim.lsp.config() / vim.lsp.enable() replace nvim-lspconfig's job of
--     wiring a server up. A config can be defined in code, but the idiomatic
--     place is a `lsp/<name>.lua` file at the *config root* (a runtime-path
--     convention, like ftplugin/ -- NOT under lua/). See lsp/lua_ls.lua.
--   - Neovim already creates sensible global keymaps the moment any LSP
--     client attaches: gra (code action), grn (rename), grr (references),
--     gri (implementation), grt (type definition), gO (document symbols),
--     K (hover), <C-s> in insert (signature help). Don't redefine these.
--   - `gd` (go-to-definition) is the one common one Neovim deliberately
--     leaves unmapped, because `gd` already has a plain-Vim meaning
--     (local declaration search). We map it below, LSP-attached buffers
--     only.
--
-- The one non-native piece: Neovim doesn't install LSP server *binaries*.
-- mason.nvim handles that -- it's a plugin, but its job stops at "put the
-- binary on $PATH"; it doesn't touch how the client is configured.
vim.pack.add({
  'https://github.com/mason-org/mason.nvim',
})

require('mason').setup()

-- Servers to make available. `name` is the config name used by
-- vim.lsp.enable() (and the matching lsp/<name>.lua file); `mason` is the
-- package name in Mason's registry, which is often spelled differently.
-- `mason` is left nil for servers better installed by their own language
-- toolchain instead (see rust_analyzer below) -- those are just skipped
-- by the install loop, not mason-managed at all.
-- To add a language: add an entry here, add a matching lsp/<name>.lua.
local servers = {
  { name = 'lua_ls', mason = 'lua-language-server' },
  -- TypeScript/JavaScript/Vue: vtsls does the TS side (incl. inside .vue
  -- <script> blocks); vue_ls does the Vue template/style side and forwards
  -- TS requests to vtsls. See lsp/vtsls.lua and lsp/vue_ls.lua.
  { name = 'vtsls', mason = 'vtsls' },
  { name = 'vue_ls', mason = 'vue-language-server' },
  -- Not mason-managed: rustup already provides rust-analyzer, matched to
  -- the active toolchain version. See lsp/rust_analyzer.lua.
  { name = 'rust_analyzer' },
  { name = 'gopls', mason = 'gopls' },
  { name = 'ruby_lsp', mason = 'ruby-lsp' },
}

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

vim.lsp.enable(vim.tbl_map(function(server)
  return server.name
end, servers))

-- Diagnostics are on by default; this just tunes presentation.
vim.diagnostic.config({
  severity_sort = true,
  float = { border = 'rounded', source = true },
  virtual_text = { spacing = 2, prefix = '●' },
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc })
    end

    map('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
    map('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration')
    -- Formatting (<leader>lf) lives in plugins/formatting.lua: conform.nvim
    -- calls the LSP formatter itself when a filetype has no dedicated one.

    if client and client:supports_method('textDocument/inlayHint') then
      vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
      map('n', '<leader>th', function()
        local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
        vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
      end, 'Toggle inlay hints')
    end
  end,
})
