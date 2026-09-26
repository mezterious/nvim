-- Statusline. The defaults are enough; only the theme is set, to match the colorscheme.
vim.pack.add({
  'https://github.com/nvim-lualine/lualine.nvim',
})

require('lualine').setup({
  options = {
    theme = 'tokyonight-moon',
  },
})
