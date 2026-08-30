-- Entry point. Order matters here:
--   1. Leader keys, because keymaps and plugin configs reference `<leader>`
--      and must be set before anything else uses them.
--   2. Core config (options/keymaps/autocmds) — no plugin dependencies.
--   3. Plugins — installed via vim.pack and configured last.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('config.options')
require('config.keymaps')
require('config.autocmds')
require('plugins')
