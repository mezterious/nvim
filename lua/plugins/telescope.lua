-- Fuzzy finder: files, live grep, buffers, help, and (no native equivalent
-- for this one) a fuzzy-searchable diagnostics list across the whole
-- workspace, not just the current buffer.

-- telescope-fzf-native ships no prebuilt binary, and vim.pack has no
-- build-hook equivalent to lazy.nvim's `build = ...` -- so build it
-- ourselves, via the exact pattern :h vim.pack-events documents for this.
-- Registered before vim.pack.add() below: the event can fire as part of
-- that very call, for a plugin not yet on disk.
vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('telescope-fzf-native-build', { clear = true }),
  callback = function(event)
    local data = event.data
    if data.spec.name == 'telescope-fzf-native.nvim' and (data.kind == 'install' or data.kind == 'update') then
      vim.system({ 'make' }, { cwd = data.path })
    end
  end,
})

vim.pack.add({
  'https://github.com/nvim-lua/plenary.nvim', -- required dependency
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
})

require('telescope').setup({
  extensions = { fzf = {} },
})

-- Only takes effect once the Makefile above has actually finished; on a
-- brand new install that's still building in the background, same
-- restart-to-fully-work story as treesitter parsers and LSP servers.
pcall(require('telescope').load_extension, 'fzf')

local builtin = require('telescope.builtin')
local map = vim.keymap.set
map('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
map('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
map('n', '<leader>fb', builtin.buffers, { desc = 'Find open buffers' })
map('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
map('n', '<leader>fd', builtin.diagnostics, { desc = 'Diagnostics (workspace)' })
map('n', '<leader>fr', builtin.oldfiles, { desc = 'Recent files' })
