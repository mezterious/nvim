-- Parser-based syntax highlighting. nvim-treesitter (main branch) only installs and
-- updates parsers; highlighting is started per filetype in ftplugin/.

-- Parsers are pinned by the plugin, so refresh them when the plugin updates (the
-- vim.pack equivalent of `build = ':TSUpdate'`). Errors are reported because
-- upstream's update() throws for every language if one parser lacks its
-- `.revision` file (left by an interrupted install). Registered before
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

-- Highlighting starts per filetype in ftplugin/<filetype>.lua (a no-op until the
-- parser is installed). To add a language: add its parser above and an ftplugin
-- file. Neovim starts it itself for lua, markdown and help.
--
-- Tree-sitter indent is deliberately off: while typing, unfinished code has
-- syntax errors and it falls back to column 0, where Neovim's own indent scripts
-- do better (measured in Go, Rust, Vue, JSON, YAML, HTML, shell, TS and CSS).
