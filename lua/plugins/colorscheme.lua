-- Loaded first (see plugins/init.lua) so anything set up after this can
-- read its highlight groups rather than racing it.
vim.pack.add({
  'https://github.com/folke/tokyonight.nvim',
})

-- 'moon' matches the terminal theme already in use (fish_config theme /
-- WezTerm), so the editor doesn't look like a different app.
require('tokyonight').setup({
  style = 'moon',
})

vim.cmd.colorscheme('tokyonight')
