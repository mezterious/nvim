-- Adapted from nvim-lspconfig's lsp/gopls.lua (MIT). The custom root_dir
-- (rather than plain root_markers) exists so files inside the module
-- cache / stdlib -- opened via "go to definition" into a dependency --
-- resolve to the *original* project's root instead of failing to attach.
local mod_cache = nil
local std_lib = nil

local function identify_go_dir(envvar_id, custom_subdir, on_complete)
  vim.system({ 'go', 'env', envvar_id }, { text = true }, function(output)
    local res = vim.trim(output.stdout or '')
    if output.code == 0 and res ~= '' then
      on_complete((custom_subdir and (res .. custom_subdir)) or res)
    else
      on_complete(nil)
    end
  end)
end

local function get_std_lib_dir()
  if std_lib and std_lib ~= '' then
    return std_lib
  end
  identify_go_dir('GOROOT', '/src', function(dir)
    std_lib = dir
  end)
  return std_lib
end

local function get_mod_cache_dir()
  if mod_cache and mod_cache ~= '' then
    return mod_cache
  end
  identify_go_dir('GOMODCACHE', nil, function(dir)
    mod_cache = dir
  end)
  return mod_cache
end

local function get_root_dir(fname)
  for _, cache_dir in ipairs({ mod_cache, std_lib }) do
    if cache_dir and fname:sub(1, #cache_dir) == cache_dir then
      local clients = vim.lsp.get_clients({ name = 'gopls' })
      if #clients > 0 then
        return clients[#clients].config.root_dir
      end
    end
  end
  return vim.fs.root(fname, 'go.work') or vim.fs.root(fname, 'go.mod') or vim.fs.root(fname, '.git')
end

return {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    get_mod_cache_dir()
    get_std_lib_dir()
    on_dir(get_root_dir(fname))
  end,
  settings = {
    gopls = {
      -- gopls stopped advertising semantic tokens by default since v0.22;
      -- this restores highlighting quality to what it was before that.
      semanticTokens = true,
    },
  },
}
