-- Override for nvim-lspconfig's lua_ls, from its docs: LuaJIT plus Neovim's
-- runtime, unless the project has its own .luarc.json.
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

    -- Assign in place: replacing `settings` never reaches the server. `Lua` is
    -- typed as any LSP value, but it's the table declared below.
    local lua = client.config.settings.Lua
    ---@cast lua table
    client.config.settings.Lua = vim.tbl_deep_extend('force', lua, {
      runtime = {
        version = 'LuaJIT',
        -- resolve require() like Neovim (:h lua-module-load)
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          -- lspconfig's settings type annotations
          vim.api.nvim_get_runtime_file('lua/lspconfig', false)[1],
        },
      },
    })
  end,
  settings = {
    Lua = {},
  },
}
