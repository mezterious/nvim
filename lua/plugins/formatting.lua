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
  },
  format_on_save = { timeout_ms = 500 },
})

vim.keymap.set({ 'n', 'x' }, '<leader>lf', function()
  require('conform').format({ async = true })
end, { desc = 'Format buffer' })
