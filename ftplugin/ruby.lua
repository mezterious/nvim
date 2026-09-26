-- See plugins/treesitter.lua.
pcall(vim.treesitter.start)

-- start() clears 'syntax', which Neovim's Ruby indent script reads; without it
-- Enter after `def`/`if`/`do` indents to column 0. Tree-sitter highlights still win.
vim.bo.syntax = 'ruby'
