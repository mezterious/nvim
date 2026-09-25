-- Tree-sitter highlighting; see the note in lua/plugins/treesitter.lua.
pcall(vim.treesitter.start)

-- start() clears 'syntax', and Neovim's Ruby indent script reads syntax groups to
-- decide indentation (Enter after `def`/`if`/`do` gave column 0). Restoring it
-- costs nothing visible: tree-sitter highlights win over regex.
vim.bo.syntax = 'ruby'
