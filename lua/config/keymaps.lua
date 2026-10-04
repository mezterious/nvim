-- Core keymaps. Plugin keymaps live in that plugin's file.

-- The leader must be set before any <leader> mapping is defined; init.lua loads this first.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local map = vim.keymap.set

map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

map('n', '<C-h>', '<C-w>h', { desc = 'Go to left window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Go to right window' })

map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

map('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down, keep cursor centred' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up, keep cursor centred' })
map('n', 'n', 'nzzzv', { desc = 'Next search match, keep cursor centred' })
map('n', 'N', 'Nzzzv', { desc = 'Previous search match, keep cursor centred' })

map('v', 'p', '"_dP', { desc = 'Paste without overwriting the unnamed register' })

-- Diagnostics: jumping uses the built-in `]d` / `[d`.
map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic' })
