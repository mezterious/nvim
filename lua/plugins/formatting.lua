-- Formatting via conform.nvim, which runs external formatters (installed in
-- plugins/mason.lua). Only filetypes listed below are formatted.
vim.pack.add({
  'https://github.com/stevearc/conform.nvim',
})

-- prettierd (daemon, fast) if available, otherwise prettier.
local prettier = { 'prettierd', 'prettier', stop_after_first = true }

require('conform').setup({
  formatters_by_ft = {
    typescript = prettier,
    typescriptreact = prettier,
    vue = prettier,
    json = prettier,
    jsonc = prettier,
    markdown = prettier,
  },
  -- Only format when the project has a prettier config (.prettierrc*,
  -- prettier.config.*, or a "prettier" key in package.json); .editorconfig alone
  -- doesn't count. Prettier still honours .editorconfig once it does run.
  formatters = {
    prettierd = { require_cwd = true },
    prettier = { require_cwd = true },
  },
  format_on_save = { timeout_ms = 500 },
})

vim.keymap.set({ 'n', 'x' }, '<leader>lf', function()
  require('conform').format({ async = true })
end, { desc = 'Format buffer' })
