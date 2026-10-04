-- File explorer. Netrw is disabled up front: neo-tree clears netrw's autocmds when
-- setup() runs, but that's before netrw loads, so without this netrw flashes up
-- first when opening a directory.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.pack.add({
  -- Pinned to v3, as the neo-tree README recommends for vim.pack.
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range('3') },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
  -- File icons; neo-tree, lualine and fzf-lua use them if present.
  'https://github.com/nvim-tree/nvim-web-devicons',
})

-- The default hides every dotfile; show them, but keep .git hidden.
require('neo-tree').setup({
  filesystem = {
    filtered_items = { hide_dotfiles = false, never_show = { '.git' } },
  },
})

-- Opens on the current file; closes the tree if it's already open.
vim.keymap.set('n', '\\', '<Cmd>Neotree toggle reveal<CR>', { desc = 'Toggle file explorer', silent = true })
