-- Core editor options, grouped by concern.
local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.signcolumn = 'yes' -- reserve the column so diagnostics don't shift text
opt.cursorline = true
opt.showmode = false -- the statusline already shows the mode
opt.scrolloff = 8
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
opt.breakindent = true -- wrapped lines keep the line's indent

-- Folding is switched on per filetype (ftplugin/); this only sets the starting level.
opt.foldlevelstart = 99 -- open files fully unfolded

-- Files & undo
opt.swapfile = false
opt.undofile = true
opt.updatetime = 250 -- faster CursorHold events

-- Behaviour
opt.mouse = 'a'
opt.clipboard = 'unnamedplus'
opt.completeopt = { 'menuone', 'noselect', 'popup' }
opt.confirm = true -- ask to save instead of failing a command outright
opt.inccommand = 'split' -- live preview for :s substitutions

-- Diagnostics: a gutter sign and underline (the defaults), and the full message in a float
-- (see autocmds.lua), never as text at the end of the line. `]d` / `[d` jump between
-- diagnostics and `<C-w>d` opens the float on demand.
vim.diagnostic.config({
  virtual_text = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
})
