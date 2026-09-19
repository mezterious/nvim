-- Debugging: nvim-dap (the DAP client, language-agnostic), nvim-dap-ui
-- (panels: variables, breakpoints, call stack, watches, REPL), and
-- nvim-dap-virtual-text (inline values) -- all generic infrastructure.
-- Everything language-specific is just an `adapter` + `configurations`
-- entry per language, added further down.
--
-- Two ways an adapter gets wired up here:
--   - mason-nvim-dap (for codelldb/delve): it has real, current handlers
--     for these, auto-generating the adapter table from whatever's in
--     `ensure_installed`.
--   - hand-rolled (for js-debug-adapter and Ruby's rdbg): mason-nvim-dap
--     has no working handler for the modern vscode-js-debug setup (only a
--     legacy one), and none at all for Ruby, so those use nvim-dap's own
--     native `server` + `executable` + `port = "${port}"` adapter shape
--     directly (:h dap-adapter) -- the same mechanism mason-nvim-dap's
--     handlers use internally, just written out.
vim.pack.add({
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/nvim-neotest/nvim-nio', -- required by nvim-dap-ui
  'https://github.com/rcarriga/nvim-dap-ui',
  'https://github.com/theHamsta/nvim-dap-virtual-text',
  'https://github.com/jay-babu/mason-nvim-dap.nvim',
})

do
  local registry = require('mason-registry')
  registry.refresh(function()
    local ok, pkg = pcall(registry.get_package, 'js-debug-adapter')
    if ok and not pkg:is_installed() then
      pkg:install()
    end
  end)
end

-- codelldb (Rust/C/C++) and delve (Go): real mason-nvim-dap handlers exist
-- for both, so `handlers = {}` is enough to get adapters + sensible
-- default configurations (including a "debug test" mode for delve) for
-- free -- see mason-nvim-dap's mappings/adapters and mappings/configurations
-- if you want to see exactly what that generates.
require('mason-nvim-dap').setup({
  ensure_installed = { 'codelldb', 'delve' },
  handlers = {},
})

local dap = require('dap')
local dapui = require('dapui')

dapui.setup()
require('nvim-dap-virtual-text').setup()

-- Open/close the UI automatically around a debug session rather than
-- needing a manual toggle every time.
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticError' })
vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DiagnosticWarn' })
vim.fn.sign_define('DapLogPoint', { text = '◆', texthl = 'DiagnosticInfo' })
vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DiagnosticOk' })

-- js-debug-adapter is a single command (a wrapper mason installs around
-- vscode-js-debug's dapDebugServer.js); "${port}" tells nvim-dap to pick a
-- free port, spawn the command with it as an argument, then connect.
dap.adapters['pwa-node'] = {
  type = 'server',
  host = 'localhost',
  port = '${port}',
  executable = {
    command = 'js-debug-adapter',
    args = { '${port}' },
  },
}

-- Two starting points -- the first assumes nothing about *your* project
-- beyond having `tsx` available (installed as a dependency, or globally --
-- either resolves). tsx (esbuild-based) is used here rather than ts-node:
-- ts-node is still common but its `register` hook currently throws on
-- fresh installs paired with current TypeScript versions (confirmed by
-- actually running it while building this config, not just going on
-- reputation) -- tsx doesn't have that problem and is the faster,
-- actively-maintained option regardless. If your project has neither and
-- only ever runs compiled output, point `program` at that instead and drop
-- `runtimeArgs`; sourceMaps will still map back to your .ts source.
for _, language in ipairs({ 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' }) do
  dap.configurations[language] = {
    {
      type = 'pwa-node',
      request = 'launch',
      name = 'Launch file (via tsx)',
      program = '${file}',
      cwd = '${workspaceFolder}',
      runtimeExecutable = 'node',
      runtimeArgs = { '--import', 'tsx' },
      sourceMaps = true,
      protocol = 'inspector',
      skipFiles = { '<node_internals>/**', '**/node_modules/**' },
      resolveSourceMapLocations = { '${workspaceFolder}/**', '!**/node_modules/**' },
    },
    {
      type = 'pwa-node',
      request = 'attach',
      name = 'Attach to process',
      processId = require('dap.utils').pick_process,
      cwd = '${workspaceFolder}',
    },
    {
      -- Runs Vitest's own CLI entry point under node, same adapter as
      -- above -- a Vitest run is just a node process, nothing Vitest- or
      -- Vite-specific about the adapter itself. Debugs the currently open
      -- test file in `run` mode (one pass, not watch) so the session has
      -- a clear end rather than staying alive indefinitely.
      type = 'pwa-node',
      request = 'launch',
      name = 'Debug Vitest tests (current file)',
      runtimeExecutable = 'node',
      runtimeArgs = { './node_modules/vitest/vitest.mjs', 'run', '${file}' },
      rootPath = '${workspaceFolder}',
      cwd = '${workspaceFolder}',
      console = 'integratedTerminal',
      internalConsoleOptions = 'neverOpen',
    },
  }
end

-- Ruby, via rdbg (the `debug` gem's CLI, bundled with modern Ruby -- no
-- separate install). `--open=vscode` is the part that's easy to miss:
-- plain `--open` speaks rdbg's own console protocol, not DAP, and would
-- silently fail to connect. Two variants because whether a project needs
-- `bundle exec` to load the right gems isn't something this config can
-- know either way.
local function rdbg_adapter(callback, config)
  callback({
    type = 'server',
    host = '127.0.0.1',
    port = '${port}',
    executable = {
      command = 'rdbg',
      args = { '--open=vscode', '--port', '${port}', config.program },
    },
  })
end

local function rdbg_bundler_adapter(callback, config)
  callback({
    type = 'server',
    host = '127.0.0.1',
    port = '${port}',
    executable = {
      command = 'rdbg',
      args = { '--open=vscode', '--port', '${port}', '-c', '--', 'bundle', 'exec', 'ruby', config.program },
    },
  })
end

dap.adapters.ruby = rdbg_adapter
dap.adapters.ruby_bundler = rdbg_bundler_adapter

dap.configurations.ruby = {
  { type = 'ruby', name = 'Launch file', request = 'launch', program = '${file}' },
  { type = 'ruby_bundler', name = 'Launch file (via bundle exec)', request = 'launch', program = '${file}' },
}

local map = vim.keymap.set

-- VS Code's function-key scheme -- the one piece of debugger muscle memory
-- that already carries over from basically every other editor.
map('n', '<F5>', dap.continue, { desc = 'Debug: continue/start' })
map('n', '<F9>', dap.toggle_breakpoint, { desc = 'Debug: toggle breakpoint' })
map('n', '<F10>', dap.step_over, { desc = 'Debug: step over' })
map('n', '<F11>', dap.step_into, { desc = 'Debug: step into' })

-- Leader-key twins of F5/F10/F11: macOS often intercepts bare F-keys for
-- media/system functions unless fn is held.
map('n', '<leader>dc', dap.continue, { desc = 'Continue/start' })
map('n', '<leader>dn', dap.step_over, { desc = 'Step over (next)' })
map('n', '<leader>di', dap.step_into, { desc = 'Step into' })
map('n', '<leader>do', dap.step_out, { desc = 'Step out' })
map('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Toggle breakpoint' })
map('n', '<leader>dB', function()
  dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, { desc = 'Conditional breakpoint' })
map('n', '<leader>dr', dap.repl.open, { desc = 'Open REPL' })
map('n', '<leader>dt', dap.terminate, { desc = 'Terminate session' })
map('n', '<leader>du', dapui.toggle, { desc = 'Toggle debug UI' })

pcall(function()
  require('which-key').add({ { '<leader>d', group = 'Debug' } })
end)
