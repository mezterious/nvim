-- Entry point. Load order:
--   1. keymaps -- first, because it sets the leader keys, which must exist
--      before anything creates a <leader> mapping (it does, and so does every
--      plugin file).
--   2. options, autocmds -- independent of each other and of the leader.
--   3. plugins -- last: installed via vim.pack and configured after the core.
require('config.keymaps')
require('config.options')
require('config.autocmds')
require('plugins')
