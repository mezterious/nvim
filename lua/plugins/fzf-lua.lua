-- Fuzzy finder (fzf-lua), plus pickers for the LSP results. The 'telescope' profile
-- approximates telescope's look and keys; drop it for fzf-lua's defaults.
-- register_ui_select routes vim.ui.select (code actions etc.) through it.
vim.pack.add({
  'https://github.com/ibhagwan/fzf-lua',
})

local fzf = require('fzf-lua')

fzf.setup({ 'telescope' })
fzf.register_ui_select()

vim.keymap.set('n', '<leader>ff', fzf.files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', fzf.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', fzf.buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fh', fzf.helptags, { desc = 'Help tags' })
vim.keymap.set('n', '<leader>fd', fzf.diagnostics_document, { desc = 'Diagnostics (file)' })
-- Only what the servers have reported: for TypeScript, the files opened this session.
vim.keymap.set('n', '<leader>fD', fzf.diagnostics_workspace, { desc = 'Diagnostics (opened files)' })

-- Override Neovim's built-in LSP maps (which fill the quickfix list) in LSP
-- buffers; `gd` and `grd` are both go-to-definition.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('fzf-lua-lsp-attach', { clear = true }),
  callback = function(event)
    local function map(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = event.buf, desc = desc })
    end

    map('gd', fzf.lsp_definitions, '[G]oto [D]efinition')
    map('grd', fzf.lsp_definitions, '[G]oto [D]efinition')
    map('grr', fzf.lsp_references, '[G]oto [R]eferences')
    map('gri', fzf.lsp_implementations, '[G]oto [I]mplementation')
    map('grt', fzf.lsp_typedefs, '[G]oto [T]ype Definition')
    map('gO', fzf.lsp_document_symbols, 'Open Document Symbols')
    map('gW', fzf.lsp_live_workspace_symbols, 'Open Workspace Symbols')
  end,
})
