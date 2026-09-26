-- File explorer. Netrw, the built-in one, is disabled first so it can't take over directories.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.pack.add({
  -- File icons; nvim-tree and lualine use them if present.
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/nvim-tree/nvim-tree.lua',
})

require('nvim-tree').setup({
  diagnostics = {
    enable = true, -- diagnostic indicators in the tree; off by default
  },
})

vim.keymap.set('n', '<C-n>', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })
