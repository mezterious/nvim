-- Fuzzy finder, plus telescope pickers for the LSP results. telescope-ui-select
-- routes vim.ui.select (code actions etc.) through telescope as a dropdown.
-- Pinned to the latest release tag, as the telescope README recommends.
vim.pack.add({
  'https://github.com/nvim-lua/plenary.nvim',
  { src = 'https://github.com/nvim-telescope/telescope.nvim', version = vim.version.range('*') },
  'https://github.com/nvim-telescope/telescope-ui-select.nvim',
})

local telescope = require('telescope')
local builtin = require('telescope.builtin')

telescope.setup({
  extensions = {
    ['ui-select'] = { require('telescope.themes').get_dropdown() },
  },
})
telescope.load_extension('ui-select')

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })

-- Override Neovim's built-in LSP maps (which fill the quickfix list) in LSP
-- buffers; `gd` and `grd` are both go-to-definition.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
  callback = function(event)
    local function map(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = event.buf, desc = desc })
    end

    map('gd', builtin.lsp_definitions, '[G]oto [D]efinition')
    map('grd', builtin.lsp_definitions, '[G]oto [D]efinition')
    map('grr', builtin.lsp_references, '[G]oto [R]eferences')
    map('gri', builtin.lsp_implementations, '[G]oto [I]mplementation')
    map('grt', builtin.lsp_type_definitions, '[G]oto [T]ype Definition')
    map('gO', builtin.lsp_document_symbols, 'Open Document Symbols')
    map('gW', builtin.lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
  end,
})
