-- ruby-lsp, Shopify's official language server -- current best practice
-- over the older `solargraph` (still maintained, but ruby-lsp is the one
-- the Ruby core/Rails ecosystem has standardized on). Mason-installed here
-- for a working global default; a project that wants bundler-aware gem
-- resolution can add `ruby-lsp` to its own Gemfile instead, and this same
-- config keeps working either way -- it just spawns whatever `ruby-lsp`
-- resolves to.
--
-- Adapted from nvim-lspconfig's lsp/ruby_lsp.lua (MIT).
return {
  cmd = function(dispatchers, config)
    return vim.lsp.rpc.start({ 'ruby-lsp' }, dispatchers, config and config.root_dir and { cwd = config.root_dir })
  end,
  filetypes = { 'ruby', 'eruby' },
  root_markers = { 'Gemfile', '.git' },
  init_options = {
    formatter = 'auto',
  },
}
