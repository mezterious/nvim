-- Debugging: nvim-dap (the client) with nvim-dap-view (the panel). Adapters are
-- installed by Mason (plugins/mason.lua); .vscode/launch.json is read automatically.
vim.pack.add({
  'https://github.com/mfussenegger/nvim-dap',
  -- Pinned to v1, as the nvim-dap-view README shows for vim.pack.
  { src = 'https://github.com/igorlfs/nvim-dap-view', version = vim.version.range('1.*') },
})

-- Open the panel when a session starts and close it when the session ends.
require('dap-view').setup({ auto_toggle = true })

local dap = require('dap')

-- Microsoft's js-debug, which Mason installs as `js-debug-adapter`. nvim-dap starts it
-- on a free port for each session. It listens on IPv6 (::1) only, so the host must
-- be 'localhost' (nvim-dap's default, 127.0.0.1, is refused).
dap.adapters['pwa-node'] = {
  type = 'server',
  host = 'localhost',
  port = '${port}',
  executable = { command = 'js-debug-adapter', args = { '${port}' } },
}

local node_configurations = {
  -- Node 22.18+/23.6+ runs .ts files directly (type stripping), so this covers TypeScript.
  {
    type = 'pwa-node',
    request = 'launch',
    name = 'Node: launch current file',
    program = '${file}',
    cwd = '${workspaceFolder}',
    skipFiles = { '<node_internals>/**' },
  },
  -- For a process started with `node --inspect`. (Attaching by process id didn't work.)
  {
    type = 'pwa-node',
    request = 'attach',
    name = 'Node: attach (port 9229)',
    port = 9229,
    cwd = '${workspaceFolder}',
  },
}
for _, filetype in ipairs({ 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }) do
  dap.configurations[filetype] = node_configurations
end

-- Delve speaks DAP itself (`dlv dap`); nvim-dap starts it on a free port per session.
dap.adapters.delve = {
  type = 'server',
  port = '${port}',
  executable = { command = 'dlv', args = { 'dap', '-l', '127.0.0.1:${port}' }, detached = vim.fn.has('win32') == 0 },
}

-- The current file's package directory, built from its module root (`dlvCwd`), so it
-- works from any directory and in repos holding several modules. Not `${file}`, so
-- code split across files in a package builds. nvim-dap calls function values at launch.
local function go_package_dir()
  return vim.fs.dirname(vim.api.nvim_buf_get_name(0))
end

local function go_module_root()
  return vim.fs.root(0, 'go.mod') or vim.fn.getcwd()
end

dap.configurations.go = {
  {
    type = 'delve',
    request = 'launch',
    name = 'Go: debug package',
    program = go_package_dir,
    dlvCwd = go_module_root,
  },
  {
    type = 'delve',
    request = 'launch',
    name = 'Go: debug package tests',
    mode = 'test',
    program = go_package_dir,
    dlvCwd = go_module_root,
  },
}

local function map(lhs, rhs, desc, mode)
  vim.keymap.set(mode or 'n', lhs, rhs, { desc = desc })
end

map('<leader>db', dap.toggle_breakpoint, 'Toggle breakpoint')
map('<leader>dB', function()
  dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, 'Conditional breakpoint')
map('<leader>dc', dap.continue, 'Continue / start')
map('<leader>dC', dap.run_to_cursor, 'Run to cursor')
map('<leader>dn', dap.step_over, 'Step over')
map('<leader>di', dap.step_into, 'Step into')
map('<leader>do', dap.step_out, 'Step out')
map('<leader>dl', dap.run_last, 'Run last')
map('<leader>dt', dap.terminate, 'Terminate')
map('<leader>du', '<Cmd>DapViewToggle<CR>', 'Toggle debug panel')
map('<leader>dh', function()
  require('dap.ui.widgets').hover()
end, 'Hover value', { 'n', 'v' })
