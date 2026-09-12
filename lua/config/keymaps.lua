-- Core keymaps only. Plugin-specific keymaps live next to that plugin's
-- config in lua/plugins/, so this file stays readable as "the base layer".
local map = vim.keymap.set

-- Clear search highlight without losing search history (Esc alone in normal
-- mode already does this in 0.12, but explicit is nice to have documented).
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

-- Window navigation without the <C-w> prefix.
map('n', '<C-h>', '<C-w>h', { desc = 'Go to left window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Go to right window' })

-- Move selected lines up/down in visual mode.
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- Keep cursor centred when jumping half-pages or between search results.
map('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down, keep cursor centred' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up, keep cursor centred' })
map('n', 'n', 'nzzzv', { desc = 'Next search match, keep cursor centred' })
map('n', 'N', 'Nzzzv', { desc = 'Previous search match, keep cursor centred' })

-- Keep the yanked text in the default register when pasting over a
-- visual selection (instead of it being replaced by the deleted text).
map('v', 'p', '"_dP', { desc = 'Paste without overwriting the unnamed register' })

-- Diagnostics (LSP attaches its own keymaps on `LspAttach`; these are
-- always available since diagnostics work without an active server too).
-- goto_prev()/goto_next() are deprecated in favor of the unified jump();
-- on_jump replicates their old "float the diagnostic at the new position"
-- default (opts.float does too, but that shortcut is itself deprecated).
local function float_on_jump(_, bufnr)
  vim.diagnostic.open_float({ bufnr = bufnr, scope = 'cursor', focus = false })
end
map('n', '[d', function()
  vim.diagnostic.jump({ count = -1, on_jump = float_on_jump })
end, { desc = 'Previous diagnostic' })
map('n', ']d', function()
  vim.diagnostic.jump({ count = 1, on_jump = float_on_jump })
end, { desc = 'Next diagnostic' })
map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic' })
