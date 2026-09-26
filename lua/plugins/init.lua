-- One file per plugin (vim.pack.add + config together), required in an explicit
-- order: the colorscheme first, lsp before mason.

require('plugins.colorscheme')
require('plugins.treesitter')
require('plugins.lsp')
require('plugins.mason')
require('plugins.statusline')
require('plugins.explorer')
