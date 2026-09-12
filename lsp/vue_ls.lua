-- Vue's own language server only handles the <template>/<style> side of a
-- .vue file ("hybrid mode", since v3 dropped the old standalone/takeover
-- mode). TypeScript inside <script> is actually handled by vtsls, via the
-- @vue/typescript-plugin loaded in lsp/vtsls.lua -- this on_init is what
-- forwards vue_ls's tsserver requests to that vtsls client so the two
-- cooperate on a single .vue file.
--
-- Adapted from nvim-lspconfig's lsp/vue_ls.lua (MIT), simplified to only
-- look for a `vtsls` client (upstream also tries `ts_ls`/`typescript-tools`,
-- which we don't use here). See https://github.com/vuejs/language-tools/wiki/Neovim.
return {
  cmd = { 'vue-language-server', '--stdio' },
  filetypes = { 'vue' },
  root_markers = { 'package.json', '.git' },
  on_init = function(client)
    local retries = 0

    local function forward_to_vtsls(_, result, context)
      local vtsls_client = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })[1]

      if not vtsls_client then
        -- vtsls can attach a moment after vue_ls does; retry briefly.
        if retries <= 10 then
          retries = retries + 1
          vim.defer_fn(function()
            forward_to_vtsls(_, result, context)
          end, 100)
        else
          vim.notify('vue_ls: no `vtsls` client found to forward TypeScript requests to.', vim.log.levels.ERROR)
        end
        return
      end

      local id, command, payload = unpack(unpack(result))
      vtsls_client:exec_cmd({
        title = 'vue_request_forward',
        command = 'typescript.tsserverRequest',
        arguments = { command, payload },
      }, { bufnr = context.bufnr }, function(_, response)
        client:notify('tsserver/response', { { id, response and response.body } })
      end)
    end

    client.handlers['tsserver/request'] = forward_to_vtsls
  end,
}
