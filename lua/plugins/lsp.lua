-- nvim-lspconfig supplies default lsp/<name>.lua server configs (data only);
-- override per server in after/lsp/<name>.lua. Installing and enabling servers
-- is in plugins/mason.lua.
vim.pack.add({
  'https://github.com/neovim/nvim-lspconfig',
})

-- LSP keymaps that aren't fuzzy-finder pickers (those are in plugins/fzf-lua.lua).
-- grn and gra are Neovim's own defaults, mapped here to give them a description.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local function map(lhs, rhs, desc, mode)
      vim.keymap.set(mode or 'n', lhs, rhs, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method('textDocument/inlayHint', event.buf) then
      map('<leader>th', function()
        local filter = { bufnr = event.buf }
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(filter), filter)
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})
