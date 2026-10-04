-- Git interface (Magit-style). It finds codediff and fzf-lua on its own: codediff
-- as the diff viewer, fzf-lua for menus.
vim.pack.add({
  'https://github.com/NeogitOrg/neogit',
})

vim.keymap.set('n', '<leader>gg', '<Cmd>Neogit<CR>', { desc = 'Neogit' })
