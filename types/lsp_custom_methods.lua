---@meta
-- Type-only file: never required at runtime, only read by lua_ls.
--
-- Neovim types the method-name parameter of Client:request()/:notify() as a
-- closed union of standard LSP methods (even the raw rpc layer is typed the
-- same way, so there is no untyped alternative). Servers legitimately add
-- custom methods, so we extend the alias here, one entry per method: typos
-- and undeclared methods are still flagged, unlike a blanket
-- `disable-next-line` at each call site.
--
-- lua_ls has no syntax for extending an alias, and re-declaring one triggers
-- duplicate-doc-alias -- expected here, hence the file-level disable.
---@diagnostic disable: duplicate-doc-alias

---@alias vim.lsp.protocol.Method.ClientToServer.Request
---| 'rust-analyzer/reloadWorkspace' # lsp/rust_analyzer.lua (:LspCargoReload)

---@alias vim.lsp.protocol.Method.ClientToServer.Notification
---| 'tsserver/response' # lsp/vue_ls.lua (forwarding tsserver replies)
