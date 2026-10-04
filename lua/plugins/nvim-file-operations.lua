-- Tells language servers about renames, moves and deletes done in neo-tree, so e.g.
-- vtsls can update imports. Neo-tree's setup() must have run first, so this file is
-- required after neo-tree.lua.
vim.pack.add({
  'https://github.com/Crysthamus/nvim-file-operations',
})

require('nvim-file-operations').setup({
  auto_save = true, -- save the files the server edits (e.g. updated imports)
})
