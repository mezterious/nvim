-- Vue support, per nvim-lspconfig's lsp/vtsls.lua docs. vue_ls (hybrid mode) handles
-- templates and styles; TypeScript in .vue files goes through vtsls with
-- @vue/typescript-plugin loaded into its tsserver. vue_ls forwards its requests to
-- vtsls itself (its on_init, from nvim-lspconfig), so it needs no override.
local vue_language_server = vim.fn.expand('$MASON/packages') .. '/vue-language-server/node_modules/@vue/language-server'

---@type vim.lsp.Config
return {
  -- Upstream's list plus 'vue'.
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' },
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          {
            name = '@vue/typescript-plugin',
            location = vue_language_server, -- required
            languages = { 'vue' }, -- must list vue even though it is in filetypes
            configNamespace = 'typescript',
          },
        },
      },
    },
  },
}
