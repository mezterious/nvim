-- Each plugin gets its own file in this directory: the vim.pack.add() call
-- for it and its setup()/config live together, so adding or removing a
-- plugin is "add/remove one file, add/remove one require() line below".
-- Order can matter (e.g. colorscheme before things that read its highlights),
-- so this list is explicit rather than auto-globbed.

require('plugins.colorscheme')
require('plugins.treesitter')
require('plugins.lsp')
require('plugins.formatting')
require('plugins.completion')
require('plugins.telescope')
require('plugins.gitsigns')
require('plugins.statusline')
require('plugins.explorer')
require('plugins.which-key')
require('plugins.dap')
