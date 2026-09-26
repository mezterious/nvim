-- Overrides on top of nvim-lspconfig's lsp/lua_ls.lua (merged; after/ wins).
-- From the "Neovim" example in that file's docs: when the project has no
-- .luarc.json of its own, tell lua_ls this is LuaJIT with Neovim's runtime.
---@type vim.lsp.Config
return {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath('config')
        and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    -- Assigned in place on the existing settings table (replacing the table
    -- itself never reaches the server). `Lua` is typed as "any LSP value", but
    -- it is the table declared in `settings` below, so tell lua_ls that.
    local lua = client.config.settings.Lua
    ---@cast lua table
    client.config.settings.Lua = vim.tbl_deep_extend('force', lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using (most
        -- likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          -- For LSP Settings Type Annotations: https://github.com/neovim/nvim-lspconfig#lsp-settings-type-annotations
          vim.api.nvim_get_runtime_file('lua/lspconfig', false)[1],
        },
      },
    })
  end,
  settings = {
    Lua = {},
  },
}
