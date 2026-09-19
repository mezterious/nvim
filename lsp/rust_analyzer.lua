-- Not mason-managed: rustup already installs rust-analyzer as a component
-- (confirmed present at ~/.cargo/bin/rust-analyzer), matched to the exact
-- toolchain version in use. Installing a second copy via mason would just
-- risk two versions disagreeing with each other.
--
-- Adapted from nvim-lspconfig's lsp/rust_analyzer.lua (MIT). The bulk of
-- this -- root_dir, the library/sysroot detection -- exists to make
-- "go to definition" work into the Cargo registry and stdlib source, and
-- to support cargo workspaces properly; trimming it would trade away real
-- functionality, unlike lua_ls where the equivalent trim was safe.
local function executable_exists(command)
  local exists = vim.fn.executable(command) == 1
  if not exists then
    vim.notify_once(('[rust_analyzer] %s not found.'):format(command), vim.log.levels.WARN)
  end
  return exists
end

local function user_sysroot_src()
  return vim.tbl_get(vim.lsp.config['rust_analyzer'], 'settings', 'rust-analyzer', 'cargo', 'sysrootSrc')
end

local function default_sysroot_src()
  local sysroot = vim.tbl_get(vim.lsp.config['rust_analyzer'], 'settings', 'rust-analyzer', 'cargo', 'sysroot')
  if not sysroot then
    local result = vim.system({ 'cargo', '-Z', 'unstable-options', 'rustc', '--print', 'sysroot' }, { text = true }):wait()
    if result.code == 0 and result.stdout then
      sysroot = vim.trim(result.stdout)
    end
  end
  return sysroot and vim.fs.joinpath(sysroot, 'lib/rustlib/src/rust/library') or nil
end

local function is_library(fname)
  local user_home = vim.fs.normalize(vim.env.HOME)
  local cargo_home = os.getenv('CARGO_HOME') or user_home .. '/.cargo'
  local registry = cargo_home .. '/registry/src'
  local git_registry = cargo_home .. '/git/checkouts'
  local rustup_home = os.getenv('RUSTUP_HOME') or user_home .. '/.rustup'
  local toolchains = rustup_home .. '/toolchains'
  local sysroot_src = user_sysroot_src() or default_sysroot_src()

  for _, item in ipairs({ toolchains, registry, git_registry, sysroot_src }) do
    if item and vim.fs.relpath(item, fname) then
      local clients = vim.lsp.get_clients({ name = 'rust_analyzer' })
      return #clients > 0 and clients[#clients].config.root_dir or nil
    end
  end
end

return {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_dir = function(bufnr, on_dir)
    if not executable_exists('cargo') then
      return
    end
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local reused_dir = is_library(fname)
    if reused_dir then
      on_dir(reused_dir)
      return
    end

    local cargo_crate_dir = vim.fs.root(fname, { 'Cargo.toml' })
    if cargo_crate_dir == nil then
      on_dir(vim.fs.root(fname, { 'rust-project.json' }) or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1]))
      return
    end

    local cmd = { 'cargo', 'metadata', '--no-deps', '--format-version', '1', '--manifest-path', cargo_crate_dir .. '/Cargo.toml' }
    vim.system(cmd, { text = true }, function(output)
      local cargo_workspace_root
      if output.code == 0 and output.stdout then
        local result = vim.json.decode(output.stdout)
        if result.workspace_root then
          cargo_workspace_root = vim.fs.normalize(result.workspace_root)
        end
      end
      on_dir(cargo_workspace_root or cargo_crate_dir)
    end)
  end,
  capabilities = {
    experimental = {
      serverStatusNotification = true,
      commands = {
        commands = { 'rust-analyzer.showReferences', 'rust-analyzer.runSingle' },
      },
    },
  },
  settings = {
    ['rust-analyzer'] = {
      lens = {
        enable = true,
        debug = { enable = true },
        implementations = { enable = true },
        references = {
          adt = { enable = true },
          enumVariant = { enable = true },
          method = { enable = true },
          trait = { enable = true },
        },
        run = { enable = true },
        updateTest = { enable = true },
      },
    },
  },
  before_init = function(init_params, config)
    -- rust-analyzer wants its settings as initializationOptions, not the
    -- generic LSP `settings` request most servers use.
    if config.settings and config.settings['rust-analyzer'] then
      init_params.initializationOptions = config.settings['rust-analyzer']
    end
    ---@param command { title: string, command: string, arguments: any[] }
    vim.lsp.commands['rust-analyzer.runSingle'] = function(command)
      local r = command.arguments[1]
      local cmd = { 'cargo', unpack(r.args.cargoArgs) }
      if r.args.executableArgs and #r.args.executableArgs > 0 then
        vim.list_extend(cmd, { '--', unpack(r.args.executableArgs) })
      end
      local result = vim.system(cmd, { cwd = r.args.cwd, env = r.args.environment }):wait()
      if result.code == 0 then
        vim.notify(result.stdout, vim.log.levels.INFO)
      else
        vim.notify(result.stderr, vim.log.levels.ERROR)
      end
    end
    -- Note: the "▶ Debug" code lens (rust-analyzer.debugSingle) isn't wired
    -- up here -- doing it correctly means parsing cargo's JSON build
    -- output to find the exact compiled artifact path (what tools like
    -- rustaceanvim actually do), not guessing at a filename. Left out
    -- rather than shipped half-working; F5 + the "LLDB: Launch" config
    -- (prompts for the executable path) covers debugging in the meantime.
  end,
  on_attach = function(_, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, 'LspCargoReload', function()
      local clients = vim.lsp.get_clients({ bufnr = bufnr, name = 'rust_analyzer' })
      for _, client in ipairs(clients) do
        vim.notify('Reloading Cargo workspace')
        client:request('rust-analyzer/reloadWorkspace', nil, function(err)
          if err then
            error(tostring(err))
          end
          vim.notify('Cargo workspace reloaded')
        end, 0)
      end
    end, { desc = 'Reload current cargo workspace' })
  end,
}
