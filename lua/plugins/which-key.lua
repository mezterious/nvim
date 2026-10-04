-- Popup of available keybindings as you type. Labels come from each keymap's
-- `desc`; the spec only names groups.
vim.pack.add({
  'https://github.com/folke/which-key.nvim',
})

require('which-key').setup({
  spec = {
    { '<leader>f', group = 'find' },
    { '<leader>g', group = 'git' },
    { '<leader>l', group = 'language' },
    { '<leader>h', group = 'hunks' },
    { '<leader>t', group = 'toggle' },
  },
})

vim.keymap.set('n', '<leader>?', function()
  require('which-key').show({ global = false })
end, { desc = 'Buffer-local keymaps' })
