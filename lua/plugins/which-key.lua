-- Shows available keymaps in a popup after a prefix key (<leader>, g, z, ...)
-- and a short pause -- this is what was missing when pressing <leader> alone
-- showed nothing. It picks up every keymap's `desc` automatically; only the
-- *group* names for multi-key prefixes need registering by hand below.
vim.pack.add({
  'https://github.com/folke/which-key.nvim',
})

require('which-key').setup({})

require('which-key').add({
  { '<leader>f', group = 'Find' },
  { '<leader>h', group = 'Git Hunk' },
  { '<leader>l', group = 'LSP' },
})
