-- Auto-closes brackets and quotes; also maps <CR> (expand between a pair) and <BS>
-- (delete both halves of a pair) in insert mode. Defaults.
vim.pack.add({
  'https://github.com/windwp/nvim-autopairs',
})

require('nvim-autopairs').setup({})
