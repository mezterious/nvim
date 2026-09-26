-- Each autocmd has its own augroup so re-sourcing this file doesn't stack duplicates.
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd('TextYankPost', {
  group = augroup('highlight-yank', { clear = true }),
  desc = 'Briefly highlight yanked text',
  callback = function()
    vim.hl.on_yank()
  end,
})

autocmd('VimResized', {
  group = augroup('resize-splits', { clear = true }),
  desc = 'Equalize window sizes when the terminal is resized',
  command = 'tabdo wincmd =',
})

autocmd('FileType', {
  group = augroup('close-with-q', { clear = true }),
  desc = 'Close throwaway filetypes with q',
  pattern = { 'help', 'qf', 'lspinfo', 'checkhealth', 'man' },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = event.buf, silent = true })
  end,
})
