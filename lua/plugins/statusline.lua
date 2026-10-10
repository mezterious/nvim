-- Statusline. The defaults are enough, except the theme (to match the colorscheme)
-- and the file component, which shows the path relative to the working directory.
vim.pack.add({
  'https://github.com/nvim-lualine/lualine.nvim',
})

require('lualine').setup({
  options = {
    theme = 'tokyonight-moon',
  },
  sections = {
    lualine_c = { { 'filename', path = 1 } },
  },
})
