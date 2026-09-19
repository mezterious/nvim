-- Parser-based syntax highlighting and indentation.
--
-- nvim-treesitter (main branch) is a thin manager around Neovim's built-in
-- treesitter: it installs/updates parsers, and the *editor* enables
-- highlighting/indent itself via vim.treesitter.start(). There's no
-- setup({ highlight = { enable = true } }) anymore -- that was the old
-- (pre-rewrite) API.
vim.pack.add({
  'https://github.com/nvim-treesitter/nvim-treesitter',
})

-- Parsers to have on disk. Neovim's own build already bundles a few
-- (c, lua, markdown, query, vim, vimdoc) but installing them here too is
-- harmless -- install() skips anything already present.
require('nvim-treesitter').install({
  'bash',
  'c',
  'diff',
  'go',
  'html',
  'javascript',
  'json',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'python',
  'query',
  'ruby',
  'rust',
  'toml',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'vue',
  'yaml',
})

-- Start highlighting (and, experimentally, indent) for any filetype that
-- has a parser available. Filetypes with no parser just silently no-op.
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter-start', { clear = true }),
  callback = function()
    local ok = pcall(vim.treesitter.start)
    if ok then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- Note: vim.pack.update() updates the *plugin's code*. It does not touch
-- installed parser binaries -- run :TSUpdate (or
-- require('nvim-treesitter').update()) separately when parsers need it.

-- Nag reminder for the above, throttled to once a week. This does NOT hook
-- the plugin's `User TSUpdate` event to detect a real update: that event
-- fires from install()'s no-op path too (i.e. on every single startup),
-- so it can't distinguish "parsers refreshed" from "already had them" --
-- unsuitable as a "last actually updated" signal. Plain elapsed-time
-- throttling is simpler and doesn't depend on that internal behaviour.
vim.api.nvim_create_autocmd('VimEnter', {
  group = vim.api.nvim_create_augroup('treesitter-update-reminder', { clear = true }),
  callback = function()
    local stamp_file = vim.fn.stdpath('state') .. '/treesitter-update-reminder'
    local week_in_seconds = 7 * 24 * 60 * 60
    local last_notified = vim.fn.filereadable(stamp_file) == 1 and tonumber(vim.fn.readfile(stamp_file)[1]) or 0

    if os.time() - last_notified < week_in_seconds then
      return
    end

    vim.fn.writefile({ tostring(os.time()) }, stamp_file)
    vim.notify("It's been a while -- consider running :TSUpdate to refresh treesitter parsers.", vim.log.levels.INFO)
  end,
})
