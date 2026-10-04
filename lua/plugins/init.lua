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
require('plugins.explorer')
require('plugins.telescope')
require('plugins.which-key')
