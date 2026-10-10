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

autocmd('CursorHold', {
  group = augroup('diagnostic-float', { clear = true }),
  desc = 'Show the cursor line diagnostics in a float',
  callback = function(event)
    -- Hover and diagnostics share one float per buffer; don't replace a hover that's open.
    local preview = vim.b[event.buf].lsp_floating_preview
    if preview and vim.api.nvim_win_is_valid(preview) then
      return
    end
    vim.diagnostic.open_float({ bufnr = event.buf, scope = 'line', focus = false })
  end,
})

autocmd('LspAttach', {
  group = augroup('lsp-folding', { clear = true }),
  desc = "Fold with the server's ranges when it provides them (else tree-sitter, see options.lua)",
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method('textDocument/foldingRange') then
      vim.wo[vim.api.nvim_get_current_win()][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end
  end,
})
