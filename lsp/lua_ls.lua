-- lua-language-server config. Lives here (top-level lsp/, not lua/lsp/)
-- because vim.lsp.enable('lua_ls') looks for lsp/lua_ls.lua on
-- 'runtimepath' -- the same convention as ftplugin/, syntax/, etc.
return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      workspace = {
        -- Know about Neovim's own runtime Lua (vim.*, vim.fn.*, ...) so
        -- editing this config gets correct completion/diagnostics for it.
        --
        -- Deliberately just $VIMRUNTIME, not
        -- vim.api.nvim_get_runtime_file('', true): the latter enumerates
        -- every directory on 'runtimepath', including every installed
        -- plugin's own Lua files (700+ files here, vs ~170 for VIMRUNTIME
        -- alone) -- and grows every time a plugin is added. lua_ls has to
        -- fully index whatever's listed here before it publishes any
        -- diagnostics, so that difference is the gap between "diagnostics
        -- within a couple of seconds" and "diagnostics after tens of
        -- seconds, getting slower as the config grows".
        library = { vim.env.VIMRUNTIME },
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
}
