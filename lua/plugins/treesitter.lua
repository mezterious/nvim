-- Parser-based syntax highlighting.
--
-- nvim-treesitter (main branch) is a thin manager around Neovim's built-in
-- treesitter: it installs/updates parsers, and the *editor* enables
-- highlighting itself via vim.treesitter.start(). There's no
-- setup({ highlight = { enable = true } }) anymore -- that was the old
-- (pre-rewrite) API.

-- Parsers are pinned to the revisions in nvim-treesitter's own parsers.lua, so
-- they only need refreshing when the *plugin* changes -- vim.pack.update()
-- doesn't touch parser binaries. The vim.pack equivalent of lazy.nvim's
-- `build = ':TSUpdate'`: after this plugin is updated, run update(), which
-- reloads the pins and rebuilds only the parsers that no longer match.
-- It's asynchronous; restart afterwards so open buffers pick up new parsers.
-- Failures are reported, not swallowed: upstream's update() throws for *every*
-- language if any installed parser lacks its `.revision` record (what an
-- interrupted install leaves behind), and a fire-and-forget call would hide it.
-- Registered before vim.pack.add(), as the vim.pack docs advise for hooks.
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

-- Parsers to have on disk. Neovim's own build already bundles a few
-- (c, lua, markdown, query, vim, vimdoc) but installing them here too is
-- harmless -- install() skips anything already present.
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

-- Highlighting is switched on per filetype in ftplugin/<filetype>.lua (the
-- plugin's documented approach): each file calls vim.treesitter.start(), wrapped
-- in pcall so a filetype whose parser isn't installed yet (first launch) is a
-- no-op rather than an error. Neovim already starts it itself for lua, markdown
-- and help. To highlight another language: add its parser above and an
-- ftplugin/<filetype>.lua containing the same two lines.
--
-- Tree-sitter *indent* is deliberately NOT enabled, even though the plugin
-- offers it (experimental upstream). It re-indents finished code well, but while
-- typing -- an unclosed `{`, `(` or tag, so the syntax tree has errors -- it
-- falls back to column 0 where Neovim's own indent scripts get it right. Measured
-- pressing Enter after an unclosed block: worse in Go, Rust, Vue, JSON, YAML, HTML
-- and shell, and even in TypeScript object literals, JSX and CSS. A formatter
-- (<leader>lf) is the better tool for restructuring finished code anyway.
