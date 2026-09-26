-- Load order: keymaps first (they set the leader before anything maps <leader>),
-- plugins last.
require('config.keymaps')
require('config.options')
require('config.autocmds')
require('plugins')
