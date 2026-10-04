-- One file per plugin (vim.pack.add + config together), required in an explicit
-- order: the colorscheme first, lsp before mason.

require('plugins.colorscheme')
require('plugins.treesitter')
require('plugins.lsp')
require('plugins.mason')
require('plugins.completion')
require('plugins.formatting')
require('plugins.gitsigns')
require('plugins.statusline')
require('plugins.neo-tree')
require('plugins.nvim-file-operations')
require('plugins.neogit')
require('plugins.codediff')
require('plugins.dap')
require('plugins.fzf-lua')
require('plugins.which-key')
