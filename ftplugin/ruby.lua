-- See plugins/treesitter.lua.
pcall(vim.treesitter.start)
vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.wo[0][0].foldmethod = 'expr'

-- start() clears 'syntax', which Neovim's Ruby indent script reads; without it
-- Enter after `def`/`if`/`do` indents to column 0. Tree-sitter highlights still win.
vim.bo.syntax = 'ruby'
