-- Statusline. Defaults already cover the useful stuff (mode, git branch +
-- diff counts via gitsigns, diagnostics, filename, position) with no extra
-- wiring -- only the theme needs setting, to match the colorscheme exactly
-- rather than relying on lualine's 'auto' detection.
vim.pack.add({
  'https://github.com/nvim-lualine/lualine.nvim',
})

require('lualine').setup({
  options = {
    theme = 'tokyonight-moon',
  },
})
