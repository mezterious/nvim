-- Formatting: conform.nvim picks the formatter per filetype, applies the result
-- as a minimal diff (cursor, marks and folds survive), and can fall back to the
-- LSP formatter -- so Go/Rust/Ruby keep formatting through their servers.
--
-- .editorconfig needs nothing here: Neovim applies it itself (indent, line
-- endings, trailing whitespace, final newline), and prettier reads it on its
-- own, so the two agree about tabs vs spaces and widths.
-- '^9.0.0' = any 9.x release. (A bare '9.0' looks similar but means 9.0.x only.)
vim.pack.add({
  { src = 'https://github.com/stevearc/conform.nvim', version = vim.version.range('^9.0.0') },
})

local conform = require('conform')

local formatters_by_ft = { lua = { 'stylua' } }
for _, ft in ipairs({
  'typescript',
  'typescriptreact',
  'javascript',
  'javascriptreact',
  'vue',
  'json',
  'jsonc',
  'css',
  'html',
  'yaml',
  'markdown',
}) do
  formatters_by_ft[ft] = { 'prettier' }
end

conform.setup({
  formatters_by_ft = formatters_by_ft,
  -- Filetypes with no formatter above (Go, Rust, Ruby, ...) use their LSP's.
  default_format_opts = { lsp_format = 'fallback' },
  -- Format on save only where the project has opted in. A formatter reports a
  -- `cwd` only if it found its project config (.prettierrc*, prettier.config.*,
  -- a "prettier" key in package.json, or .stylua.toml). Without one, prettier
  -- would apply its own defaults and could rewrite a repo that isn't styled
  -- that way -- so unconfigured projects, and LSP-only filetypes, stay manual.
  format_on_save = function(bufnr)
    local formatters = conform.list_formatters_to_run(bufnr)
    if #formatters == 0 then
      return
    end
    for _, formatter in ipairs(formatters) do
      if not formatter.cwd then
        return
      end
    end
    return { timeout_ms = 1000 }
  end,
})

-- Manual format works everywhere (with prettier's defaults if the project has no
-- config). In visual mode conform formats just the selection.
vim.keymap.set({ 'n', 'x' }, '<leader>lf', function()
  conform.format({ async = true })
end, { desc = 'Format buffer / selection' })
