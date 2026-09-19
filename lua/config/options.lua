-- Core editor options. Grouped by concern; each group is small enough to
-- scan, and this is the file to skim when you forget "why did I set that".
local opt = vim.opt

-- Remote-plugin providers. Nothing in this config uses them, so turn them
-- off rather than have `:checkhealth` warn about hosts we don't need.
-- (Re-enable one by deleting it here if a plugin ever asks for it.)
for _, provider in ipairs({ 'python3', 'ruby', 'perl', 'node' }) do
  vim.g['loaded_' .. provider .. '_provider'] = 0
end

-- UI
opt.number = true
opt.relativenumber = true
opt.signcolumn = 'yes' -- always reserve a column so LSP diagnostics don't cause text to shift
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

-- Indentation (2 spaces; change per filetype later via ftplugin if needed)
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

-- Files & undo
opt.swapfile = false
opt.backup = false
opt.undofile = true -- persistent undo across sessions
opt.updatetime = 250 -- faster CursorHold events, e.g. for diagnostics/hover

-- Behaviour
opt.mouse = 'a'
opt.clipboard = 'unnamedplus' -- use the system clipboard for all yank/delete/paste
opt.completeopt = { 'menuone', 'noselect', 'popup' }
opt.confirm = true -- ask to save instead of failing a command outright
opt.inccommand = 'split' -- live preview for :s substitutions
