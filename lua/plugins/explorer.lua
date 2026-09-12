-- File explorer (nvim-tree). Netrw, Neovim's built-in one, must be disabled
-- before anything could trigger it -- hence this runs ahead of the usual
-- vim.pack.add()-then-setup() shape used elsewhere.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.pack.add({
  -- File-type icons. Also auto-detected and used by telescope and lualine
  -- once present, not just nvim-tree -- that's why it's here rather than
  -- being nvim-tree-specific.
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/nvim-tree/nvim-tree.lua',
})

require('nvim-tree').setup({
  diagnostics = {
    enable = true, -- show LSP diagnostic indicators in the tree; off by default upstream
  },
})

vim.keymap.set('n', '<C-n>', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })
