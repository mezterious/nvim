-- Core editor options, grouped by concern.
local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.signcolumn = 'yes' -- reserve the column so diagnostics don't shift text
opt.cursorline = true
opt.termguicolors = true
opt.scrolloff = 8 -- keep context above/below the cursor
opt.splitright = true
opt.splitbelow = true
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Search
opt.ignorecase = true
opt.smartcase = true -- ignorecase, unless the search has a capital letter

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

-- Files & undo
opt.swapfile = false
opt.backup = false
opt.undofile = true -- persistent undo across sessions
opt.updatetime = 250 -- faster CursorHold events

-- Behaviour
opt.mouse = 'a'
opt.clipboard = 'unnamedplus' -- use the system clipboard
opt.completeopt = { 'menuone', 'noselect', 'popup' }
opt.confirm = true -- ask to save instead of failing a command outright
opt.inccommand = 'split' -- live preview for :s substitutions
