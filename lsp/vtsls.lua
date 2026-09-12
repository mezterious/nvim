-- TypeScript/JavaScript, via vtsls rather than ts_ls: vtsls exposes the
-- `globalPlugins` hook that lets a Vue project's <script> blocks get typed
-- by loading @vue/typescript-plugin into the same tsserver instance (see
-- lsp/vue_ls.lua for the other half of this pairing). Don't also enable
-- ts_ls -- the two would fight over the same filetypes.
--
-- Adapted from nvim-lspconfig's lsp/vtsls.lua and lsp/ts_ls.lua (MIT); the
-- root_dir logic is trimmed of an `nvim-0.11.3` version-check branch since
-- this config always targets current Neovim.
local vue_language_server_path = require('mason-registry').get_package('vue-language-server'):get_install_path()
  .. '/node_modules/@vue/language-server'

return {
  cmd = { 'vtsls', '--stdio' },
  init_options = { hostInfo = 'neovim' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' },
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          {
            name = '@vue/typescript-plugin',
            location = vue_language_server_path,
            languages = { 'vue' },
            configNamespace = 'typescript',
          },
        },
      },
    },
  },
  -- Finds the nearest package-manager lockfile so monorepos resolve to the
  -- right package root, and steps aside entirely for Deno projects (which
  -- use their own LSP, not vtsls).
  root_dir = function(bufnr, on_dir)
    local lockfile_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
    local project_root = vim.fs.root(bufnr, { lockfile_markers, { '.git' } })
    local deno_root = vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc' })
    local deno_lock_root = vim.fs.root(bufnr, { 'deno.lock' })

    if deno_lock_root and (not project_root or #deno_lock_root > #project_root) then
      return -- deno.lock is closer than any package-manager lockfile
    end
    if deno_root and (not project_root or #deno_root >= #project_root) then
      return -- deno.json is closer than or equal to any package-manager lockfile
    end

    on_dir(project_root or vim.fn.getcwd())
  end,
}
