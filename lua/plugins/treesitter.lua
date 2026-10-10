-- Parser-based syntax highlighting and folding. nvim-treesitter (main branch) only
-- installs and updates parsers; both are switched on per filetype in ftplugin/.

-- Refresh parsers when the plugin updates (the vim.pack equivalent of
-- `build = ':TSUpdate'`). Errors are reported: upstream's update() throws for every
-- language if one parser lacks its `.revision` file. Registered before
-- vim.pack.add(), as the vim.pack docs advise for hooks.
vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('treesitter-parsers-follow-plugin', { clear = true }),
  callback = function(event)
    local data = event.data
    if data.spec.name ~= 'nvim-treesitter' or data.kind ~= 'update' then
      return
    end

    require('nvim-treesitter').update():await(function(err)
      if err then
        vim.schedule(function()
          vim.notify('nvim-treesitter: refreshing parsers failed:\n' .. tostring(err), vim.log.levels.ERROR)
        end)
      end
    end)
  end,
})

vim.pack.add({
  'https://github.com/nvim-treesitter/nvim-treesitter',
})

-- Parsers to install; anything already present is skipped.
require('nvim-treesitter').install({
  'bash',
  'c',
  'css',
  'diff',
  'go',
  'gomod',
  'gowork',
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

-- Highlighting and folding are set per filetype in ftplugin/<filetype>.lua, as the
-- nvim-treesitter README advises. To add a language, add its parser above and an ftplugin
-- file (Neovim starts lua, markdown and help highlighting itself). A language server that
-- provides fold ranges takes over folding (see config/autocmds.lua).
--
-- Tree-sitter indent is deliberately off: unfinished code has syntax errors, so it
-- falls back to column 0 where Neovim's own indent scripts do better.
