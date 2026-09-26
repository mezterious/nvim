-- Loaded first so later plugins can read its highlight groups.
vim.pack.add({
  'https://github.com/folke/tokyonight.nvim',
})

-- 'moon' matches the terminal theme.
require('tokyonight').setup({
  style = 'moon',
})

vim.cmd.colorscheme('tokyonight')
