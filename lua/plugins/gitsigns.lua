-- Git change markers in the sign column, plus hunk navigation/stage/preview.
-- Defaults are already sensible; only on_attach (buffer-local keymaps) is
-- worth setting explicitly.
vim.pack.add({
  'https://github.com/lewis6991/gitsigns.nvim',
})

require('gitsigns').setup({
  on_attach = function(bufnr)
    local gitsigns = require('gitsigns')
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal({ ']c', bang = true })
      else
        gitsigns.nav_hunk('next')
      end
    end, 'Next git hunk')

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal({ '[c', bang = true })
      else
        gitsigns.nav_hunk('prev')
      end
    end, 'Previous git hunk')

    map('n', '<leader>hs', gitsigns.stage_hunk, 'Stage hunk')
    map('n', '<leader>hr', gitsigns.reset_hunk, 'Reset hunk')
    map('v', '<leader>hs', function()
      gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, 'Stage hunk')
    map('v', '<leader>hr', function()
      gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, 'Reset hunk')

    map('n', '<leader>hp', gitsigns.preview_hunk, 'Preview hunk')
    map('n', '<leader>hb', function()
      gitsigns.blame_line({ full = true })
    end, 'Blame line')

    map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, 'Git hunk text object')
  end,
})
