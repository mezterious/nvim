-- Lint only in projects that have an oxlint config. The default config starts without
-- one too, using oxlint's default rules.
---@type vim.lsp.Config
return {
  workspace_required = true,
}
