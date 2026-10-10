-- Project-wide search and replace in an editable buffer, on ripgrep. It needs no setup;
-- its buffer-local keys use <localleader> (set in config/keymaps.lua).
vim.pack.add({
  'https://github.com/MagicDuck/grug-far.nvim',
})

-- From visual mode the selection becomes the search text.
vim.keymap.set({ 'n', 'x' }, '<leader>fr', ':GrugFar<CR>', { desc = 'Find and replace' })
